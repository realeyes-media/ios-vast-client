//
//  VastNonLinearCreative.swift
//  VastClient
//
//  Created by Austin Christensen on 9/4/19.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.


import Foundation

struct CreativeNonLinearAdsElements {
    // /NonLinear Attributes
    static let nonLinear = "NonLinear"
    static let staticResource = "StaticResource"
    static let NonLinearClickTracking = "NonLinearClickTracking"
    
    static let trackingEvents = "TrackingEvents"
    static let tracking = "Tracking"

}

// VAST/Ad/InLine/Creatives/Creative/
public struct VastNonLinearAdsCreative: Codable {
    public var trackingEvents: [VastTrackingEvent] = []
    public var nonLinear: [VastNonLinear] = []
}

extension VastNonLinearAdsCreative: Equatable {
}
