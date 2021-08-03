//
//  PubadsInlineModel.swift
//  VastClientTests
//
//  Created by Jan Bednar on 20/11/2018.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation
@testable import VastClient

extension VastModel {
    static let pubadsInlineModel: VastModel = {
        let adSystem = VastAdSystem(version: nil, system: "STARlight.NET")
        let impressions: [VastImpression] = [VastImpression(id: nil, url: nil)]
        let pricing: VastPricing? = nil
        let errors: [URL] = []
        
        let categories: [VastAdCategory] = []
        
        let videoClicks: [VastVideoClick] = [
            VastVideoClick(id: "GDFP", type: .clickThrough, url: URL(string: "https://bit.ly/CherryPickersLiebe"))
        ]
        let trackingEvents: [VastTrackingEvent] = []
        
        let mediaFiles: [VastMediaFile] = [
            VastMediaFile(delivery: "progressive", type: "video/mp4", width: "720", height: "404", codec: nil, id: "GDFP", bitrate: 817, minBitrate: nil, maxBitrate: nil, scalable: true, maintainAspectRatio: true, apiFramework: nil, url: URL(string: "https://cdn.ster.nl/banners/29619uq.mp4"))
        ]
        
        let interactiveMediaFiles: [VastInteractiveCreativeFile] = []
        
        let icons: [VastIcon] = []
        
        let linear = VastLinearCreative(skipOffset: nil, duration: 20, adParameters: nil, videoClicks: videoClicks, trackingEvents: trackingEvents, files: VastMediaFiles(mediaFiles: mediaFiles, interactiveCreativeFiles: interactiveMediaFiles), icons: icons)
        let universalAdId: VastUniversalAdId? = nil
        
        let creative = VastCreative(id: nil, adId: "29619UQ", sequence: nil, apiFramework: nil, universalAdId: universalAdId, creativeExtensions: [], linear: linear, nonLinearAds: nil, companionAds: nil)
        
        let extensions: [VastExtension] = []
        
        let ad = VastAd(type: .inline, id: "29619", sequence: nil, conditionalAd: nil, adSystem: adSystem, impressions: impressions, adVerifications: [], viewableImpression: nil, pricing: pricing, errors: errors, creatives: [creative], extensions: extensions, adTitle: "Ster en Cultuur (weekpak. volwas)ONLINE", adCategories: categories, description: "Ster en Cultuur (weekpak. volwas)ONLINE", advertiser: nil, surveys: [], wrapper: nil)
        
        return VastModel(version: "2.0", ads: [ad], errors: [])
    }()
}
