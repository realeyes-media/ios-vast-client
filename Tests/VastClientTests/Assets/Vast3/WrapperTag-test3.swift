//
//  WrapperTag-test.swift
//  Vaster_Tests
//
//  Created by Jan Bednar on 13/11/2018.
//  Copyright © 2018 STER. All rights reserved.
//

import Foundation
@testable import VastClient

extension VastModel {
    static let wrapperTag3: VastModel = {
        
        let adSystem = VastAdSystem(version: "4.0", system: "iabtechlab")
        let errors = [URL(string: "http://example.com/error")!]
        let impressions: [VastImpression] = [VastImpression(id: nil, url: URL(string: "http://example.com/track/impression"))]
        let videoClicks: [VastVideoClick] = []
        let trackingEvents: [VastTrackingEvent] = []
        let mediaFiles: [VastMediaFile] = []
        let interactiveMediaFiles: [VastInteractiveCreativeFile] = []
        let icons: [VastIcon] = []
        
        let companion1 = VastCompanionCreative(width: 100, height: 150, id: "1232", assetWidth: 250, assetHeight: 200, expandedWidth: 350, expandedHeight: 250, apiFramework: nil, adSlotId: nil, pxRatio: nil, staticResource: [VastStaticResource(creativeType: "image/png", url: URL(string: "https://www.iab.com/wp-content/uploads/2014/09/iab-tech-lab-6-644x290.png"))], iFrameResource: [], htmlResource: [], altText: nil, companionClickThrough: URL(string: "https://iabtechlab.com"), companionClickTracking: [], trackingEvents: [], adParameters: nil)
        let companionAds = VastCompanionAds(required: .none, companions: [companion1])
        let creative = VastCreative(id: "5480", adId: nil, sequence: 1, apiFramework: nil, universalAdId: nil, creativeExtensions: [], linear: nil, nonLinearAds: nil, companionAds: companionAds)
        let extensions: [VastExtension] = []
        let adTagUri = URL(string: "https://raw.githubusercontent.com/InteractiveAdvertisingBureau/VAST_Samples/master/VAST%203.0%20Samples/Inline_Companion_Tag-test.xml")!
        
        let wrapper = VastWrapper(followAdditionalWrappers: nil, allowMultipleAds: nil, fallbackOnNoAd: nil, adTagUri: adTagUri)
        
        let ad = VastAd(type: .wrapper, id: "20011", sequence: nil, conditionalAd: nil, adSystem: adSystem, impressions: impressions, adVerifications: [], viewableImpression: nil, pricing: nil, errors: errors, creatives: [creative], extensions: extensions, adTitle: nil, adCategories: [], description: nil, advertiser: nil, surveys: [], wrapper: wrapper)
        
        return VastModel(version: "3.0", ads: [ad], errors: [])
    }()
}
