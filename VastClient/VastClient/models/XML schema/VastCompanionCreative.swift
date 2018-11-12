//
//  VastCompanionCreative.swift
//  VastClient
//
//  Created by John Gainfort Jr on 6/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

//public enum CompanionResourceType: String {
//    /**
//     Describes non-html creative where an attribute for creativeType is used to identify the creative resource platform.
//     The video player uses the creativeType information to determine how to display the resource:
//
//     image/gif, image/jpeg, image/png: displayed using the HTML tag <img> and the resource URI as the src attribute
//     application/x-javascript: displayed using the HTML tag <script> and the resource URI as the src attribute
//     applicaton/x-shockwave-flash: displayed using the Flash player
//     */
//    case staticresource = "StaticResource"
//    /**
//     Describes a resouce that is a HTML page that can be displayed within an iframe on the publishers page
//     */
//    case iframeresource = "IFrameResource"
//    /**
//     Describes a "snippet" of html code to be inserted directly within the publishers HTML page code
//     */
//    case htmlresource = "HTMLResource"
//    case unknown
//}
//
//struct CompanionElements {
//    static let alttext = "AltText"
//    static let companionclickthrough = "CompanionClickThrough"
//    static let companionclicktracking = "CompanionClickTracking"
//    static let trackingevents = "TrackingEvents"
//    static let adparameters = "adparameters"
//}
//
//struct CompanionAttributes {
//    static let width = "width"
//    static let height = "height"
//    static let id = "id"
//    static let assetwidth = "assetWidth"
//    static let assetheight = "assetHeight"
//    static let expandedwidth = "expandedWidth"
//    static let expandedheight = "expandedHeight"
//    static let apiframework = "apiFramework"
//    static let adslotid = "adSlotId"
//}
//
//public struct VastCompanionCreative {
//    public let width: Int
//    public let height: Int
//    public let id: String?
//    public let assetWidth: Int?
//    public let assetHeight: Int?
//    public let expandedWidth: Int?
//    public let expandedHeight: Int?
//    public let apiFramework: String?
//    public let adSlotId: String?
//    public var type: CompanionResourceType
//    public var content: String?
//    public var altText: String?
//    public var clickThrough: URL?
//    public var clickTracking: URL?
//    public var trackingEvents = [VastTrackingEvent]()
//}
//
//extension VastCompanionCreative {
//    public init(attrDict: [String: String]) {
//        var width = 0
//        var height = 0
//        var id: String?
//        var assetWidth: Int?
//        var assetHeight: Int?
//        var expandedWidth: Int?
//        var expandedHeight: Int?
//        var apiFramework: String?
//        var adSlotId: String?
//
//        for (key, value) in attrDict {
//            switch key {
//            case CompanionAttributes.width:
//                width = Int(value) ?? 0
//            case CompanionAttributes.height:
//                height = Int(value) ?? 0
//            case CompanionAttributes.id:
//                id = value
//            case CompanionAttributes.assetwidth:
//                assetWidth = Int(value)
//            case CompanionAttributes.assetheight:
//                assetHeight = Int(value)
//            case CompanionAttributes.expandedwidth:
//                expandedWidth = Int(value)
//            case CompanionAttributes.expandedheight:
//                expandedHeight = Int(value)
//            case CompanionAttributes.apiframework:
//                apiFramework = value
//            case CompanionAttributes.adslotid:
//                adSlotId = value
//            default:
//                break
//            }
//        }
//
//        self.width = width
//        self.height = height
//        self.id = id
//        self.assetWidth = assetWidth
//        self.assetHeight = assetHeight
//        self.expandedWidth = expandedWidth
//        self.expandedHeight = expandedHeight
//        self.apiFramework = apiFramework
//        self.adSlotId = adSlotId
//        self.type = .unknown
//    }
//}
