//
//  VastAd.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct AdElements {
    static let ad = "Ad"
    static let wrapper = "Wrapper"
    static let vastAdTagUri = "VASTAdTagURI"
    static let inline = "InLine"
    static let adsystem = "AdSystem"
    static let adtitle = "AdTitle"
    static let description = "Description"
    static let error = "Error"
    static let creatives = "Creatives"
    static let extensions = "Extensions"
}

struct AdAttributes {
    static let id = "id"
    static let sequence = "sequence"
}

public enum AdType {
    case inline
    case wrapper
    case unknown
}

public struct VastAd {
    public let id: String
    public let sequence: Int
    public var adSystem = ""
    public var adTitle = ""
    public var error: URL?
    public var type: AdType
    public var impressions = [VastImpression]()
    public var linearCreatives = [VastLinearCreative]()
    public var extensions = [VastExtension]()
}

extension VastAd {
    public init(attrDict: [String: String]) {
        var id = ""
        var sequence = ""
        for (key, value) in attrDict {
            switch key {
            case AdAttributes.id:
                id = value
            case AdAttributes.sequence:
                sequence = value
            default:
                break
            }
        }
        self.id = id
        self.sequence = Int(sequence) ?? 0
        self.type = .unknown
    }
}
