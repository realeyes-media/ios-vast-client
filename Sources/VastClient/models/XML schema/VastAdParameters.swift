//
//  VastAdParameters.swift
//  VastClient
//
//  Created by Jan Bednar on 09/11/2018.
//

import Foundation

enum VastAdParametersAttribute: String {
    case xmlEncoded
}

public struct VastAdParameters: Codable {
    public let xmlEncoded: String?
    
    public var content: String?
}

extension VastAdParameters {
    init(attrDict: [String: String]) {
        var xmlEncoded: String?
        attrDict.compactMap( {key, value -> (VastAdParametersAttribute, String)? in
            guard let newKey = VastAdParametersAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
        }).forEach { (key, value) in
            switch key {
            case .xmlEncoded:
                xmlEncoded = value
            }
        }
        self.xmlEncoded = xmlEncoded
    }
}

extension VastAdParameters: Equatable {
}
