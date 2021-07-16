//
//  IconClicks.swift
//  VastClient
//
//  Created by Jan Bednar on 09/11/2018.
//

import Foundation

struct IconClicksElements {
    static let iconClickThrough = "IconClickThrough"
    static let iconClickTracking = "IconClickTracking"
}

public struct IconClicks: Codable {
    public var iconClickThrough: URL?
    public var iconClickTracking: [VastIconClickTracking] = []
}

extension IconClicks: Equatable {
}
