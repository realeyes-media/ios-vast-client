//
//  VastStaticResource.swift
//  VastClient
//
//  Created by Jan Bednar on 09/11/2018.
//

import Foundation

enum VastStaticResourceAttribute: String {
    case creativeType
}

public struct VastStaticResource: Codable {
    public let creativeType: String
    
    public var url: URL?
}

extension VastStaticResource {
    init?(attrDict: [String: String]) {
        var creativeTypeValue: String?
        attrDict.compactMap { key, value -> (VastStaticResourceAttribute, String)? in
            guard let newKey = VastStaticResourceAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .creativeType:
                    creativeTypeValue = value
                }
        }
        guard let creativeType = creativeTypeValue else {
            return nil
        }
        self.creativeType = creativeType
    }
}

extension VastStaticResource: Equatable {
}
