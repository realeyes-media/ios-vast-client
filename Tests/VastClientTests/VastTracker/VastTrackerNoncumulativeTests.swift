//
//  VastTrackerNoncumulativeTests.swift
//  VastClientTests
//
//  Created by Jan Bednar on 01/02/2019.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.
//

@testable import VastClient
import XCTest

/** Preroll test case scenario with non-cumulative tracker
 
 - each ads progress starts at time 0
 */
class VastTrackerNoncumulativeTests: XCTestCase {
    var vastTracker: VastTracker!
    var deleagteSpy: VastTrackerDelegateSpy!
    
    let ad1 = VastAd.make(skipOffset: nil, duration: 5, sequence: 1)
    let ad2 = VastAd.make(skipOffset: nil, duration: 10, sequence: 2)
    
    lazy var model: VastModel = {
        VastModel(version: "4.0", ads: [ad1, ad2], errors: [])
    }()
    
    override func setUp() {
        deleagteSpy = VastTrackerDelegateSpy()
        vastTracker = VastTracker(vastModel: model, startTime: 0, supportAdBuffets: false, delegate: deleagteSpy, trackProgressCumulatively: false)
    }
    
    func test_trackingFirstAdHitsFirstQuarter() {
        try? vastTracker.trackAdStart(withId: ad1.id)
        let times = Double.makeArray(to: 2)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        
        XCTAssertFalse(deleagteSpy.midpointDone)
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
    }
    
    func test_trackingFirstAdHitsMidpoint() {
        try? vastTracker.trackAdStart(withId: ad1.id)
        let times = Double.makeArray(to: 3)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        XCTAssertTrue(deleagteSpy.midpointDone)
        
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
    }
    
    func test_trackingFirstAdHitsThirdQuarter() {
        try? vastTracker.trackAdStart(withId: ad1.id)
        let times = Double.makeArray(to: 4)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        XCTAssertTrue(deleagteSpy.midpointDone)
        XCTAssertTrue(deleagteSpy.thirdQuartileDone)
    }
    
    func test_trackingSecondAdHitsFirstQuarter() {
        try? vastTracker.trackAdStart(withId: ad2.id)
        let times = Double.makeArray(to: 2)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        
        XCTAssertFalse(deleagteSpy.midpointDone)
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
    }
    
    func test_trackingSecondAdHitsMidpoint() {
        try? vastTracker.trackAdStart(withId: ad2.id)
        let times = Double.makeArray(to: 3)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        XCTAssertTrue(deleagteSpy.midpointDone)
        
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
    }
    
    func test_trackingSecondAdHitsThirdQuarter() {
        try? vastTracker.trackAdStart(withId: ad2.id)
        let times = Double.makeArray(to: 8)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        XCTAssertTrue(deleagteSpy.midpointDone)
        XCTAssertTrue(deleagteSpy.thirdQuartileDone)
    }
}
