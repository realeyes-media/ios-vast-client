//
//  VastExtension.swift
//  VastClient
//
//  Created by John Gainfort Jr on 6/5/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct ExtensionAttributes {
    static let type = "type"
}

struct ExtensionElements {
    static let creativeparameters = "CreativeParameters" // TODO: this needs to be defined outside the library
    static let creativeparameter = "CreativeParameter" // TODO: this needs to be defined outside the library
}

public struct VastExtension: Codable {
    public let type: String
    public var creativeParameters = [VastCreativeParameter]()
}

extension VastExtension {
    public init(attrDict: [String: String]) {
        var type = ""
        for (key, value) in attrDict {
            switch key {
            case ExtensionAttributes.type:
                type = value
            default:
                break
            }
        }
        self.type = type
    }
}

extension VastExtension: Equatable {
    public static func == (lhs: VastExtension, rhs: VastExtension) -> Bool {
        return lhs.type == rhs.type
    }
}
