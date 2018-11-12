//
//  VastLinearCreative.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct CreativeLinearElements {
    static let duration = "Duration"
    static let adParameters = "AdParameters"

    // /MediaFiles
    static let mediafile = "MediaFile"
    static let interactiveCreativeFile = "InteractiveCreativeFile"
    
    // /VideoClicks
    static let clickthrough = "ClickThrough"
    static let clicktracking = "ClickTracking"
    static let customclick = "CustomClick"
    
    static let trackingEvents = "TrackingEvents"
    static let tracking = "Tracking"
    
    // /Icons
    static let icon = "Icon"
}

fileprivate enum LinearCreativeAttribute: String {
    case skipOffset
}

// VAST/Ad/InLine/Creatives/Creative
// VAST/Ad/Wrapper/Creatives/Creative
public struct VastLinearCreative {
    public let skipOffset: String?
    
    public var duration: Double? // Inline only
    public var adParameters: VastAdParameters? // Inline only
    public var videoClicks: [VastVideoClick] = []
    public var trackingEvents: [VastTrackingEvent] = []
    public var mediaFiles: VastMediaFiles?
    public var icons = [VastIcon]()
}

extension VastLinearCreative {
    public init(attrDict: [String: String]) {
        var skipOffset: String?
        attrDict.compactMap { key, value -> (LinearCreativeAttribute, String)? in
            guard let newKey = LinearCreativeAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .skipOffset:
                    skipOffset = value
                }
        }
        self.skipOffset = skipOffset
    }
}
