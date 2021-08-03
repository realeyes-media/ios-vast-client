//
//  VMAPModel.swift
//  VastClient
//
//  Created by John Gainfort Jr on 8/8/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct VMAPElements {
    static let vmap = "vmap:VMAP"
}

struct VMAPAttributes {
    static let version = "version"
}

public struct VMAPModel: Codable {
    public let version: String
    public var adBreaks = [VMAPAdBreak]()
}

extension VMAPModel {
    public init(attrDict: [String: String]) {
        var version = ""
        for (key, value) in attrDict {
            switch key {
            case VMAPAttributes.version:
                version = value
            default:
                break
            }
        }
        self.version = version
    }
}
