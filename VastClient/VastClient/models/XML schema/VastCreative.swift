//
//  VastCreative.swift
//  VastClient
//
//  Created by Jan Bednar on 13/11/2018.
//

import Foundation

struct VastCreativeElements {
    static let universalAdId = "UniversalAdId"
    static let linear = "Linear"
    static let creativeExtension = "CreativeExtension"
}

fileprivate enum VastCreativeAttribute: String {
    case id
    case adId
    case sequence
    case apiFramework
}

public struct VastCreative {
    public let id: String?
    public let adId: String?
    public let sequence: Int?
    public let apiFramework: String?
    
    public var universalAdId: VastUniversalAdId?
    public var creativeExtensions: [VastCreativeExtension] = []
    public var linear: VastLinearCreative?
}

extension VastCreative {
    public init(attrDict: [String: String]) {
        var id: String?
        var adId: String?
        var sequence: String?
        var apiFramework: String?
        
        attrDict.compactMap { key, value -> (VastCreativeAttribute, String)? in
            guard let newKey = VastCreativeAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .id:
                    id = value
                case .adId:
                    adId = value
                case .sequence:
                    sequence = value
                case .apiFramework:
                    apiFramework = value
                }
        }
        self.id = id
        self.adId = adId
        self.sequence = sequence?.intValue
        self.apiFramework = apiFramework
    }
}

extension VastCreative: Equatable {
}
