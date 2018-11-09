//
//  VastVideoClick.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct VideoClickElements {
    static let clickthrough = "ClickThrough" //InLine only
    static let clicktracking = "ClickTracking"
    static let customclick = "CustomClick"
}

struct VideoClickAttributes {
    static let id = "id"
}

public enum ClickType: String {
    case clickThrough = "ClickThrough" //InLine only
    case clickTracking = "ClickTracking"
    case customClick = "CustomClick"
}

public struct VastVideoClick {
    public let id: String
    public let type: ClickType
    public var url: URL?
}

extension VastVideoClick {
    public init(type: ClickType, attrDict: [String: String]) {
        self.type = type
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
