//
//  VastTracker.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public class VastTracker {

    private let ads: [VastAd]
    private let startTime: Double
    private var currentTime = 0.0
    private var playhead: Double {
        get {
            return max(0, currentTime - startTime)
        }
    }

    public init(ads: [VastAd], startTime: Double) {
        self.startTime = startTime
        self.ads = ads
    }

    public func updateProgress(time: Double) {
        currentTime = time
    }

//    public func clicked() -> URL? {
//
//    }

}
