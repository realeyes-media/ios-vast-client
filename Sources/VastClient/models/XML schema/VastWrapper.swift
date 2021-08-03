//
//  VastWrapper.swift
//  Nimble
//
//  Created by Jan Bednar on 14/11/2018.
//

import Foundation

enum VastWrapperAttribute: String {
    case followAdditionalWrappers
    case allowMultipleAds
    case fallbackOnNoAd
}

struct VastWrapperElements {
    static let vastAdTagUri = "VASTAdTagURI"
}

public struct VastWrapper: Codable {
    public let followAdditionalWrappers: Bool?
    public let allowMultipleAds: Bool?
    public let fallbackOnNoAd: Bool?
    
    public var adTagUri: URL?
}

extension VastWrapper {
    init(attrDict: [String: String]) {
        var followAdditionalWrappers: String?
        var allowMultipleAds: String?
        var fallbackOnNoAd: String?
        
        attrDict.compactMap { key, value -> (VastWrapperAttribute, String)? in
            guard let newKey = VastWrapperAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .followAdditionalWrappers:
                    followAdditionalWrappers = value
                case .allowMultipleAds:
                    allowMultipleAds = value
                case .fallbackOnNoAd:
                    fallbackOnNoAd = value
                }
        }
        self.followAdditionalWrappers = followAdditionalWrappers?.boolValue
        self.allowMultipleAds = allowMultipleAds?.boolValue
        self.fallbackOnNoAd = fallbackOnNoAd?.boolValue
    }
}

extension VastWrapper: Equatable {
    
}
