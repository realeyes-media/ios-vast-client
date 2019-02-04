//
//  VastTrackerAccumulativeTests.swift
//  VastClientTests
//
//  Created by Jan Bednar on 01/02/2019.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.
//

import XCTest
@testable import VastClient

/** Preroll test case scenario with cumulative tracker
 
 - you are tracking the compelte time in host application
 - first ad starts at 0
 - next ad starts after but you track the progress including the progress from first ad
 */
class VastTrackerAccumulativeTests: XCTestCase {
    
    var vastTracker: VastTracker!
    var deleagteSpy: VastTrackerDelegateSpy!
    
    let ad1 = VastAd.make(skipOffset: nil, duration: 5, sequence: 1)
    let ad2 = VastAd.make(skipOffset: nil, duration: 10, sequence: 2)
    
    lazy var model: VastModel = {
        return VastModel(version: "4.0", ads: [ad1, ad2], errors: [])
    }()
    
    override func setUp() {
        deleagteSpy = VastTrackerDelegateSpy()
        vastTracker = VastTracker(id: "id", vastModel: model, startTime: 0, supportAdBuffets: false, delegate: deleagteSpy, trackProgressCumulatively: true)
    }
    
    func test_trackingStartsWithFirstAd() {
        try? vastTracker.updateProgress(time: 0)
        
        XCTAssertEqual(vastTracker.totalAds, 2)
        XCTAssertTrue(deleagteSpy.adBreakStarted)
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad1)
        
        XCTAssertFalse(deleagteSpy.firstQuartileDone)
        XCTAssertFalse(deleagteSpy.midpointDone)
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingFirstAdHitsFirstQuarter() {
        let times = Double.makeArray(to: 2)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad1)
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        
        XCTAssertFalse(deleagteSpy.midpointDone)
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingFirstAdHitsMidpoint() {
        let times = Double.makeArray(to: 3)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad1)
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        XCTAssertTrue(deleagteSpy.midpointDone)
        
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingFirstAdHitsThirdQuarter() {
        let times = Double.makeArray(to: 4)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad1)
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        XCTAssertTrue(deleagteSpy.midpointDone)
        XCTAssertTrue(deleagteSpy.thirdQuartileDone)
        
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingFirstAdEnds() {
        VastTrackerAccumulativeTests.finishTrackingFirstAd(tracker: vastTracker)
        
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad2)
        
        XCTAssertFalse(deleagteSpy.firstQuartileDone)
        XCTAssertFalse(deleagteSpy.midpointDone)
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    private static func finishTrackingFirstAd(tracker: VastTracker) {
        let times = Double.makeArray(to: 5)
        times.forEach { try? tracker.updateProgress(time: $0) }
        try? tracker.finishedPlayback()
    }
    
    func test_trackingSecondAdHitsFirstQuarter() {
        VastTrackerAccumulativeTests.finishTrackingFirstAd(tracker: vastTracker)
        let times = Double.makeArray(from: 6, to: 5 + 3)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad2)
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        
        XCTAssertFalse(deleagteSpy.midpointDone)
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingSecondAdHitsMidpoint() {
        VastTrackerAccumulativeTests.finishTrackingFirstAd(tracker: vastTracker)
        let times = Double.makeArray(from: 6, to: 5 + 5)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad2)
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        XCTAssertTrue(deleagteSpy.midpointDone)
        
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingSecondAdHitsThirdQuarter() {
        VastTrackerAccumulativeTests.finishTrackingFirstAd(tracker: vastTracker)
        let times = Double.makeArray(from: 6, to: 5 + 8)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad2)
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        XCTAssertTrue(deleagteSpy.midpointDone)
        XCTAssertTrue(deleagteSpy.thirdQuartileDone)
        
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingSecondAdEnds() {
        VastTrackerAccumulativeTests.finishTrackingFirstAd(tracker: vastTracker)
        let times = Double.makeArray(from: 6, to: 5 + 10)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        try? vastTracker.finishedPlayback()
        
        XCTAssertEqual(deleagteSpy.lastStartedAd, nil)
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        XCTAssertTrue(deleagteSpy.midpointDone)
        XCTAssertTrue(deleagteSpy.thirdQuartileDone)
        XCTAssertTrue(deleagteSpy.adComplete)
        XCTAssertTrue(deleagteSpy.adBreakComplete)
    }
}
