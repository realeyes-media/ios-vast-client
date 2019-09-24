//
//  VastTrackerNonLinear.swift
//  VastClient
//
//  Created by Austin Christensen on 9/16/19.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.
//

import Foundation

public protocol VastTrackerNonLinearDelegate: AnyObject {
    func adBreakStart(vastTracker: VastTrackerNonLinear)
    func adBreakComplete(vastTracker: VastTrackerNonLinear)
}

public class VastTrackerNonLinear {
    public weak var delegate: VastTrackerNonLinearDelegate?
    
    public let id: String
    public let vastModel: VastModel
    public let totalAds: Int
    public let startTime: Double
    
    @available(*, message: "do not use VastTracker for storing this model, it is not being used")
    public var vmapModel: VMAPModel?
    
    private var trackingStatus: TrackingStatus = .unknown
    private var currentTime = 0.0
    private var comparisonTime: Double {
        if trackProgressCumulatively {
            // playhead
            return max(0.0, floor(currentTime - startTime - completedAdAccumulatedDuration))
        } else {
            return currentTime - startTime
        }
    }
    private var vastAds: [VastAd]
    private let trackerModel: TrackerModel
    private var completedAdAccumulatedDuration = 0.0
    private var currentNonlinearTrackingCreative: NonlinearTrackingCreative?
    
    private var adBreakStarted = false
    private let trackProgressCumulatively: Bool
    
    public init(id: String, vastModel: VastModel, startTime: Double = 0.0, supportAdBuffets: Bool = false, delegate: VastTrackerNonLinearDelegate? = nil, trackProgressCumulatively: Bool = true) {
        self.id = id
        self.startTime = startTime
        self.vastModel = vastModel
        self.trackerModel = VastTrackerNonLinear.getTrackerModel(from: vastModel)
        self.vastAds = VastTrackerNonLinear.getAds(from: trackerModel)
        self.trackingStatus = .tracking
        self.delegate = delegate
        self.totalAds = self.vastAds.count
        self.trackProgressCumulatively = trackProgressCumulatively
    }
    
    // TODO: this should be removed in the future. Please, store the VMAPModel elsewhere and initialize this class with only one VastModel
    @available(*, message: "Use init(id:,vastModel:) instead")
    public convenience init(id: String, vmapModel: VMAPModel, breakId: String, startTime: Double, supportAdBuffets: Bool = false, delegate: VastTrackerNonLinearDelegate? = nil) throws {
        guard let adBreak = vmapModel.adBreaks.first(where: { $0.breakId == breakId }), let vastModel = adBreak.adSource?.vastAdData else {
            throw TrackingError.MissingAdBreak
        }
        self.init(id: id, vastModel: vastModel, startTime: startTime, supportAdBuffets: supportAdBuffets, delegate: delegate)
        self.vmapModel = vmapModel
    }
    
    private static func getTrackerModel(from vastModel: VastModel) -> TrackerModel {
        var includesStandAlone = false
        var includesPod = false
        
        vastModel.ads.forEach { ad in
            if ad.sequence != nil {
                includesPod = true
            } else {
                includesStandAlone = true
            }
        }
        let type: TrackerModelType
        switch (includesStandAlone, includesPod) {
        case (true, true):
            type = .adBuffet
        case (_ , true):
            type = .adPod
        default:
            type = .standAlone
        }
        return TrackerModel(type: type, vastModel: vastModel)
    }
    
    private static func getAds(from trackerModel: TrackerModel) -> [VastAd] {
        switch trackerModel.type {
        case .standAlone, .adBuffet:
            guard let ad = trackerModel.vastModel.ads.first(where: { $0.creatives.contains(where: { $0.linear != nil }) }) else {
                return []
            }
            return [ad]
        case .adPod:
            return trackerModel.vastModel.ads
                .filter { $0.sequence != nil }
                .filter { $0.creatives.contains(where: { $0.nonLinearAds != nil })}
                .sorted(by: { $0.sequence ?? 0 < $1.sequence ?? 0 })
        }
    }
    
    public func updateProgress(time: Double) throws {
        var message = "Cannot update tracking progress."
        guard trackingStatus == .tracking || trackingStatus == .paused else {
            switch trackingStatus {
            case .errored:
                message += "Status is errored"
            case .complete:
                throw TrackingError.unableToUpdateProgressTrackingComplete
            default:
                message += "Status is unknown"
            }
            throw TrackingError.unableToUpdateProgress(msg: message)
        }
        currentTime = time
        
        if trackingStatus == .paused {
            // TODO: vast resume
            trackingStatus = .tracking
        }
        
        if currentNonlinearTrackingCreative == nil {
            guard let vastAd = vastAds.first,
                let nonlinearCreative = vastAd.creatives.first?.nonLinearAds, vastAd.sequence ?? 1 > 0 else {
                    trackingStatus = .complete
                    delegate?.adBreakComplete(vastTracker: self)
                    return
            }
            
            currentNonlinearTrackingCreative = NonlinearTrackingCreative(creative: nonlinearCreative, vastAd: vastAd)
        }
        
        guard var creative = currentNonlinearTrackingCreative else {
            trackingStatus = .errored
            throw TrackingError.internalError(msg: "Unable to find current creative to track")
        }
        
        if !adBreakStarted {
            adBreakStarted = true
            delegate?.adBreakStart(vastTracker: self)
        }

        if !creative.trackedStart {
            creative.trackedStart = true

            let impressions = creative.vastAd.impressions.compactMap { $0.url }
            track(urls: impressions, eventName: "IMPRESSIONS")
        }
        
        currentNonlinearTrackingCreative = creative
    }
    
    public func adBreakCompleted() throws {
         delegate?.adBreakComplete(vastTracker: self)
    }
}
