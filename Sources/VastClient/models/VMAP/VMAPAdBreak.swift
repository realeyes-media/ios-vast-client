//
//  VMAPAdBreak.swift
//  VastClient
//
//  Created by John Gainfort Jr on 8/8/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct VMAPAdBreakElements {
    static let adbreak = "vmap:AdBreak"
}

struct VMAPAdBreakAttributes {
    static let breakId = "breakId"
    static let breakType = "breakType"
    static let timeOffset = "timeOffset"
    static let repeatAfter = "repeatAfter"
}

public enum VMAPAdBreakType: String, Codable {
    case linear = "linear"
    case nonlinear = "nonlinear"
    case display = "display"
    case unknown = "unknown"
}

public struct VMAPAdBreak: Codable {
    public var breakId: String?
    public var repeatAfter: String?
    public let breakType: VMAPAdBreakType
    public let timeOffset: String
    public var adSource: VMAPAdSource?
    public var trackingEvents = [VMAPTrackingEvent]()
}

extension VMAPAdBreak {
    public init(attrDict: [String: String]) {
        var breakId: String?
        var repeatAfter: String?
        var breakType = VMAPAdBreakType.unknown
        var timeOffset = ""
        for (key, value) in attrDict {
            switch key {
            case VMAPAdBreakAttributes.breakId:
                breakId = value
            case VMAPAdBreakAttributes.breakType:
                breakType = VMAPAdBreakType(rawValue: value) ?? .unknown
            case VMAPAdBreakAttributes.timeOffset:
                timeOffset = value
            case VMAPAdBreakAttributes.repeatAfter:
                repeatAfter = value
            default:
                break
            }
        }
        self.breakId = breakId
        self.breakType = breakType
        self.timeOffset = timeOffset
        self.repeatAfter = repeatAfter
    }

    public func trackEvent(withType type: VMAPTrackingEventType) {
        trackingEvents.filter { $0.event == type }
            .forEach { event in
                guard let url = event.url else { return }
                print("tracking event of type: \(type), url: \(url.absoluteString)")
                track(url: url)
        }
    }

    public func trackEvents(withUrls urls: [URL]) {
        urls.forEach { url in
            print("tracking event of type: \(VMAPTrackingEventType.breakEnd), url: \(url.absoluteString)")
            track(url: url)
        }
    }

}
