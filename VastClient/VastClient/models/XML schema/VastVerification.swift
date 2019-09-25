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
    static let javaScriptResource = "JavaScriptResource"
    static let flashResource = "FlashResource"
    static let verificationParameters = "VerificationParameters"
}

// VAST/Ad/InLine/AdVerifications/Verification
// VAST/Ad/Wrapper/AdVerifications/Verification
public struct VastVerification: Codable {
    public let vendor: URL?
    public var viewableImpression: VastViewableImpression?
    public var javaScriptResource: [VastResource] = []
    public var flashResources: [VastResource] = []
    public var verificationParameters: VastAdVerificationParameters?
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
        self.vendor = URL(string: vendorValue ?? "")
    }
}

extension VastVerification: Equatable {
}
