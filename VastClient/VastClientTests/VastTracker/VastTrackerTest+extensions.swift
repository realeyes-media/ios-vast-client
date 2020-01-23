//
//  VastTrackerTexts.swift
//  VastClientTests
//
//  Created by Jan Bednar on 01/02/2019.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.
//

import Foundation
@testable import VastClient

extension Double {
    static func makeArray(from: Int = 0, to: Int) -> [Double] {
        guard from <= to else {
            return []
        }
        var numbers: [Int] = []
        for i in from...to {
            numbers.append(i)
        }
        return numbers.map { Double($0) }
    }
}

extension VastAd {
    static func make(skipOffset: String?, duration: Double, sequence: Int) -> VastAd {
        let files = VastMediaFiles(mediaFiles: [VastMediaFile(delivery: "", type: "", width: "", height: "", codec: "", id: nil, bitrate: nil, minBitrate: nil, maxBitrate: nil, scalable: nil, maintainAspectRatio: nil, apiFramework: nil, url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"))], interactiveCreativeFiles: [])
        
        let linearCreative = VastLinearCreative(skipOffset: skipOffset, duration: duration, adParameters: nil, videoClicks: [], trackingEvents: [], files: files, icons: [])
        let creative = VastCreative(id: nil, adId: nil, sequence: nil, apiFramework: nil, universalAdId: nil, creativeExtensions: [], linear: linearCreative, nonLinearAds: nil, companionAds: nil)
        
        return VastAd(type: .inline, id: "", sequence: sequence, conditionalAd: nil, adSystem: nil, impressions: [], adVerifications: [], viewableImpression: nil, pricing: nil, errors: [], creatives: [creative], extensions: [], adTitle: nil, adCategories: [], description: nil, advertiser: nil, surveys: [], wrapper: nil)
    }
}
