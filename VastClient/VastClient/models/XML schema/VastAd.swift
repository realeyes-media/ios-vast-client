//
//  VastAd.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct AdElements {
    static let wrapper = "Wrapper"
    static let inLine = "InLine"
    
    static let adSystem = "AdSystem"
    static let adTitle = "AdTitle"
    static let description = "Description"
    static let error = "Error"
    
    static let impression = "Impression"
    static let category = "Category"
    static let advertiser = "Advertiser"
    static let pricing = "Pricing"
    static let survey = "Survey"
    static let viewableImpression = "ViewableImpression"
    static let verification = "Verification"
    
    static let creatives = "Creatives"
    static let creative = "Creative"
    
    static let extensions = "Extensions"
    static let ext = "Extension"
}

struct AdAttributes {
    static let id = "id"
    static let sequence = "sequence"
    static let conditionalAd = "conditionalAd"
}

public enum AdType: String, Codable {
    case inline
    case wrapper
    case unknown
}

public struct VastAd: Codable {
    // Non element type
    public var type: AdType
    
    // attribute
    public let id: String
    public let sequence: Int?
    public let conditionalAd: Bool?
    
    // VAST/Ad/Wrapper and VAST/Ad/InLine elements
    public var adSystem: VastAdSystem?
    public var impressions: [VastImpression] = []
    public var adVerifications: [VastVerification] = []
    public var viewableImpression: VastViewableImpression?
    public var pricing: VastPricing?
    public var errors: [URL] = []
    public var creatives: [VastCreative] = []
    public var extensions: [VastExtension] = []
    
    // Inline only
    public var adTitle: String?
    public var adCategories: [VastAdCategory] = []
    public var description: String?
    public var advertiser: String?
    public var surveys: [VastSurvey] = []
    
    public var wrapper: VastWrapper?
}

extension VastAd {
    public init(attrDict: [String: String]) {
        var id = ""
        var sequence = ""
        var conditionalAd = ""
        for (key, value) in attrDict {
            switch key {
            case AdAttributes.id:
                id = value
            case AdAttributes.sequence:
                sequence = value
            case AdAttributes.conditionalAd:
                conditionalAd = value
            default:
                break
            }
        }
        self.id = id
        self.sequence = Int(sequence)
        self.conditionalAd = conditionalAd.boolValue
        self.type = .unknown
    }
}

extension VastAd: Equatable {
}
