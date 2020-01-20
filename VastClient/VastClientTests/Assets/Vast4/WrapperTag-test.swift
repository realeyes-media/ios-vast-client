//
//  WrapperTag-test.swift
//  Vaster_Example
//
//  Created by Jan Bednar on 14/11/2018.
//  Copyright © 2018 STER. All rights reserved.
//

import Foundation
@testable import VastClient

extension VastModel {
    static let wrapperTag: VastModel = {
        let adSystem = VastAdSystem(version: "4.0", system: "iabtechlab")
        let impressions = VastImpression(id: "Impression-ID", url: URL(string: "http://example.com/track/impression")!)
        let pricing: VastPricing? = nil
        let errors = [URL(string: "http://example.com/error")!]
        let categories: [VastAdCategory] = []
        let videoClicks: [VastVideoClick] = [
            VastVideoClick(id: nil, type: .clickThrough, url: URL(string: "https://iabtechlab.com"))
        ]
        let linear: VastLinearCreative? = nil
        let universalAdId: VastUniversalAdId? = nil
        
        let companion1 = VastCompanionCreative(width: 100, height: 150, id: "1232", assetWidth: 250, assetHeight: 200, expandedWidth: 350, expandedHeight: 250, apiFramework: "VPAID", adSlotId: "3214", pxRatio: 1400, staticResource: [VastStaticResource(creativeType: "image/png", url: URL(string: "https://www.iab.com/wp-content/uploads/2014/09/iab-tech-lab-6-644x290.png"))], iFrameResource: [], htmlResource: [], altText: nil, companionClickThrough: URL(string: "https://iabtechlab.com"), companionClickTracking: [], trackingEvents: [], adParameters: nil)
        let companionAds = VastCompanionAds(required: .none, companions: [companion1])
        let creative = VastCreative(id: "5480", adId: "2447226", sequence: 1, apiFramework: nil, universalAdId: universalAdId, creativeExtensions: [], linear: linear, nonLinearAds: nil,  companionAds: companionAds)
        
        let extensions: [VastExtension] = []
        
        let adTagUri = URL(string: "https://raw.githubusercontent.com/InteractiveAdvertisingBureau/VAST_Samples/master/VAST%204.0%20Samples/Inline_Companion_Tag-test.xml")
        
        let wrapper = VastWrapper(followAdditionalWrappers: false, allowMultipleAds: true, fallbackOnNoAd: false, adTagUri: adTagUri)
        
        let ad = VastAd(type: .wrapper, id: "20011", sequence: 1, conditionalAd: false, adSystem: adSystem, impressions: [impressions], adVerifications: [], viewableImpression: nil, pricing: pricing, errors: errors, creatives: [creative], extensions: extensions, adTitle: nil, adCategories: categories, description: nil, advertiser: nil, surveys: [], wrapper: wrapper)
        
        return VastModel(version: "4.0", ads: [ad], errors: [])
    }()
}
