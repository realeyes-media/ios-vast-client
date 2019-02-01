//
//  VastTrackerTexts.swift
//  VastClientTests
//
//  Created by Jan Bednar on 01/02/2019.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.
//

import XCTest
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

class VastTrackerNoncumulativeStartTests: XCTestCase {
    var vastTracker: VastTracker!
    var deleagteSpy: VastTrackerDelegateSpy!
    
    let ad1 = VastAd.make(skipOffset: nil, duration: 5, sequence: 1)
    
    lazy var model: VastModel = {
        return VastModel(version: "4.0", ads: [ad1], errors: [])
    }()
    
    override func setUp() {
        deleagteSpy = VastTrackerDelegateSpy()
        vastTracker = VastTracker(id: "id", vastModel: model, startTime: 15, supportAdBuffets: false, delegate: deleagteSpy, trackProgressCumulatively: false)
    }
    
    func test_trackingDoesNotStartBeforeStartTime() {
        let times = Double.makeArray(from: 14, to: 14)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(vastTracker.totalAds, 1)
        XCTAssertEqual(deleagteSpy.lastStartedAd, nil)
        XCTAssertFalse(deleagteSpy.adBreakStarted)
        XCTAssertFalse(deleagteSpy.firstQuartileDone)
        XCTAssertFalse(deleagteSpy.midpointDone)
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingStartsWithFirstAdAtStartTime() {
        let times = Double.makeArray(from: 14, to: 15)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(vastTracker.totalAds, 1)
        XCTAssertTrue(deleagteSpy.adBreakStarted)
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad1)
        
        XCTAssertFalse(deleagteSpy.firstQuartileDone)
        XCTAssertFalse(deleagteSpy.midpointDone)
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingAdHitsFirstQuartile() {
        let times = Double.makeArray(from: 14, to: 17)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(vastTracker.totalAds, 1)
        XCTAssertTrue(deleagteSpy.adBreakStarted)
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad1)
        
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        XCTAssertFalse(deleagteSpy.midpointDone)
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
}

class VastTrackerCumulativeStartTests: XCTestCase {
    var vastTracker: VastTracker!
    var deleagteSpy: VastTrackerDelegateSpy!
    
    let ad1 = VastAd.make(skipOffset: nil, duration: 5, sequence: 1)
    
    lazy var model: VastModel = {
        return VastModel(version: "4.0", ads: [ad1], errors: [])
    }()
    
    override func setUp() {
        deleagteSpy = VastTrackerDelegateSpy()
        vastTracker = VastTracker(id: "id", vastModel: model, startTime: 15, supportAdBuffets: false, delegate: deleagteSpy, trackProgressCumulatively: true)
    }
    
    func test_trackingDoesNotStartBeforeStartTime() {
        let times = Double.makeArray(from: 14, to: 14)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(vastTracker.totalAds, 1)
        XCTAssertEqual(deleagteSpy.lastStartedAd, nil)
        XCTAssertFalse(deleagteSpy.adBreakStarted)
        XCTAssertFalse(deleagteSpy.firstQuartileDone)
        XCTAssertFalse(deleagteSpy.midpointDone)
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingStartsWithFirstAdAtStartTime() {
        let times = Double.makeArray(from: 15, to: 16)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(vastTracker.totalAds, 1)
        XCTAssertTrue(deleagteSpy.adBreakStarted)
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad1)
        
        XCTAssertFalse(deleagteSpy.firstQuartileDone)
        XCTAssertFalse(deleagteSpy.midpointDone)
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingFirstAdHitsFirstQuartile() {
        let times = Double.makeArray(from: 15, to: 17)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(vastTracker.totalAds, 1)
        XCTAssertTrue(deleagteSpy.adBreakStarted)
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad1)
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        
        XCTAssertFalse(deleagteSpy.midpointDone)
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
}


class VastTrackerNoncumulativeTests: XCTestCase {
    
    var vastTracker: VastTracker!
    var deleagteSpy: VastTrackerDelegateSpy!
    
    let ad1 = VastAd.make(skipOffset: nil, duration: 5, sequence: 1)
    let ad2 = VastAd.make(skipOffset: nil, duration: 10, sequence: 2)
    
    lazy var model: VastModel = {
        return VastModel(version: "4.0", ads: [ad1, ad2], errors: [])
    }()
    
    override func setUp() {
        deleagteSpy = VastTrackerDelegateSpy()
        vastTracker = VastTracker(id: "id", vastModel: model, startTime: 0, supportAdBuffets: false, delegate: deleagteSpy, trackProgressCumulatively: false)
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
        VastTrackerNoncumulativeTests.finishTrackingFirstAd(tracker: vastTracker)
        
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
        VastTrackerNoncumulativeTests.finishTrackingFirstAd(tracker: vastTracker)
        let times = Double.makeArray(to: 3)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad2)
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        
        XCTAssertFalse(deleagteSpy.midpointDone)
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingSecondAdHitsMidpoint() {
        VastTrackerNoncumulativeTests.finishTrackingFirstAd(tracker: vastTracker)
        let times = Double.makeArray(to: 5)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad2)
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        XCTAssertTrue(deleagteSpy.midpointDone)
        
        XCTAssertFalse(deleagteSpy.thirdQuartileDone)
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingSecondAdHitsThirdQuarter() {
        VastTrackerNoncumulativeTests.finishTrackingFirstAd(tracker: vastTracker)
        let times = Double.makeArray(to: 8)
        times.forEach { try? vastTracker.updateProgress(time: $0) }
        
        XCTAssertEqual(deleagteSpy.lastStartedAd, self.ad2)
        XCTAssertTrue(deleagteSpy.firstQuartileDone)
        XCTAssertTrue(deleagteSpy.midpointDone)
        XCTAssertTrue(deleagteSpy.thirdQuartileDone)
        
        XCTAssertFalse(deleagteSpy.adComplete)
        XCTAssertFalse(deleagteSpy.adBreakComplete)
    }
    
    func test_trackingSecondAdEnds() {
        VastTrackerNoncumulativeTests.finishTrackingFirstAd(tracker: vastTracker)
        let times = Double.makeArray(to: 10)
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

extension Double {
    static func makeArray(from: Int = 0, to: Int) -> [Double] {
        guard from <= to else {
            return []
        }
        var numbers: [Int] = []
        for i in from...to {
            numbers.append(i)
        }
        return numbers.map { Double($0) }
    }
}

fileprivate extension VastAd {
    static func make(skipOffset: String?, duration: Double, sequence: Int) -> VastAd {
        let files = VastMediaFiles(mediaFiles: [VastMediaFile(delivery: "", type: "", width: "", height: "", codec: "", id: nil, bitrate: nil, minBitrate: nil, maxBitrate: nil, scalable: nil, maintainAspectRatio: nil, apiFramework: nil, url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"))], interactiveCreativeFiles: [])
        
        let linearCreative = VastLinearCreative(skipOffset: skipOffset, duration: duration, adParameters: nil, videoClicks: [], trackingEvents: [], files: files, icons: [])
        let creative = VastCreative(id: nil, adId: nil, sequence: nil, apiFramework: nil, universalAdId: nil, creativeExtensions: [], linear: linearCreative, companionAds: nil)
        
        return VastAd(type: .inline, id: "", sequence: sequence, conditionalAd: nil, adSystem: nil, impressions: [], adVerifications: [], viewableImpression: nil, pricing: nil, errors: [], creatives: [creative], extensions: [], adTitle: nil, adCategories: [], description: nil, advertiser: nil, surveys: [], wrapper: nil)
    }
}
