//
//  EventTracking-test.swift
//  Vaster_Example
//
//  Created by Jan Bednar on 14/11/2018.
//  Copyright © 2018 STER. All rights reserved.
//

import Foundation
@testable import VastClient

extension VastModel {
    static let eventTracking3: VastModel = {
        
        let adSystem = VastAdSystem(version: "4.0", system: "iabtechlab")
        let impressions = VastImpression(id: "Impression-ID", url: URL(string: "http://example.com/track/impression")!)
        let pricing = VastPricing(model: .cpm, currency: "USD", pricing: 25.0)
        let errors = [URL(string: "http://example.com/error")!]
        
        let videoClicks: [VastVideoClick] = [
            VastVideoClick(id: "blog", type: .clickThrough, url: URL(string: "https://iabtechlab.com"))
        ]
        let trackingEvents: [VastTrackingEvent] = [
            VastTrackingEvent(type: .start, offset: 36320, url: URL(string: "http://example.com/tracking/start"), tracked: false),
            VastTrackingEvent(type: .firstQuartile, offset: nil, url: URL(string: "http://example.com/tracking/firstQuartile"), tracked: false),
            VastTrackingEvent(type: .midpoint, offset: nil, url: URL(string: "http://example.com/tracking/midpoint"), tracked: false),
            VastTrackingEvent(type: .thirdQuartile, offset: nil, url: URL(string: "http://example.com/tracking/thirdQuartile"), tracked: false),
            VastTrackingEvent(type: .complete, offset: nil, url: URL(string: "http://example.com/tracking/complete"), tracked: false)
        ]
        
        let mediaFiles: [VastMediaFile] = [
            VastMediaFile(delivery: "progressive", type: "video/mp4", width: "400", height: "300", codec: "0", id: "5241", bitrate: 500, minBitrate: 360, maxBitrate: 1080, scalable: true, maintainAspectRatio: true, apiFramework: "VAST", url: URL(string: "https://iabtechlab.com/wp-content/uploads/2016/07/VAST-4.0-Short-Intro.mp4"))
        ]
        
        let interactiveMediaFiles: [VastInteractiveCreativeFile] = []
        
        let icons: [VastIcon] = []
        
        let linear = VastLinearCreative(skipOffset: nil, duration: 16, adParameters: nil, videoClicks: videoClicks, trackingEvents: trackingEvents, files: VastMediaFiles(mediaFiles: mediaFiles, interactiveCreativeFiles: interactiveMediaFiles), icons: icons)
        let creative = VastCreative(id: "5480", adId: nil, sequence: 1, apiFramework: nil, universalAdId: nil, creativeExtensions: [], linear: linear, nonLinearAds: nil, companionAds: nil)
        
        let extensions: [VastExtension] = [
            VastExtension(type: "iab-Count", creativeParameters: []),
            // TODO: this is not part of the current model
        ]
        
        let ad = VastAd(type: .inline, id: "20001", sequence: nil, conditionalAd: nil, adSystem: adSystem, impressions: [impressions], adVerifications: [], viewableImpression: nil, pricing: pricing, errors: errors, creatives: [creative], extensions: extensions, adTitle: "iabtechlab video ad", adCategories: [], description: nil, advertiser: nil, surveys: [], wrapper: nil)
        
        return VastModel(version: "3.0", ads: [ad], errors: [])
    }()
}
