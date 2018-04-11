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
}

public struct VastMediaFile {
    public let delivery: String
    public let height: String
    public let width: String
    public let id: String
    public let type: String
    public var url: URL?
}

extension VastMediaFile {
    public init(attrDict: [String: String]) {
        var delivery = ""
        var height = ""
        var id = ""
        var type = ""
        var width = ""
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
            default:
                break
            }
        }
        self.delivery = delivery
        self.height = height
        self.width = width
        self.id = id
        self.type = type
    }
}
