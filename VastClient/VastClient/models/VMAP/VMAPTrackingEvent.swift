//
//  VMAPTrackingEvent.swift
//  VastClient
//
//  Created by John Gainfort Jr on 8/8/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct VMAPTrackingEventElements {
    static let trackingEvents = "vmap:TrackingEvents"
    static let tracking = "vmap:Tracking"
}

struct VMAPTrackingEventAttributes {
    static let event = "event"
}

public enum VMAPTrackingEventType: String, Codable {
    case breakStart = "breakStart"
    case breakEnd = "breakEnd"
    case error = "error"
    case unknown = "unknown"
}

public struct VMAPTrackingEvent: Codable {
    public let event: VMAPTrackingEventType
    public var url: URL?
}

extension VMAPTrackingEvent {
    public init(attrDict: [String: String]) {
        var event = VMAPTrackingEventType.unknown
        for (key, value) in attrDict {
            switch key {
            case VMAPTrackingEventAttributes.event:
                event = VMAPTrackingEventType(rawValue: value) ?? .unknown
            default:
                break
            }
        }
        self.event = event
    }
}
