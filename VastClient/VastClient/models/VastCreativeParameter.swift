//
//  VastCreativeParameter.swift
//  VastClient
//
//  Created by John Gainfort Jr on 6/5/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

// TODO: this is really a custom xml element
// needs to be defined outside of the library
// need to find a way to pass custom elements to the library to use

struct CreativeParameterAttributes {
    static let creativeId = "creativeId"
    static let name = "name"
    static let type = "type"
}

@objc public class VastCreativeParameter: NSObject {
    
    @objc public var creativeId: String
    @objc public var name: String
    @objc public var type: String // TODO: enum
    @objc public var content: String?
    
    public init(creativeId: String, name: String, type: String, content: String? = nil) {
        self.creativeId = creativeId
        self.name = name
        self.type = type
        self.content = content
    }
  
}

extension VastCreativeParameter {
    public convenience init(attrDict: [String: String]) {
        var creativeId = ""
        var name = ""
        var type = ""
        for (key, value) in attrDict {
            switch key {
            case CreativeParameterAttributes.creativeId:
                creativeId = value
            case CreativeParameterAttributes.name:
                name = value
            case CreativeParameterAttributes.type:
                type = value
            default:
                break
            }
        }
        
        self.init(creativeId: creativeId, name: name, type: type)
        
    }
}
