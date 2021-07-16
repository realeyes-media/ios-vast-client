//
//  ReadyToServerMediaFilesCheck-test.swift
//  Vaster_Example
//
//  Created by Jan Bednar on 14/11/2018.
//  Copyright © 2018 STER. All rights reserved.
//

import Foundation
@testable import VastClient

extension VastModel {
    static let readyToServerMediaFilesCheck: VastModel = {
        let adSystem = VastAdSystem(version: "4.0", system: "iabtechlab")
        let impressions = VastImpression(id: "Impression-ID", url: URL(string: "http://example.com/track/impression")!)
        let pricing = VastPricing(model: .cpm, currency: "USD", pricing: 25.0)
        let errors = [URL(string: "http://example.com/error")!]
        
        let categories: [VastAdCategory] = []
        
        let videoClicks: [VastVideoClick] = [
            VastVideoClick(id: "blog", type: .clickThrough, url: URL(string: "https://iabtechlab.com"))
        ]
        let trackingEvents: [VastTrackingEvent] = [
            VastTrackingEvent(type: .start, offset: 5303, url: URL(string: "http://example.com/tracking/start"), tracked: false),
            VastTrackingEvent(type: .firstQuartile, offset: nil, url: URL(string: "http://example.com/tracking/firstQuartile"), tracked: false),
            VastTrackingEvent(type: .midpoint, offset: nil, url: URL(string: "http://example.com/tracking/midpoint"), tracked: false),
            VastTrackingEvent(type: .thirdQuartile, offset: nil, url: URL(string: "http://example.com/tracking/thirdQuartile"), tracked: false),
            VastTrackingEvent(type: .complete, offset: nil, url: URL(string: "http://example.com/tracking/complete"), tracked: false)
        ]
        
        let mediaFiles: [VastMediaFile] = [
            VastMediaFile(delivery: "progressive", type: "video/mp4", width: "1280", height: "720", codec: "0", id: "5241", bitrate: 2000, minBitrate: 1500, maxBitrate: 2500, scalable: true, maintainAspectRatio: true, apiFramework: nil, url: URL(string: "https://iabtechlab.com/wp-content/uploads/2016/07/VAST-4.0-Short-Intro.mp4")),
            VastMediaFile(delivery: "progressive", type: "video/mp4", width: "854", height: "480", codec: "0", id: "5244", bitrate: 1000, minBitrate: 700, maxBitrate: 1500, scalable: true, maintainAspectRatio: true, apiFramework: nil, url: URL(string: "https://iabtechlab.com/wp-content/uploads/2017/12/VAST-4.0-Short-Intro-mid-resolution.mp4")),
            VastMediaFile(delivery: "progressive", type: "video/mp4", width: "640", height: "360", codec: "0", id: "5246", bitrate: 600, minBitrate: 500, maxBitrate: 700, scalable: true, maintainAspectRatio: true, apiFramework: nil, url: URL(string: "https://iabtechlab.com/wp-content/uploads/2017/12/VAST-4.0-Short-Intro-low-resolution.mp4"))
        ]
        
        let interactiveMediaFiles: [VastInteractiveCreativeFile] = []
        
        let icons: [VastIcon] = []
        
        let linear = VastLinearCreative(skipOffset: nil, duration: 16, adParameters: nil, videoClicks: videoClicks, trackingEvents: trackingEvents, files: VastMediaFiles(mediaFiles: mediaFiles, interactiveCreativeFiles: interactiveMediaFiles), icons: icons)
        let universalAdId = VastUniversalAdId(idRegistry: "Ad-ID", idValue: "8465", uniqueCreativeId: "8465")
        
        let creative = VastCreative(id: "5480", adId: "2447226", sequence: 1, apiFramework: nil, universalAdId: universalAdId, creativeExtensions: [], linear: linear, nonLinearAds: nil, companionAds: nil)
        
        let extensions: [VastExtension] = [
            VastExtension(type: "iab-Count", creativeParameters: [])
        ]
        
        let ad = VastAd(type: .inline, id: "20007", sequence: 1, conditionalAd: false, adSystem: adSystem, impressions: [impressions], adVerifications: [], viewableImpression: nil, pricing: pricing, errors: errors, creatives: [creative], extensions: extensions, adTitle: "iabtechlab video ad", adCategories: categories, description: nil, advertiser: nil, surveys: [], wrapper: nil)
        
        return VastModel(version: "4.0", ads: [ad], errors: [])
    }()
}
