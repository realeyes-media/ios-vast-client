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
    public let url: URL
}

extension VastStaticResource {
    init?(url: URL, attrDict: [String: String]) {
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
        self.url = url
    }
}

public struct VastIFrameResource {
    public let url: URL
}

public struct VastHtmlResource {
    public let url: URL
}
