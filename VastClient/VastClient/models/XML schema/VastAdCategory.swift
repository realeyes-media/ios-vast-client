//
//  VastAdCategory.swift
//  VastClient
//
//  Created by Jan Bednar on 12/11/2018.
//

import Foundation

enum VastAdCategoryAttribute: String {
    case authority
}

// VAST/Ad/InLine/Category
public struct VastAdCategory: Codable {
    public let authority: URL?
    
    public var category: String?
}

extension VastAdCategory {
    init?(attrDict: [String: String]) {
        var authorityValue: String?
        attrDict.compactMap { key, value -> (VastAdCategoryAttribute, String)? in
            guard let newKey = VastAdCategoryAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .authority:
                    authorityValue = value
                }
        }
        guard let authority = authorityValue, let authorityUrl = URL(string: authority) else {
            return nil
        }
        self.authority = authorityUrl
    }
}

extension VastAdCategory: Equatable {
}
