//
//  ViewableImpression.swift
//  Vaster_Example
//
//  Created by Jan Bednar on 14/11/2018.
//  Copyright © 2018 STER. All rights reserved.
//

import Foundation
@testable import VastClient

extension VastModel {
    static let viewableImpression: VastModel = {
        let adSystem = VastAdSystem(version: "4.0", system: "iabtechlab")
        let impressions = VastImpression(id: "Impression-ID", url: URL(string: "http://example.com/track/impression")!)
        let pricing: VastPricing? = nil
        let errors = [URL(string: "http://example.com/error")!]
        let categories: [VastAdCategory] = []
        let videoClicks: [VastVideoClick] = [
            VastVideoClick(id: nil, type: .clickThrough, url: URL(string: "https://iabtechlab.com"))
        ]
        
        let trackingEvents: [VastTrackingEvent] = [
            VastTrackingEvent(type: .start, offset: 32410, url: URL(string: "http://example.com/tracking/start"), tracked: false)
        ]
        let linear: VastLinearCreative? = VastLinearCreative(skipOffset: nil, duration: nil, adParameters: nil, videoClicks: [], trackingEvents: trackingEvents, files: VastMediaFiles(), icons: [])
        let universalAdId: VastUniversalAdId? = nil
        
        let creative = VastCreative(id: "5480", adId: "2447226", sequence: 1, apiFramework: nil, universalAdId: universalAdId, creativeExtensions: [], linear: linear, nonLinearAds: nil, companionAds: nil)
        
        let extensions: [VastExtension] = []
        
        let adTagUri = URL(string: "https://raw.githubusercontent.com/InteractiveAdvertisingBureau/VAST_Samples/master/VAST%204.0%20Samples/Inline_Companion_Tag-test.xml")
        
        let viewableImpression = VastViewableImpression(id: "1543", url: nil, viewable: [URL(string: "http://search.iabtechlab.com/error?errcode=102&imprid=s5-ea2f7f298e28c0c98374491aec3dfeb1&ts=1243")!], notViewable: [URL(string: "http://search.iabtechlab.com/error?errcode=102&imprid=s5-ea2f7f298e28c0c98374491aec3dfeb1&ts=1243")!], viewUndetermined: [URL(string: "http://search.iabtechlab.com/error?errcode=102&imprid=s5-ea2f7f298e28c0c98374491aec3dfeb1&ts=1243")!])
        
        let wrapper = VastWrapper(followAdditionalWrappers: false, allowMultipleAds: true, fallbackOnNoAd: false, adTagUri: adTagUri)
        
        let ad = VastAd(type: .wrapper, id: "20010", sequence: 1, conditionalAd: false, adSystem: adSystem, impressions: [impressions], adVerifications: [], viewableImpression: viewableImpression, pricing: pricing, errors: errors, creatives: [creative], extensions: extensions, adTitle: nil, adCategories: categories, description: nil, advertiser: nil, surveys: [], wrapper: wrapper)
        
        return VastModel(version: "4.0", ads: [ad], errors: [])
    }()
}
