//
//  VastTracker.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public protocol VastTrackerDelegate: class {
    func adBreakStart(_ vastModel: VastModel)
    func adStart(_ ad: VastAd)
    func adFirstQuatile(_ ad: VastAd)
    func adMidpoint(_ ad: VastAd)
    func adThirdQuartile(_ ad: VastAd)
    func adComplete(_ ad: VastAd)
    func adBreakComplete(_ vastModel: VastModel)
}

public class VastTracker {

    public var delegate: VastTrackerDelegate?

    private var trackingStatus: TrackingStatus = .unknown
    private let vastModel: VastModel
    private let startTime: Double
    private var currentTime = 0.0
    private var playhead: Double {
        get {
            return max(0.0, currentTime - startTime - completedAdAccumulatedDuration)
        }
    }
    private var vastAds: [VastAd]
    private var completedAdAccumulatedDuration = 0.0
    private var currentTrackingCreative: TrackingCreative?

    public init(vastModel: VastModel, startTime: Double) {
        self.startTime = startTime
        self.vastModel = vastModel
        self.vastAds = vastModel.ads
        self.trackingStatus = .tracking

        delegate?.adBreakStart(vastModel)
    }

    public func updateProgress(time: Double) throws {
        var message = "Cannot update tracking progress."
        guard trackingStatus == .tracking, trackingStatus == .paused else {
            switch trackingStatus {
            case .errored:
                message += "Status is errored"
            case .complete:
                message += "Status is complete"
            default:
                message += "Status is unknown"
            }
            throw TrackingError.UnableToUpdateProgress(msg: message)
        }
        currentTime = time

        if trackingStatus == .paused {
            // TODO: vast resume
            trackingStatus = .tracking
        }

        if currentTrackingCreative == nil {
            guard let vastAd = vastAds.first,
                let creative = vastAd.linearCreatives.first else {
                    trackingStatus = .complete
                    delegate?.adBreakComplete(vastModel)
                    return
            }

            currentTrackingCreative = TrackingCreative(creative: creative, vastAd: vastAd)
        }

        guard var creative = currentTrackingCreative else {
            trackingStatus = .errored
            throw TrackingError.InternalError(msg: "Unable to find current creative to track")
        }

        if playhead < creative.duration {
            if !creative.trackedStarted {
                creative.trackedStarted = true

                let impressions = creative.vastAd.impressions.filter { $0.url != nil }.map { $0.url! }
                creative.callTrackingUrls(impressions)
                delegate?.adStart(creative.vastAd)
            }

            // TODO: make the http calls for the quartile events
            if playhead > creative.firstQuartile && playhead < creative.midpoint {
                if !creative.trackedFirstQuartile {
                    creative.trackedFirstQuartile = true
                    let trackingUrls = creative.creative.trackingEvents
                            .filter { $0.type == .firstQuartile && $0.url != nil }
                        .map { $0.url! }
                    creative.callTrackingUrls(trackingUrls)
                    delegate?.adFirstQuatile(creative.vastAd)
                }
            } else if playhead > creative.midpoint && playhead < creative.thirdQuartile {
                if !creative.trackedMidpoint {
                    creative.trackedMidpoint = true
                    let trackingUrls = creative.creative.trackingEvents
                        .filter { $0.type == .midpoint && $0.url != nil }
                        .map { $0.url! }
                    creative.callTrackingUrls(trackingUrls)
                    delegate?.adMidpoint(creative.vastAd)
                }
            } else if playhead > creative.thirdQuartile && playhead < creative.duration {
                if !creative.trackedThirdQuartile {
                    creative.trackedThirdQuartile = true
                    let trackingUrls = creative.creative.trackingEvents
                        .filter { $0.type == .thirdQuartile && $0.url != nil }
                        .map { $0.url! }
                    creative.callTrackingUrls(trackingUrls)
                    delegate?.adThirdQuartile(creative.vastAd)
                }
            }
        } else {
            if !creative.trackedComplete {
                creative.trackedComplete = true
                let trackingUrls = creative.creative.trackingEvents
                    .filter { $0.type == .complete && $0.url != nil }
                    .map { $0.url! }
                creative.callTrackingUrls(trackingUrls)
                delegate?.adComplete(creative.vastAd)
                completedAdAccumulatedDuration += creative.duration
            }

            vastAds.removeFirst()
            currentTrackingCreative = nil
            if vastAds.count > 0 {
                try? updateProgress(time: time)
            } else {
                trackingStatus = .complete
                delegate?.adBreakComplete(vastModel)
            }
        }
    }

    public func paused() {

    }

    public func setVolume(_ volume: Double) {

    }

    public func clicked() throws -> [URL] {
        guard let trackingCreative = currentTrackingCreative else {
            // TODO: determine if this is an error or complete
            throw TrackingError.UnableToProvideCreativeClickThroughUrls
        }
        return trackingCreative.creative.videoClicks.filter { $0.url != nil }.map { $0.url! }
    }

    public func error() {

    }

}
