//
//  VastIcon.swift
//  VastClient
//
//  Created by Jan Bednar on 09/11/2018.
//

import Foundation

struct VastIconElements {
    static let staticResource = "StaticResource"
    static let iFrameResource = "IFrameResource"
    static let htmlResource = "HTMLResource"
    static let iconClicks = "IconClicks"
    static let iconViewTracking = "IconViewTracking"
}

enum VastIconAttribute: String {
    case program
    case width
    case height
    case xPosition
    case yPosition
    case duration
    case offset
    case apiFramework
    case pxratio
}

public struct VastIcon: Codable {
    public let program: String
    public let width: Int
    public let height: Int
    public let xPosition: String //([0-9]*|left|right)
    public let yPosition: String //([0-9]*|top|bottom)
    public let duration: Double
    public let offset: Double
    public let apiFramework: String
    public let pxratio: Double
    
    public var iconViewTracking: [URL] = []
    public var iconClicks: IconClicks?
    public var staticResource: [VastStaticResource] = []
}

extension VastIcon {
    public init(attrDict: [String: String]) {
        var program = ""
        var width = ""
        var height = ""
        var xPosition = ""
        var yPosition = ""
        var duration = ""
        var offset = ""
        var apiFramework = ""
        var pxratio = ""
        attrDict.compactMap( {key, value -> (VastIconAttribute, String)? in
            guard let newKey = VastIconAttribute(rawValue: key) else {
                return nil
            }
            return (newKey, value)
        }).forEach { (key, value) in
            switch key {
            case .program:
                program = value
            case .width:
                width = value
            case .height:
                height = value
            case .xPosition:
                xPosition = value
            case .yPosition:
                yPosition = value
            case .duration:
                duration  = value
            case .offset:
                offset  = value
            case .apiFramework:
                apiFramework = value
            case .pxratio:
                pxratio = value
            }
        }
        
        self.program = program
        self.width = width.intValue ?? 0
        self.height = height.intValue ?? 0
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.duration = duration.toSeconds ?? 0
        self.offset = offset.toSeconds ?? 0
        self.apiFramework = apiFramework
        self.pxratio = pxratio.doubleValue ?? 1
    }
}

extension VastIcon: Equatable {
}
