
//
//  NonlinearTrackingCreative.swift
//  VastClient
//
//  Created by Austin Christensen on 9/18/19.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.
//

import Foundation

struct NonlinearTrackingCreative {
    var creative: VastNonLinearAdsCreative
    let vastAd: VastAd
    let firstQuartile: Double
    let midpoint: Double
    let thirdQuartile: Double
    var trackedStart = false
    var trackedFirstQuartile = false
    var trackedMidpoint = false
    var trackedThirdQuartile = false
    var trackedComplete = false
}

extension NonlinearTrackingCreative {
    init?(creative: VastNonLinearAdsCreative, vastAd: VastAd) {
        
        self.creative = creative
        self.vastAd = vastAd
        self.firstQuartile = 0.0
        self.midpoint = 0.0
        self.thirdQuartile = 0.0
    }
}
