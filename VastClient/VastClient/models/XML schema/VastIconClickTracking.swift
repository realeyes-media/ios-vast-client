//
//  VastIconClickTracking.swift
//  VastClient
//
//  Created by Jan Bednar on 09/11/2018.
//

import Foundation

enum VastIconClickTrackingAttribute: String {
    case id
}

public struct VastIconClickTracking {
    public let id: String?
    public let url: URL
}

extension VastIconClickTracking {
    init?(url: URL, attrDict: [String: String]) {
        var id: String?
        attrDict.compactMap{ key, value -> (VastIconClickTrackingAttribute, String)? in
            guard let newKey = VastIconClickTrackingAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
        }.forEach { (key, value) in
                switch key {
                case .id:
                    id = value
                }
        }
        self.id = id
        self.url = url
    }
}
