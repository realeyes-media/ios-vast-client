//
//  VastTracker.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public protocol VastTrackerDelegate {
    func adBreakStart(_ id: String, _ vastModel: VastModel)
    func adStart(_ id: String, _ ad: VastAd)
    func adFirstQuartile(_ id: String, _ ad: VastAd)
    func adMidpoint(_ id: String, _ ad: VastAd)
    func adThirdQuartile(_ id: String, _ ad: VastAd)
    func adComplete(_ id: String, _ ad: VastAd)
    func adBreakComplete(_ id: String, _ vastModel: VastModel)
}

public class VastTracker {

    public var delegate: VastTrackerDelegate?

    private let id: String
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
            .filter { supportAdBuffets ? true : $0.sequence > 0 }
            .sorted(by: { $0.sequence < $1.sequence })
        self.trackingStatus = .tracking
        self.delegate = delegate

        delegate?.adBreakStart(id, vastModel)
    }

    public func updateProgress(time: Double) throws {
        var message = "Cannot update tracking progress."
        guard trackingStatus == .tracking || trackingStatus == .paused else {
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
                let creative = vastAd.linearCreatives.first, vastAd.sequence > 0 else {
                    trackingStatus = .complete
                    delegate?.adBreakComplete(id, vastModel)
                    return
            }

            currentTrackingCreative = TrackingCreative(creative: creative, vastAd: vastAd)
        }

        guard var creative = currentTrackingCreative else {
            trackingStatus = .errored
            throw TrackingError.InternalError(msg: "Unable to find current creative to track")
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

        if playhead < creative.duration {
            if !creative.trackedStart {
                creative.trackedStart = true

                let impressions = creative.vastAd.impressions.filter { $0.url != nil }.map { $0.url! }
                let trackingUrls = creative.creative.trackingEvents
                    .filter { ($0.type == .creativeView || $0.type == .start) && $0.url != nil }
                    .map { $0.url! }
                creative.callTrackingUrls(impressions + trackingUrls)
                delegate?.adStart(id, creative.vastAd)
            }

            if playhead > creative.firstQuartile && playhead < creative.midpoint {
                if !creative.trackedFirstQuartile {
                    creative.trackedFirstQuartile = true
                    let trackingUrls = creative.creative.trackingEvents
                        .filter { $0.type == .firstQuartile && $0.url != nil }
                        .map { $0.url! }
                    creative.callTrackingUrls(trackingUrls)
                    delegate?.adFirstQuartile(id, creative.vastAd)
                }
            } else if playhead > creative.midpoint && playhead < creative.thirdQuartile {
                if !creative.trackedMidpoint {
                    creative.trackedMidpoint = true
                    let trackingUrls = creative.creative.trackingEvents
                        .filter { $0.type == .midpoint && $0.url != nil }
                        .map { $0.url! }
                    creative.callTrackingUrls(trackingUrls)
                    delegate?.adMidpoint(id, creative.vastAd)
                }
            } else if playhead > creative.thirdQuartile && playhead < creative.duration {
                if !creative.trackedThirdQuartile {
                    creative.trackedThirdQuartile = true
                    let trackingUrls = creative.creative.trackingEvents
                        .filter { $0.type == .thirdQuartile && $0.url != nil }
                        .map { $0.url! }
                    creative.callTrackingUrls(trackingUrls)
                    delegate?.adThirdQuartile(id, creative.vastAd)
                }
            }

            currentTrackingCreative = creative
        } else {
            if !creative.trackedComplete && creative.trackedStart {
                creative.trackedComplete = true
                let trackingUrls = creative.creative.trackingEvents
                    .filter { $0.type == .complete && $0.url != nil }
                    .map { $0.url! }
                creative.callTrackingUrls(trackingUrls)
                delegate?.adComplete(id, creative.vastAd)
                completedAdAccumulatedDuration += creative.duration
            }

            vastAds.removeFirst()
            currentTrackingCreative = nil
            if vastAds.count > 0 {
                try? updateProgress(time: time)
            } else {
                trackingStatus = .complete
                delegate?.adBreakComplete(id, vastModel)
            }
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
            throw TrackingError.InternalError(msg: "Unable to find current creative to track")
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
            throw TrackingError.InternalError(msg: "Unable to find current creative to track")
        }
    }

    public func rewind() throws {
        if let creative = currentTrackingCreative {
            let trackingUrls = creative.creative.trackingEvents
                .filter { $0.type == .rewind && $0.url != nil }
                .map { $0.url! }
            creative.callTrackingUrls(trackingUrls)
        } else {
            throw TrackingError.InternalError(msg: "Unable to find current creative to track")
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
            throw TrackingError.InternalError(msg: "Unable to find current creative to track")
        }
    }

    public func skip() throws {
        if let creative = currentTrackingCreative {
            let trackingUrls = creative.creative.trackingEvents
                .filter { $0.type == .skip && $0.url != nil }
                .map { $0.url! }
            creative.callTrackingUrls(trackingUrls)
        } else {
            throw TrackingError.InternalError(msg: "Unable to find current creative to track")
        }
    }

    public func acceptedLinearInvitation() throws {
        if let creative = currentTrackingCreative {
            let trackingUrls = creative.creative.trackingEvents
                .filter { $0.type == .acceptInvitationLinear && $0.url != nil }
                .map { $0.url! }
            creative.callTrackingUrls(trackingUrls)
        } else {
            throw TrackingError.InternalError(msg: "Unable to find current creative to track")
        }
    }

    public func closed() throws {
        if let creative = currentTrackingCreative {
            let trackingUrls = creative.creative.trackingEvents
                .filter { $0.type == .closeLinear && $0.url != nil }
                .map { $0.url! }
            creative.callTrackingUrls(trackingUrls)
        } else {
            throw TrackingError.InternalError(msg: "Unable to find current creative to track")
        }
    }

    public func clicked(withCustomAction custom: Bool = false) throws -> [URL] {
        if let trackingCreative = currentTrackingCreative {
            let clickUrls = trackingCreative.creative.videoClicks
                .filter { $0.type == .clickTracking && $0.url != nil }
                .map { $0.url! }
            trackingCreative.callTrackingUrls(clickUrls)
            
            return trackingCreative.creative.videoClicks
                .filter { click in
                    let typeMatch = custom ? click.type == .customClick : click.type == .clickThrough
                    return typeMatch && click.url != nil
                }
                .map { $0.url! }
        } else {
            // TODO: determine if this is an error or complete
            throw TrackingError.UnableToProvideCreativeClickThroughUrls
        }
    }

    public func error(withReason code: VastErrorCodes?) throws {
        if let creative = currentTrackingCreative {
            if var err = creative.vastAd.error {
                if let c = code {
                    err = err.withErrorCode(c)
                }
                creative.callTrackingUrls([err])
            }
        } else {
            throw TrackingError.InternalError(msg: "Unable to find current creative to track")
        }
    }

}
