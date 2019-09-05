//
//  VastNonLinearCreative.swift
//  VastClient
//
//  Created by Austin Christensen on 9/4/19.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.


import Foundation

struct CreativeNonLinearElements {
    // /NonLinear Attributes
    static let staticResource = "StaticResource"
    static let NonLinearClickTracking = "NonLinearClickTracking"
    
    static let trackingEvents = "TrackingEvents"
    static let tracking = "Tracking"

}

//fileprivate enum NonLinearCreativeAttribute: String, CaseIterable {
//    case skipoffset
//
//    init?(rawValue: String) {
//        guard let value = NonLinearCreativeAttribute.allCases.first(where: { $0.rawValue.lowercased() == rawValue.lowercased() }) else {
//            return nil
//        }
//        self = value
//    }
//}

// VAST/Ad/InLine/Creatives/Creative/
public struct VastNonLinearCreative {
    public var trackingEvents: [VastTrackingEvent] = []
    public var NonLinear: nonLinearPlaceholder
}

//extension VastNonLinearCreative {
//    public init(attrDict: [String: String]) {
//        var skipOffset: String?
//        attrDict.compactMap { key, value -> (NonLinearCreativeAttribute, String)? in
//            guard let newKey = NonLinearCreativeAttribute(rawValue: key) else {
//                return nil
//            }
//            return (newKey, value)
//            }.forEach { (key, value) in
//                switch key {
//                case .skipoffset:
//                    skipOffset = value
//                }
//        }
//    }
//}

//extension VastNonLinearCreative: Equatable {
//    public static func == (lhs: VastNonLinearCreative, rhs: VastNonLinearCreative) -> Bool {
//        <#code#>
//    }
//    
//}
