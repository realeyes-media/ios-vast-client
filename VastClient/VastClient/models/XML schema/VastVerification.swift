//
//  VastVerification.swift
//  VastClient
//
//  Created by Jan Bednar on 12/11/2018.
//

import Foundation

enum VastAdVerificationAttribute: String {
    case vendor
}

struct VastAdVerificationElements {
    static let viewableImpression = "ViewableImpression"
}

// VAST/Ad/InLine/AdVerifications/Verification
// VAST/Ad/Wrapper/AdVerifications/Verification
public struct VastVerification {
    public let vendor: URL
    
    public var viewableImpression: VastViewableImpression?
}

extension VastVerification {
    init?(attrDict: [String: String]) {
        var vendorValue: String?
        attrDict.compactMap { key, value -> (VastAdVerificationAttribute, String)? in
            guard let newKey = VastAdVerificationAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .vendor:
                    vendorValue = value
                }
        }
        guard let vendor = vendorValue, let vendorUrl = URL(string: vendor) else {
            return nil
        }
        self.vendor = vendorUrl
    }
}
