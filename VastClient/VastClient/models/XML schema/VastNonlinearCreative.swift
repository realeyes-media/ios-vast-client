//
//  VastNonlinearCreative.swift
//  VastClient
//
//  Created by Austin Christensen on 9/4/19.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.
//

import Foundation

struct CreativeNonlinearElements {
    // /Nonlinear Attributes
    static let staticResource = "StaticResource"
    static let nonlinearClickTracking = "NonLinearClickTracking"
    
    static let trackingEvents = "TrackingEvents"
    static let tracking = "Tracking"

}

fileprivate enum NonlinearCreativeAttribute: String, CaseIterable {
    case skipoffset
    
    init?(rawValue: String) {
        guard let value = NonlinearCreativeAttribute.allCases.first(where: { $0.rawValue.lowercased() == rawValue.lowercased() }) else {
            return nil
        }
        self = value
    }
}

// VAST/Ad/InLine/Creatives/Creative/
public struct VastNonlinearCreative {
    public var trackingEvents: [VastTrackingEvent] = []
    public var nonlinear: nonlinearPlaceholder
}

extension VastNonlinearCreative {
    public init(attrDict: [String: String]) {
        var skipOffset: String?
        attrDict.compactMap { key, value -> (NonlinearCreativeAttribute, String)? in
            guard let newKey = NonlinearCreativeAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .skipoffset:
                    skipOffset = value
                }
        }
    }
}

extension VastNonlinearCreative: Equatable {
}
