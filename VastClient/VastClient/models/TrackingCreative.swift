//
//  TrackingCreative.swift
//  VastClient
//
//  Created by John Gainfort Jr on 5/14/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct TrackingCreative {
    let creative: VastLinearCreative
    let vastAd: VastAd
    let firstQuartile: Double
    let midpoint: Double
    let thirdQuartile: Double
    let duration: Double
    var trackedStart = false
    var trackedFirstQuartile = false
    var trackedMidpoint = false
    var trackedThirdQuartile = false
    var trackedComplete = false
}

extension TrackingCreative {
    init(creative: VastLinearCreative, vastAd: VastAd) {
        self.creative = creative
        self.vastAd = vastAd
        self.duration = creative.duration
        self.firstQuartile = duration * 0.25
        self.midpoint = duration * 0.5
        self.thirdQuartile = duration * 0.75
    }

    func callTrackingUrls(_ urls: [URL]) {
        print("Calling \(urls.count) urls")
        urls.forEach { url in
            makeRequest(withUrl: url)
        }
    }
}
