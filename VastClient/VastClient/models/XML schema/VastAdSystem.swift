//
//  VastAdSystem.swift
//  VastClient
//
//  Created by Jan Bednar on 12/11/2018.
//

import Foundation

enum VastAdSystemAttribute: String {
    case version
}

public struct VastAdSystem: Codable {
    public let version: String?
    public var system: String?
}

extension VastAdSystem {
    init(attrDict: [String: String]) {
        var versionValue: String?
        attrDict.compactMap { key, value -> (VastAdSystemAttribute, String)? in
            guard let newKey = VastAdSystemAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .version:
                    versionValue = value
                }
        }
        self.version = versionValue
    }
}

extension VastAdSystem: Equatable {
}
