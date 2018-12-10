//
//  VastTracker.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public protocol VastTrackerDelegate {
    func adBreakStart(vastTracker: VastTracker, vastModel: VastModel)
    func adStart(vastTracker: VastTracker, ad: VastAd)
    func adFirstQuartile(vastTracker: VastTracker, ad: VastAd)
    func adMidpoint(vastTracker: VastTracker, ad: VastAd)
    func adThirdQuartile(vastTracker: VastTracker, ad: VastAd)
    func adComplete(vastTracker: VastTracker, ad: VastAd)
    func adBreakComplete(vastTracker: VastTracker, vastModel: VastModel)
}

public class VastTracker {

    public var delegate: VastTrackerDelegate?

    let id: String
    private var trackingStatus: TrackingStatus = .unknown
    private let vastModel: VastModel
    private let startTime: Double
    private var currentTime = 0.0
    private var playhead: Double {
        get {
            return max(0.0, floor(currentTime - startTime - completedAdAccumulatedDuration))
        }
    }
    private var vastAds: [VastAd]
    private var completedAdAccumulatedDuration = 0.0
    private var currentTrackingCreative: TrackingCreative?

    public init(id: String, vastModel: VastModel, startTime: Double, supportAdBuffets: Bool = false, delegate: VastTrackerDelegate? = nil) {
        self.id = id
        self.startTime = startTime
        self.vastModel = vastModel
        self.vastAds = vastModel.ads
            .filter { supportAdBuffets ? true : $0.sequence != nil }
            .sorted(by: { $0.sequence ?? 0 < $1.sequence ?? 0 })
        self.trackingStatus = .tracking
        self.delegate = delegate

        delegate?.adBreakStart(vastTracker: self, vastModel: vastModel)
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
                    delegate?.adBreakComplete(vastTracker: self, vastModel: vastModel)
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
                .filter { $0.type == .complete && $0.url != nil }
                .map { $0.url! }
            creative.callTrackingUrls(trackingUrls)
            delegate?.adComplete(vastTracker: self, ad: creative.vastAd)
            completedAdAccumulatedDuration += creative.duration
        }
        
        vastAds.removeFirst()
        currentTrackingCreative = nil
        if vastAds.count > 0 {
            try? updateProgress(time: 0.0)
        } else {
            trackingStatus = .complete
            delegate?.adBreakComplete(vastTracker: self, vastModel: vastModel)
        }
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
                    let type = val ? event.type == .fullscreen || event.type == .expand : event.type == .resume || event.type == .collapse
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

    public func skip() throws {
        if let creative = currentTrackingCreative {
            let trackingUrls = creative.creative.trackingEvents
                .filter { $0.type == .skip && $0.url != nil }
                .map { $0.url! }
            creative.callTrackingUrls(trackingUrls)
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

}
