//
//  VastTrackingEvent.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public enum TrackingEventType: String {
    case firstQuartile = "firstQuartile"
    case midpoint = "midpoint"
    case thirdQuartile = "thirdQuartile"
    case complete = "complete"
    case unknown = "unknown"
}

struct TrackingEventElements {
    static let tracking = "Tracking"
}

struct TrackingEventAttributes {
    static let event = "event"
}

public struct VastTrackingEvent {
    public let type: TrackingEventType
    public var url: URL?
}

extension VastTrackingEvent {
    public init(attrDict: [String: String]) {
        var event = TrackingEventType.unknown
        for (key, value) in attrDict {
            switch key {
            case TrackingEventAttributes.event:
                switch value {
                case TrackingEventType.firstQuartile.rawValue:
                    event = TrackingEventType.firstQuartile
                case TrackingEventType.midpoint.rawValue:
                    event = TrackingEventType.midpoint
                case TrackingEventType.thirdQuartile.rawValue:
                    event = TrackingEventType.thirdQuartile
                case TrackingEventType.complete.rawValue:
                    event = TrackingEventType.complete
                default:
                    event = TrackingEventType.unknown
                }
            default:
                break
            }
        }
        self.type = event
    }
}
