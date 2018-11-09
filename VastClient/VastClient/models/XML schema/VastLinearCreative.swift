//
//  VastLinearCreative.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct LinearCreativeElements {
    static let creative = "Creative"
    
    static let universalAdId = "UniversalAdId"
    static let creativeExtensions = "CreativeExtensions"
    static let linear = "Linear"
    
    static let duration = "Duration"
    static let mediafiles = "MediaFiles"
    static let adParameters = "AdParameters"
    static let trackingevents = "TrackingEvents"
    static let videoclicks = "VideoClicks"
    static let icons = "Icons"
    
    static let interactiveCreativeFile = "InteractiveCreativeFile"
}

struct LinearCreativeAttributes {
    static let adid = "adId"
    static let id = "id"
    static let sequence = "sequence"
    static let apiFramework = "apiFramework"
    
    static let skipOffset = "skipOffset"
}

public struct VastMediaFiles {
    public var mediaFiles: [VastMediaFile] = []
    public var interactiveCreativeFile: [VastInteractiveCreativeFile] = []
}

// VAST/Ad/InLine/Creatives/Creative
// VAST/Ad/Wrapper/Creatives/Creative
public struct VastLinearCreative {
    // attributes
    public let sequence: Int
    public let adId: String
    public let id: String
    public let apiFramework: String?
    public let skipOffset: String? // Inline only
    
    // elements
    
    // /UniversalAdId
    public var universalAdId: VastUniversalAdId? // Inline only
    // /CreativeExtension
    public var creativeExtensions: [VastCreativeExtension]? // Inline only
    
    // /Linear
    public var duration: Double? // Inline only
    public var adParameters: VastAdParameters? // Inline only
    public var mediaFiles: VastMediaFiles?
    
    public var videoClicks = [VastVideoClick]()
    
    public var trackingEvents = [VastTrackingEvent]()
    
    public var interactiveCreativeFile: VastInteractiveCreativeFile? //wrapper only
    
    public var icons = [VastIcon]()
}

extension VastLinearCreative {
    public init(attrDict: [String: String]) {
        var adId = ""
        var id = ""
        var sequence = ""
        var apiFramework: String?
        var skipOffset: String?
        for (key, value) in attrDict {
            switch key {
            case LinearCreativeAttributes.adid:
                adId = value
            case LinearCreativeAttributes.id:
                id = value
            case LinearCreativeAttributes.sequence:
                sequence = value
            case LinearCreativeAttributes.apiFramework:
                apiFramework = value
            case LinearCreativeAttributes.skipOffset:
                skipOffset = value
            default:
                break
            }
        }
        self.adId = adId
        self.id = id
        self.sequence = Int(sequence) ?? 0
        self.apiFramework = apiFramework
        self.skipOffset = skipOffset
    }
}
