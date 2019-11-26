//
//  VastCompanionAds.swift
//  VastClient
//
//  Created by John Gainfort Jr on 6/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

struct CompanionAdsAttributes {
    static let required = "required"
}

struct CompanionAdsElements {
    static let companion = "Companion"
}

/**
 In VAST 3.0, the required attribute for the <CompanionAds> element provides information about which Companion creative to display
 when multiple Companions are supplied and whether the Ad can be displayed without its Companion creative. The value for required can be one
 of three values: all, any, none.
 */
public enum CompanionsRequirement: String, Codable {
    /**
     The video player must attempt to display the contents for all <Companion> elemens provided;
     if all Companion creative cannot be displayed, the Ad should be disregarded and the ad server should be notified using the <Error> element.
     */
    case all = "all"
    /**
     The video player must attempt to display content from at least one of the <Companion> elements provided
     (i.e. display the one with dimensions that best fit the page); if none of the Companion creative can be displayed, the Ad should be disregarded
     and the ad server should be notified using the <Error> element.
     */
    case any = "any"
    /**
     The video player may choose to not display any of the Companion creative, but is not restricted from doing so; The ad server may
     use this option when the advertiser prefers that the master ad be displayed with or without the Companion creative.
     */
    case none = "none"
}


public struct VastCompanionAds: Codable {
    public let required: CompanionsRequirement
    public var companions: [VastCompanionCreative] = []
}

extension VastCompanionAds {
    public init(attrDict: [String: String]) {
        var required: CompanionsRequirement = .none

        for (key, value) in attrDict {
            switch key {
            case CompanionAdsAttributes.required:
                required = CompanionsRequirement(rawValue: value) ?? .none
            default:
                break
            }
        }

        self.required = required
    }
}
extension VastCompanionAds: Equatable {}
