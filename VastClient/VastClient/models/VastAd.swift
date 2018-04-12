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
    static let inline = "InLine"
    static let adsystem = "AdSystem"
    static let adtitle = "AdTitle"
    static let error = "Error"
    static let creatives = "Creatives"
}

struct AdAttributes {
    static let id = "id"
    static let sequence = "sequence"
}

public struct VastAd {
    public let id: String
    public let sequence: Int
    public var adSystem = ""
    public var adTitle = ""
    public var error: URL?
    public var impressions = [VastImpression]()
    public var linearCreatives = [VastLinearCreative]()
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
    }
}
