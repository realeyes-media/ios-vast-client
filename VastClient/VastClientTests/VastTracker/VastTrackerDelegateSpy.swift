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
    private(set) var adBreakStarted = false
    private(set) var lastStartedAd: VastAd?
    private(set) var firstQuartileDone = false
    private(set) var midpointDone = false
    private(set) var thirdQuartileDone = false
    private(set) var adComplete = false
    private(set) var adBreakComplete = false
    
    func adBreakStart(vastTracker: VastTracker) {
        adBreakStarted = true
    }
    
    func adStart(vastTracker: VastTracker, ad: VastAd) {
        lastStartedAd = ad
        firstQuartileDone = false
        midpointDone = false
        thirdQuartileDone = false
        adComplete = false
    }
    
    func adFirstQuartile(vastTracker: VastTracker, ad: VastAd) {
        guard lastStartedAd == ad else {
            return
        }
        firstQuartileDone = true
    }
    
    func adMidpoint(vastTracker: VastTracker, ad: VastAd) {
        guard lastStartedAd == ad else {
            return
        }
        midpointDone = true
    }
    
    func adThirdQuartile(vastTracker: VastTracker, ad: VastAd) {
        guard lastStartedAd == ad else {
            return
        }
        thirdQuartileDone = true
    }
    
    func adComplete(vastTracker: VastTracker, ad: VastAd) {
        guard lastStartedAd == ad else {
            return
        }
        adComplete = true
        lastStartedAd = nil
    }
    
    func adBreakComplete(vastTracker: VastTracker) {
        adBreakComplete = true
    }
}
