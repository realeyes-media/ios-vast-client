//
//  VastInteractiveCreativeFile.swift
//  VastClient
//
//  Created by Jan Bednar on 09/11/2018.
//

import Foundation

fileprivate enum VastInteractiveCreativeFileAttributes: String {
    case type
    case apiFramework
}

public struct VastInteractiveCreativeFile: Codable {
    public let type: String?
    public let apiFramework: String?

    public var url: URL?
}

extension VastInteractiveCreativeFile {
    init?(attrDict: [String: String]) {
        var type: String?
        var apiFramework: String?
        
        attrDict.compactMap { (key, value) -> (VastInteractiveCreativeFileAttributes, String)? in
            guard let newKey = VastInteractiveCreativeFileAttributes(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .type:
                    type = value
                case .apiFramework:
                    apiFramework = value
                }
        }
        self.type = type
        self.apiFramework = apiFramework
    }
}

extension VastInteractiveCreativeFile: Equatable {
}
