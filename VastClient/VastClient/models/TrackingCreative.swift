//
//  TrackingCreative.swift
//  VastClient
//
//  Created by John Gainfort Jr on 5/14/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct TrackingCreative {
    var creative: VastLinearCreative
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
    init?(creative: VastLinearCreative, vastAd: VastAd) {
        guard let duration = creative.duration else {
            return nil
        }
        
        self.creative = creative
        self.vastAd = vastAd
        self.duration = duration
        self.firstQuartile = ceil(duration * 0.25)
        self.midpoint = ceil(duration * 0.5)
        self.thirdQuartile = ceil(duration * 0.75)
    }

    func callTrackingUrls(_ urls: [URL]) {
        urls.forEach { url in
            makeRequest(withUrl: url)
        }
    }
}
