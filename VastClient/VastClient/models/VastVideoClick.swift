//
//  VastVideoClick.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct VideoClickElements {
    static let clickthrough = "ClickThrough"
}

struct VideoClickAttributes {
    static let id = "id"
}

public struct VastVideoClick {
    public let id: String
    public var url: URL?
}

extension VastVideoClick {
    public init(attrDict: [String: String]) {
        var id = ""
        for (key, value) in attrDict {
            switch key {
            case VideoClickAttributes.id:
                id = value
            default:
                break
            }
        }
        self.id = id
    }
}
