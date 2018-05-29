//
//  VastTrackingEvent.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public enum TrackingEventType: String {
    case firstQuartile
    case midpoint
    case thirdQuartile
    case complete
    case creativeView
    case start
    case mute
    case unmute
    case pause
    case rewind
    case resume
    case fullscreen
    case exitFullscreen
    case expand
    case collapse
    case acceptInvitationLinear
    case closeLinear
    case skip
    case progress
    case unknown
}

struct TrackingEventElements {
    static let tracking = "Tracking"
}

struct TrackingEventAttributes {
    static let event = "event"
    static let offset = "offset"
}

public struct VastTrackingEvent {
    public let type: TrackingEventType
    public var url: URL?
    public var offset: Double?
    public var tracked = false
}

extension VastTrackingEvent {
    public init(attrDict: [String: String]) {
        var event = TrackingEventType.unknown
        for (key, value) in attrDict {
            if key == TrackingEventAttributes.event {
                if let evt = TrackingEventType(rawValue: value) {
                    event = evt
                }
            }

            if key == TrackingEventAttributes.offset {
                // format is either (HH:MM:SS or HH:MM:SS.mmm) or n%
                self.offset = value.index(of: ":") != nil ? value.toSeconds : Double(value) ?? 0 / 100
            }
        }

        self.type = event
    }
}
