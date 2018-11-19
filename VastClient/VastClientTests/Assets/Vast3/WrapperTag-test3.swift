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
        let creative = VastCreative(id: "5480", adId: nil, sequence: 1, apiFramework: nil, universalAdId: nil, creativeExtensions: [], linear: nil)
        let extensions: [VastExtension] = []
        let adTagUri = URL(string: "https://raw.githubusercontent.com/InteractiveAdvertisingBureau/VAST_Samples/master/VAST%203.0%20Samples/Inline_Companion_Tag-test.xml")!
        // TODO: add companionAds from the file
        
        let wrapper = VastWrapper(followAdditionalWrappers: nil, allowMultipleAds: nil, fallbackOnNoAd: nil, adTagUri: adTagUri)
        
        let ad = VastAd(type: .wrapper, id: "20011", sequence: 0, conditionalAd: nil, adSystem: adSystem, impressions: impressions, adVerifications: [], viewableImpression: nil, pricing: nil, errors: errors, creatives: [creative], extensions: extensions, adTitle: nil, adCategories: [], description: nil, advertiser: nil, surveys: [], wrapper: wrapper)
        
        return VastModel(version: "3.0", ads: [ad], errors: [])
    }()
}
