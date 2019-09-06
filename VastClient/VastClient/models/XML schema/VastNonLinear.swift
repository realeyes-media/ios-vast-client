//
//  VastNonLinear.swift
//  VastClient
//
//  Created by Austin Christensen on 9/4/19.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.
//

import Foundation

fileprivate enum NonLinearAttribute: String {
    case height
    case id
    case width
}

public struct VastNonLinear {
    var height: String
    var id: String
    var width: String
    
    var staticResource: VastStaticResource?
    var nonLinearClickTracking: URL?
}

extension VastNonLinear {
    public init(attrDict: [String: String]) {
        var height = ""
        var id = ""
        var width = ""
        attrDict.compactMap { key, value -> (NonLinearAttribute, String)? in
            guard let newKey = NonLinearAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .height:
                    height = value
                case .id:
                    id = value
                case .width:
                    width = value
                }
        }
        self.height = height
        self.id = id
        self.width = width
    }
}
