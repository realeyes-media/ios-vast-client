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

public struct VastStaticResource {
    public let creativeType: String
    
    public var url: URL?
}

extension VastStaticResource {
    init?(attrDict: [String: String]) {
        var creativeTypeValue: String?
        attrDict.compactMap { key, value -> (VastIconClickTrackingAttribute, String)? in
            guard let newKey = VastIconClickTrackingAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .id:
                    creativeTypeValue = value
                }
        }
        guard let creativeType = creativeTypeValue else {
            return nil
        }
        self.creativeType = creativeType
    }
}
