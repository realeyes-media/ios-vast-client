//
//  VastResource.swift
//  Nimble
//
//  Created by Jan Bednar on 14/11/2018.
//

import Foundation

enum VastResourceAttribute: String {
    case apiFramework
}

public struct VastResource: Codable {
    public let apiFramework: String?
    
    public var url: URL?
}

extension VastResource {
    init?(attrDict: [String: String]) {
        var apiFramework: String?
        attrDict.compactMap { key, value -> (VastResourceAttribute, String)? in
            guard let newKey = VastResourceAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .apiFramework:
                    apiFramework = value
                }
        }
        self.apiFramework = apiFramework
    }
}

extension VastResource: Equatable {
}
