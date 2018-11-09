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
    static let conditionalAd = "conditionalAd"
}

public enum AdType {
    case inline
    case wrapper
    case unknown
}

public typealias NotYetParsed = String

public struct VastAd {
    // Non element type
    public var type: AdType
    
    // VAST/Ad parameter
    public let id: String
    public let sequence: Int
    public let conditionalAd: Bool?
    
    // VAST/Ad/Wrapper and VAST/Ad/InLine parameter
    public var adSystemVersion = ""
    public var impressions = [VastImpression]()
    public var adVerification: AdVerification?
    public var viewableImpression: ViewableImpression?
    public var pricing: Pricing?
    public var error: URL?
    
    public var creatives: Creatives? // 1 for inline, 0-1 for wrapper
    
    public var linearCreatives = [VastLinearCreative]()
    
    // Inline only
    public var adTitle = ""
    public var wrapperUrl: URL?
    public var adCategories: [AdCategory] = []
    public var description: NotYetParsed?
    public var advertiser: NotYetParsed?
    public var survey: Survey?
    
    
    // Wrapper only
    public var followAdditionalWrappers: String?
    public var allowMultipleAds: String?
    public var fallbackOnNoAd: String?
    public var extensions = [VastExtension]()
    public var companionAds = [VastCompanionAds]()
}

public struct Creatives {
    
}

public struct Survey {
    public let survey: URL
    
    // attributes
    public let mimeType: NotYetParsed
}


// VAST/Ad/Inline/Pricing
public struct Pricing {
    public let pricing: Float
    
    // attributes
    public let model: PricingModel
    public let currency: NotYetParsed
}

// VAST/Ad/Inline/Pricing/model
public enum PricingModel {
    case cpc
    case cpm
    case cpe
    case cpv
    
    init?(string: String) {
        switch string.lowercased() {
        case "cpc":
            self = .cpc
        case "cpm":
            self = .cpm
        case "cpe":
            self = .cpe
        case "cpv":
            self = .cpv
        default:
            return nil
        }
    }
}

// VAST/Ad/InLine/Category
public struct AdCategory {
    // parameter authority
    public let authority: URL?
    
    // content
    public let category: NotYetParsed
}

// VAST/Ad/InLine/AdVerifications
// VAST/Ad/Wrapper/AdVerifications
public struct AdVerification {
    // Inline and Wrapper
    // /Verification parameter vendor
    public let vendor: NotYetParsed?
    
    // /Verification/ViewableImpression: id
    public let viewableImpressionId: NotYetParsed?
}

// VAST/Ad/InLine//ViewableImpression
// VAST/Ad/Wrapper/ViewableImpression
public struct ViewableImpression {
    // parameter id
    public let id: NotYetParsed //String?
    
    // /Viewable
    public let viewable: NotYetParsed // URI?
    
    // /NotViewable
    public let notViewable: NotYetParsed // URI?
    
    // /ViewUndetermined
    public let viewUndetermined: NotYetParsed // URI?
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
        self.sequence = Int(sequence) ?? 0
        self.conditionalAd = conditionalAd.boolValue
        self.type = .unknown
    }
}
