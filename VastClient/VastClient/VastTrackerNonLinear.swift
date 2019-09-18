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
    func adStart(vastTracker: VastTrackerNonLinear, ad: VastAd)
    func adFirstQuartile(vastTracker: VastTrackerNonLinear, ad: VastAd)
    func adMidpoint(vastTracker: VastTrackerNonLinear, ad: VastAd)
    func adThirdQuartile(vastTracker: VastTrackerNonLinear, ad: VastAd)
    func adComplete(vastTracker: VastTrackerNonLinear, ad: VastAd)
    func adBreakComplete(vastTracker: VastTrackerNonLinear)
}

//enum TrackerModelType {
//    case standAlone
//    case adPod
//    case adBuffet
//}
//
//public struct TrackerModel {
//    let type: TrackerModelType
//    let vastModel: VastModel
//}

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
        
//        let progressUrls = creative.creative.trackingEvents
//            .filter { $0.type == .progress && !$0.tracked && $0.url != nil }
//            .filter { event -> Bool in
//                if var offset = event.offset {
//                    if offset > 0 && offset < 1 {
//                        offset = creative.duration * offset
//                    }
//                    if time >= offset {
//                        return true
//                    }
//                } else {
//                    return true
//                }
//                return false
//            }
//            .compactMap { $0.url }
//
//        if progressUrls.count > 0 {
//            progressUrls.forEach { url in
//                guard let idx = creative.creative.trackingEvents.firstIndex(where: { $0.url == url }) else { return }
//                creative.creative.trackingEvents[idx].tracked = true
//            }
//            track(urls: progressUrls, eventName: "PROGRESS")
//        }
        
//        guard comparisonTime < creative.duration else {
//            return
//        }
        
//        guard currentTime >= startTime else {
//            return
//        }
        
        if !adBreakStarted {
            adBreakStarted = true
            delegate?.adBreakStart(vastTracker: self)
        }
//
//        if !creative.trackedStart {
//            creative.trackedStart = true
//
//            let impressions = creative.vastAd.impressions.compactMap { $0.url }
//            track(urls: impressions, eventName: "IMPRESSIONS")
//            trackEvent(.creativeView, creative: creative)
//            trackEvent(.start, creative: creative)
//            delegate?.adStart(vastTracker: self, ad: creative.vastAd)
//        }
//
//        if comparisonTime >= creative.firstQuartile, comparisonTime <= creative.midpoint, !creative.trackedFirstQuartile {
//            creative.trackedFirstQuartile = true
//            trackEvent(.firstQuartile, creative: creative)
//            delegate?.adFirstQuartile(vastTracker: self, ad: creative.vastAd)
//        }
//        if comparisonTime >= creative.midpoint, comparisonTime <= creative.thirdQuartile, !creative.trackedMidpoint {
//            creative.trackedMidpoint = true
//            trackEvent(.midpoint, creative: creative)
//            delegate?.adMidpoint(vastTracker: self, ad: creative.vastAd)
//        }
//        if comparisonTime >= creative.thirdQuartile, comparisonTime <= creative.duration, !creative.trackedThirdQuartile {
//            creative.trackedThirdQuartile = true
//            trackEvent(.thirdQuartile, creative: creative)
//            delegate?.adThirdQuartile(vastTracker: self, ad: creative.vastAd)
//        }
        
        currentNonlinearTrackingCreative = creative
    }
    
    public func finishedPlayback() throws {
        guard var creative = currentNonlinearTrackingCreative else {
            trackingStatus = .errored
            throw TrackingError.internalError(msg: "Unable to find current creative to track")
        }
        
        try trackEvent(.complete)
        delegate?.adComplete(vastTracker: self, ad: creative.vastAd)
    }
    
    public func paused(_ val: Bool) throws {
        try trackEvent(val ? .pause : .resume)
    }
    
    public func fullscreen(_ val: Bool) throws {
        let fullScreenTrackingEvent: TrackingEventType = val ? .fullscreen : .exitFullscreen
        let playerExpandTrackingEvent: TrackingEventType = val ? .playerExpand : .playerCollapse
        try trackEvent(fullScreenTrackingEvent, playerExpandTrackingEvent)
    }
    
    public func rewind() throws {
        try trackEvent(.rewind)
    }
    
    public func muted(_ val: Bool) throws {
        try trackEvent(val ? .mute : .unmute)
    }
    
    private func tryToPlayNext() throws {
        vastAds.removeFirst()
        currentNonlinearTrackingCreative = nil
        if vastAds.count > 0 {
            if trackProgressCumulatively {
                try updateProgress(time: currentTime)
            } else {
                try updateProgress(time: 0.0)
            }
        } else {
            trackingStatus = .complete
            delegate?.adBreakComplete(vastTracker: self)
        }
    }
    
//    public func skip() throws {
//        if let creative = currentNonlinearTrackingCreative {
//            guard let skipOffset = creative.vastAd.creatives.first?.linear?.skipOffset?.toSeconds, skipOffset < comparisonTime else {
//                throw TrackingError.unableToSkipAdAtThisTime
//            }
//            try trackEvent(.skip)
//            completedAdAccumulatedDuration += creative.duration
//            try tryToPlayNext()
//        } else {
//            throw TrackingError.internalError(msg: "Unable to find current creative to track")
//        }
//    }
    
    public func acceptedLinearInvitation() throws {
        try trackEvent(.acceptInvitationLinear)
    }
    
    public func closed() throws {
        try trackEvent(.closeLinear)
    }
    
//    public func clicked() throws -> URL? {
//        if let nonLinearTrackingCreative = currentNonlinearTrackingCreative {
//            trackClicks(for: nonLinearTrackingCreative)
//
//            return nonLinearTrackingCreative.creative.videoClicks.first(where: { $0.type == .clickThrough })?.url
//        } else {
//            // TODO: determine if this is an error or complete
//            throw TrackingError.unableToProvideCreativeClickThroughUrls
//        }
//    }
    
//    public func clickedWithCustomAction() throws -> [URL] {
//        if let nonLinearTrackingCreative = currentNonlinearTrackingCreative {
//            trackClicks(for: nonLinearTrackingCreative)
//
//            return NonlinearTrackingCreative.creative.videoClicks
//                .filter { $0.type == .customClick }
//                .compactMap { $0.url }
//        } else {
//            // TODO: determine if this is an error or complete
//            throw TrackingError.unableToProvideCreativeClickThroughUrls
//        }
//    }
    
//    private func trackClicks(for creative: NonlinearTrackingCreative) {
//        let clickUrls = creative.creative.videoClicks
//            .filter { $0.type == .clickTracking }
//            .compactMap { $0.url }
//        track(urls: clickUrls, eventName: "CLICK TRACKING")
//    }
    
    public func error(withReason code: VastErrorCodes?) throws {
        if let creative = currentNonlinearTrackingCreative {
            let urls = creative.vastAd.errors.map { error -> URL in
                if let c = code {
                    return error.withErrorCode(c)
                }
                return error
            }
            track(urls: urls, eventName: "ERROR")
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
        
        if let creative = currentNonlinearTrackingCreative, let viewableImpression = creative.vastAd.viewableImpression {
            let urls = viewableImpressionUrls(type: type, viewableImpression: viewableImpression)
            track(urls: urls, eventName: "VIEWABLE IMPRESSION \(type.rawValue.uppercased())")
        } else {
            throw TrackingError.internalError(msg: "Unable to find viewableImpression to track")
        }
    }
    
    private func trackEvent(_ types: TrackingEventType..., creative: NonlinearTrackingCreative) {
        callTrackingUrlsFor(types: types, creative: creative)
    }
    
    private func trackEvent(_ types: TrackingEventType...) throws {
        if let creative = currentNonlinearTrackingCreative {
            callTrackingUrlsFor(types: types, creative: creative)
        } else {
            throw TrackingError.internalError(msg: "Unable to find current creative to track")
        }
    }
    
    private func callTrackingUrlsFor(types: [TrackingEventType], creative: NonlinearTrackingCreative) {
        types.forEach { trackingEventType in
            let trackingUrls = creative.creative.trackingEvents
                .filter { $0.type == trackingEventType }
                .compactMap { $0.url }
            track(urls: trackingUrls, eventName: trackingEventType.rawValue.uppercased())
        }
    }
}
