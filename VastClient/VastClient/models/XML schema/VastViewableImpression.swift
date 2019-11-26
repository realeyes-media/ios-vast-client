//
//  VastViewableImpression.swift
//  VastClient
//
//  Created by Jan Bednar on 12/11/2018.
//

import Foundation

enum VastViewableImpressionAttribute: String {
    case id
}

struct VastViewableImpressionElements {
    static let viewable = "Viewable"
    static let notViewable = "NotViewable"
    static let viewUndetermined = "ViewUndetermined"
}

public enum VastViewableImpressionType: String {
    case viewable
    case notViewable
    case viewUndetermined
}

// VAST/Ad/InLine/ViewableImpression
// VAST/Ad/Wrapper/ViewableImpression
// VAST/Ad/InLine/AdVerifications/Verification/ViewableImpression
// VAST/Ad/Wrapper/AdVerifications/Verification/ViewableImpression
public struct VastViewableImpression: Codable {
    public let id: String
    
    public var url: URL? = nil //for verification only
    
    public var viewable: [URL] = []
    public var notViewable: [URL] = []
    public var viewUndetermined: [URL] = []
}

extension VastViewableImpression {
    init?(attrDict: [String: String]) {
        var idValue: String?
        attrDict.compactMap { key, value -> (VastViewableImpressionAttribute, String)? in
            guard let newKey = VastViewableImpressionAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .id:
                    idValue = value
                }
        }
        guard let id = idValue else {
            return nil
        }
        self.id = id
    }
}

extension VastViewableImpression: Equatable {
}
