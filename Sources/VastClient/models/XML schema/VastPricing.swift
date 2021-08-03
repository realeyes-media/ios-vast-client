//
//  VastPricing.swift
//  VastClient
//
//  Created by Jan Bednar on 12/11/2018.
//

import Foundation

// VAST/Ad/Inline/Pricing/model
public enum PricingModel: String, Codable {
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

enum VastPricingAttribute: String {
    case model
    case currency
}

// VAST/Ad/Inline/Pricing
public struct VastPricing: Codable {
    public let model: PricingModel
    public let currency: String
    
    public var pricing: Double?
}

extension VastPricing {
    init?(attrDict: [String: String]) {
        var modelValue: String?
        var currencyValue: String?
        attrDict.compactMap { key, value -> (VastPricingAttribute, String)? in
            guard let newKey = VastPricingAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
            }.forEach { (key, value) in
                switch key {
                case .model:
                    modelValue = value
                case .currency:
                    currencyValue = value
                }
        }
        guard let model = modelValue, let modelType = PricingModel(string: model), let currency = currencyValue else {
            return nil
        }
        self.model = modelType
        self.currency = currency
    }
}

extension VastPricing: Equatable {
}
