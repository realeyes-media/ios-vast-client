//
//  VastTrackerDelegateSpy.swift
//  VastClientTests
//
//  Created by Jan Bednar on 01/02/2019.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.
//

import Foundation
@testable import VastClient

class VastTrackerDelegateSpy: VastTrackerDelegate {
    private(set) var firstQuartileDone = false
    private(set) var midpointDone = false
    private(set) var thirdQuartileDone = false

    func adFirstQuartile(vastTracker: VastTracker, ad: VastAd) {
        firstQuartileDone = true
    }
    
    func adMidpoint(vastTracker: VastTracker, ad: VastAd) {
        midpointDone = true
    }
    
    func adThirdQuartile(vastTracker: VastTracker, ad: VastAd) {
        thirdQuartileDone = true
    }
}
