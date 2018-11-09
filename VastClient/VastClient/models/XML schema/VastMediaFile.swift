//
//  VastMediaFile.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct MediaFileElements {
    static let mediafile = "MediaFile"
}

struct MediaFileAttributes {
    static let delivery = "delivery"
    static let height = "height"
    static let id = "id"
    static let type = "type"
    static let width = "width"
    static let codec = "codec"
    static let bitrate = "bitrate"
    static let minBitrate = "minBitrate"
    static let maxBitrate = "maxBitrate"
    static let scalable = "scalable"
    static let maitainAspectRatio = "maitainAspectRatio"
    static let apiFramework = "apiFramework"
}

public struct VastMediaFile {
    // attributes
    public let delivery: String
    public let type: String
    public let width: String
    public let height: String
    public let codec: String?
    public let id: String?
    public let bitrate: Int?
    public let minBitrate: Int?
    public let maxBitrate: Int?
    public let scalable: Bool?
    public let maitainAspectRatio: Bool?
    public let apiFramework: String?
    
    // content
    public var url: URL?
}

extension VastMediaFile {
    public init(attrDict: [String: String]) {
        var delivery = ""
        var height = ""
        var id = ""
        var type = ""
        var width = ""
        var codec: String?
        var bitrate: String?
        var minBitrate: String?
        var maxBitrate: String?
        var scalable: String?
        var maitainAspectRatio: String?
        var apiFramework: String?
        
        for (key, value) in attrDict {
            switch key {
            case MediaFileAttributes.delivery:
                delivery = value
            case MediaFileAttributes.height:
                height = value
            case MediaFileAttributes.id:
                id = value
            case MediaFileAttributes.type:
                type = value
            case MediaFileAttributes.width:
                width = value
            case MediaFileAttributes.codec:
                codec = value
            case MediaFileAttributes.bitrate:
                bitrate = value
            case MediaFileAttributes.minBitrate:
                minBitrate = value
            case MediaFileAttributes.maxBitrate:
                maxBitrate = value
            case MediaFileAttributes.scalable:
                scalable = value
            case MediaFileAttributes.maitainAspectRatio:
                maitainAspectRatio = value
            case MediaFileAttributes.apiFramework:
                apiFramework = value
            default:
                break
            }
        }
        self.delivery = delivery
        self.height = height
        self.width = width
        self.id = id
        self.type = type
        self.codec = codec
        self.bitrate = bitrate?.intValue
        self.minBitrate = minBitrate?.intValue
        self.maxBitrate = maxBitrate?.intValue
        self.scalable = scalable?.boolValue
        self.maitainAspectRatio = maitainAspectRatio?.boolValue
        self.apiFramework = apiFramework
    }
}
