//
//  VastTracker.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public protocol VastTrackerDelegate: AnyObject {
    func adBreakStart(vastTracker: VastTracker)
    func adStart(vastTracker: VastTracker, ad: VastAd)
    func adFirstQuartile(vastTracker: VastTracker, ad: VastAd)
    func adMidpoint(vastTracker: VastTracker, ad: VastAd)
    func adThirdQuartile(vastTracker: VastTracker, ad: VastAd)
    func adComplete(vastTracker: VastTracker, ad: VastAd)
    func adBreakComplete(vastTracker: VastTracker)
}

enum TrackerModelType {
    case standAlone
    case adPod
    case adBuffet
}

public struct TrackerModel {
    let type: TrackerModelType
    let vastModel: VastModel
}

public class VastTracker {
    public weak var delegate: VastTrackerDelegate?
    
    public let id: String
    public let vastModel: VastModel
    public let totalAds: Int
    private var vmapModel: VMAPModel?
    private var vmapAdBreak: VMAPAdBreak?

    private var trackingStatus: TrackingStatus = .unknown
    private let startTime: Double
    private var currentTime = 0.0
    private var playhead: Double {
        get {
            return max(0.0, floor(currentTime - startTime - completedAdAccumulatedDuration))
        }
    }
    private var vastAds: [VastAd]
    private let trackerModel: TrackerModel
    private var completedAdAccumulatedDuration = 0.0
    private var currentTrackingCreative: TrackingCreative?

    public init(id: String, vastModel: VastModel, startTime: Double, supportAdBuffets: Bool = false, delegate: VastTrackerDelegate? = nil) {
        self.id = id
        self.startTime = startTime
        self.vastModel = vastModel
        self.trackerModel = VastTracker.getTrackerModel(from: vastModel)
        self.vastAds = VastTracker.getAds(from: trackerModel)
        self.trackingStatus = .tracking
        self.delegate = delegate
        self.totalAds = self.vastAds.count
        
        // FIXME: this will not work correctly for convenience init and also, ad break for VMAP with multiple ad breaks and time offsets will also not work as expected
        delegate?.adBreakStart(vastTracker: self)
    }
    
    public convenience init(id: String, vmapModel: VMAPModel, breakId: String, startTime: Double, supportAdBuffets: Bool = false, delegate: VastTrackerDelegate? = nil) throws {
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
                .filter { $0.creatives.contains(where: { $0.linear != nil })}
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

        if currentTrackingCreative == nil {
            guard let vastAd = vastAds.first,
                let linearCreative = vastAd.creatives.first?.linear, vastAd.sequence ?? 1 > 0 else {
                    trackingStatus = .complete
                    delegate?.adBreakComplete(vastTracker: self)
                    return
            }

            currentTrackingCreative = TrackingCreative(creative: linearCreative, vastAd: vastAd)
        }

        guard var creative = currentTrackingCreative else {
            trackingStatus = .errored
            throw TrackingError.internalError(msg: "Unable to find current creative to track")
        }

        let progressUrls = creative.creative.trackingEvents
            .filter { $0.type == .progress && !$0.tracked && $0.url != nil }
            .filter { event -> Bool in
                if var offset = event.offset {
                    if offset > 0 && offset < 1 {
                        offset = creative.duration * offset
                    }
                    if time >= offset {
                        return true
                    }
                } else {
                    return true
                }
                return false
            }
            .map { event -> URL in
                return event.url!
            }

        if progressUrls.count > 0 {
            progressUrls.forEach { url in
                guard let idx = creative.creative.trackingEvents.index(where: { $0.url == url }) else { return }
                creative.creative.trackingEvents[idx].tracked = true
            }
            creative.callTrackingUrls(progressUrls)
        }

        guard playhead < creative.duration else {
            return
        }
        
        // FIXME: this will possibly track start of ad even for ad that has time offset and should not be starting for some time
        if !creative.trackedStart {
            creative.trackedStart = true
            
            let impressions = creative.vastAd.impressions.filter { $0.url != nil }.map { $0.url! }
            let trackingUrls = creative.creative.trackingEvents
                .filter { ($0.type == .creativeView || $0.type == .start) && $0.url != nil }
                .map { $0.url! }
            creative.callTrackingUrls(impressions + trackingUrls)
            delegate?.adStart(vastTracker: self, ad: creative.vastAd)
        }
        
        if playhead > creative.firstQuartile && playhead < creative.midpoint {
            if !creative.trackedFirstQuartile {
                creative.trackedFirstQuartile = true
                let trackingUrls = creative.creative.trackingEvents
                    .filter { $0.type == .firstQuartile && $0.url != nil }
                    .map { $0.url! }
                creative.callTrackingUrls(trackingUrls)
                delegate?.adFirstQuartile(vastTracker: self, ad: creative.vastAd)
            }
        } else if playhead > creative.midpoint && playhead < creative.thirdQuartile {
            if !creative.trackedMidpoint {
                creative.trackedMidpoint = true
                let trackingUrls = creative.creative.trackingEvents
                    .filter { $0.type == .midpoint && $0.url != nil }
                    .map { $0.url! }
                creative.callTrackingUrls(trackingUrls)
                delegate?.adMidpoint(vastTracker: self, ad: creative.vastAd)
            }
        } else if playhead > creative.thirdQuartile && playhead < creative.duration {
            if !creative.trackedThirdQuartile {
                creative.trackedThirdQuartile = true
                let trackingUrls = creative.creative.trackingEvents
                    .filter { $0.type == .thirdQuartile && $0.url != nil }
                    .map { $0.url! }
                creative.callTrackingUrls(trackingUrls)
                delegate?.adThirdQuartile(vastTracker: self, ad: creative.vastAd)
            }
        }
        
        currentTrackingCreative = creative
    }
    
    public func finishedPlayback() throws {
        guard var creative = currentTrackingCreative else {
            trackingStatus = .errored
            throw TrackingError.internalError(msg: "Unable to find current creative to track")
        }
        
        if !creative.trackedComplete && creative.trackedStart {
            creative.trackedComplete = true
            let trackingUrls = creative.creative.trackingEvents
                .filter { $0.type == .complete }
                .compactMap { $0.url }
            creative.callTrackingUrls(trackingUrls)
            delegate?.adComplete(vastTracker: self, ad: creative.vastAd)
            completedAdAccumulatedDuration += creative.duration
        }
        
        try tryToPlayNext()
    }

    public func paused(_ val: Bool) throws {
        if let creative = currentTrackingCreative {
            let trackingUrls = creative.creative.trackingEvents
                .filter { event in
                    let type = val ? event.type == .pause : event.type == .resume
                    return type && event.url != nil
                }
                .map { $0.url! }
            creative.callTrackingUrls(trackingUrls)
        } else {
            throw TrackingError.internalError(msg: "Unable to find current creative to track")
        }
    }

    public func fullscreen(_ val: Bool) throws {
        if let creative = currentTrackingCreative {
            let trackingUrls = creative.creative.trackingEvents
                .filter { event in
                    let type = val ? event.type == .fullscreen || event.type == .playerExpand : event.type == .resume || event.type == .playerCollapse
                    return type && event.url != nil
                }
                .map { $0.url! }
            creative.callTrackingUrls(trackingUrls)
        } else {
            throw TrackingError.internalError(msg: "Unable to find current creative to track")
        }
    }

    public func rewind() throws {
        if let creative = currentTrackingCreative {
            let trackingUrls = creative.creative.trackingEvents
                .filter { $0.type == .rewind && $0.url != nil }
                .map { $0.url! }
            creative.callTrackingUrls(trackingUrls)
        } else {
            throw TrackingError.internalError(msg: "Unable to find current creative to track")
        }
    }

    public func muted(_ val: Bool) throws {
        if let creative = currentTrackingCreative {
            let trackingUrls = creative.creative.trackingEvents
                .filter { event in
                    let type = val ? event.type == .mute : event.type == .unmute
                    return type && event.url != nil
                }
                .map { $0.url! }
            creative.callTrackingUrls(trackingUrls)
        } else {
            throw TrackingError.internalError(msg: "Unable to find current creative to track")
        }
    }
    
    private func tryToPlayNext() throws {
        vastAds.removeFirst()
        currentTrackingCreative = nil
        if vastAds.count > 0 {
            try updateProgress(time: 0.0) // FIXME: THIS MIGHT BE WRONG WHEN PLAYHEAD IS USED
        } else {
            trackingStatus = .complete
            delegate?.adBreakComplete(vastTracker: self)
        }
    }

    public func skip() throws {
        if let creative = currentTrackingCreative {
            guard let skipOffset = creative.vastAd.creatives.first?.linear?.skipOffset?.toSeconds, skipOffset < playhead else {
                throw TrackingError.unableToSkipAdAtThisTime
            }
            
            let trackingUrls = creative.creative.trackingEvents
                .filter { $0.type == .skip && $0.url != nil }
                .map { $0.url! }
            creative.callTrackingUrls(trackingUrls)
            
            completedAdAccumulatedDuration += creative.duration
            try tryToPlayNext()
        } else {
            throw TrackingError.internalError(msg: "Unable to find current creative to track")
        }
    }

    public func acceptedLinearInvitation() throws {
        if let creative = currentTrackingCreative {
            let trackingUrls = creative.creative.trackingEvents
                .filter { $0.type == .acceptInvitationLinear && $0.url != nil }
                .map { $0.url! }
            creative.callTrackingUrls(trackingUrls)
        } else {
            throw TrackingError.internalError(msg: "Unable to find current creative to track")
        }
    }

    public func closed() throws {
        if let creative = currentTrackingCreative {
            let trackingUrls = creative.creative.trackingEvents
                .filter { $0.type == .closeLinear && $0.url != nil }
                .map { $0.url! }
            creative.callTrackingUrls(trackingUrls)
        } else {
            throw TrackingError.internalError(msg: "Unable to find current creative to track")
        }
    }

    public func clicked() throws -> URL? {
        if let trackingCreative = currentTrackingCreative {
            trackClicks(for: trackingCreative)
            
            return trackingCreative.creative.videoClicks.first(where: { $0.type == .clickThrough })?.url
        } else {
            // TODO: determine if this is an error or complete
            throw TrackingError.unableToProvideCreativeClickThroughUrls
        }
    }
    
    public func clickedWithCustomAction() throws -> [URL] {
        if let trackingCreative = currentTrackingCreative {
            trackClicks(for: trackingCreative)
            
            return trackingCreative.creative.videoClicks
                .filter { $0.type == .customClick }
                .compactMap { $0.url }
        } else {
            // TODO: determine if this is an error or complete
            throw TrackingError.unableToProvideCreativeClickThroughUrls
        }
    }
    
    private func trackClicks(for creative: TrackingCreative) {
        let clickUrls = creative.creative.videoClicks
            .filter { $0.type == .clickTracking }
            .compactMap { $0.url }
        creative.callTrackingUrls(clickUrls)
    }

    public func error(withReason code: VastErrorCodes?) throws {
        if let creative = currentTrackingCreative {
            let urls = creative.vastAd.errors.map { error -> URL in
                if let c = code {
                    return error.withErrorCode(c)
                }
                return error
            }
            creative.callTrackingUrls(urls)
        } else {
            throw TrackingError.internalError(msg: "Unable to find current creative to track")
        }
    }
    
    /*
     Call ViewableImpression urls depending on type of viewability
     
     Host app has to decide on when to call this function.
 
     The point at which these tracking resource files are pinged depends on the viewability standards against which the publisher is certified or any alternate standards document for the transaction between the publisher and advertiser. At the time of this Vast 4.0 specification release, the Media Ratings Council (MRC) had published video viewability recommendations for counting a video ad view after 50% of the ad's pixels are in view for at least two seconds. Publishers should disclose their process for tracking viewable video impressions.
     */
    public func trackViewability(type: VastViewableImpressionType) throws {
        func viewableImpressionUrls(type: VastViewableImpressionType, viewableImpression: VastViewableImpression) -> [URL] {
            switch type {
            case .viewable:
                return viewableImpression.viewable
            case .notViewable:
                return viewableImpression.notViewable
            case .viewUndetermined:
                return viewableImpression.viewUndetermined
            }
        }
        
        if let creative = currentTrackingCreative, let viewableImpression = creative.vastAd.viewableImpression {
            let urls = viewableImpressionUrls(type: type, viewableImpression: viewableImpression)
            creative.callTrackingUrls(urls)
        } else {
            throw TrackingError.internalError(msg: "Unable to find viewableImpression to track")
        }
    }
}
