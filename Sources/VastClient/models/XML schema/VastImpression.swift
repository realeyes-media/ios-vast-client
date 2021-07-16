//
//  VastImpression.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct ImpressionAttributes {
    static let id = "id"
}

public struct VastImpression: Codable {
    public let id: String?
    
    public var url: URL?
}

extension VastImpression {
    public init(attrDict: [String: String]) {
        var id: String?
        for (key, value) in attrDict {
            switch key {
            case ImpressionAttributes.id:
                id = value
            default:
                break
            }
        }
        self.id = id
    }
}

extension VastImpression: Equatable {
}
