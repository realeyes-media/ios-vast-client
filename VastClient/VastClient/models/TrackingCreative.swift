//
//  TrackingCreative.swift
//  VastClient
//
//  Created by John Gainfort Jr on 5/14/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

enum TrackingCreativeError: Error {
    case noDurationInVastLinearCreative
}

struct TrackingCreative {
    var creative: VastLinearCreative
    let vastAd: VastAd
    let firstQuartile: Double
    let midpoint: Double
    let thirdQuartile: Double
    let duration: Double
    var trackedFirstQuartile = false
    var trackedMidpoint = false
    var trackedThirdQuartile = false
}

extension TrackingCreative {
    init(creative: VastLinearCreative, vastAd: VastAd) throws {
        guard let duration = creative.duration else {
            throw TrackingCreativeError.noDurationInVastLinearCreative
        }
        
        self.creative = creative
        self.vastAd = vastAd
        self.duration = duration
        self.firstQuartile = ceil(duration * 0.25)
        self.midpoint = ceil(duration * 0.5)
        self.thirdQuartile = ceil(duration * 0.75)
    }
}
