//
//  VastExample.swift
//  VastClientWrapper
//
//  Created by John Gainfort Jr on 5/15/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation
import VastClient

let fw_vast_wrapper = "http://office.realeyes.com/jgainfort/replayer/fw_vast_wrapper.xml"
let fw_typical = "http://29773.v.fwmrm.net/ad/g/1?flag=+sltp-slcb+qtcb+aeti+emcr&nw=169843&mode=live&prof=nbcsports_adobe_web&csid=nbcsports_nfl_snf_main_cam&sfid=7090576&afid=140315314&caid=nbcs_136401&vdur=600&resp=vast3&metr=7&pvrn=4980890867&vprn=5987497628;_fw_ae=&_fw_vcid2=169843:9cd22d95-7966-4a38-81f5-5de4c5;slid=mid1&tpos=0&slau=midroll&ptgt=a&tpcl=MIDROLL&maxd=120&cpsq=85&mind=120;"
let fw_test = "http://29773.v.fwmrm.net/ad/g/1?flag=+sltp-slcb+qtcb+aeti+emcr&nw=169843&mode=live&prof=169843:nbcsports_adobe_web&csid=nbcsports_nfl_snf_main_cam&sfid=7090576&afid=140315314&caid=nbcs_145468&vdur=600&resp=vast3&metr=7&pvrn=310894571447039984&vprn=9050660999491739501;_fw_ae=&_fw_vcid2=169843:26026DA7-3BCC-4C70-8877-A06BECEA7ACA;slid=mid1&tpos=0&slau=midroll&ptgt=a&tpcl=MIDROLL&maxd=120.0&cpsq=5&mind=120.0;slid=300companion&slau=FW%20Video-300x250%7CFW%20Video-300x600&ptgt=p&flag=+cmpn&w=300&h=250&cd=300%2C250%7C300%2C600;slid=728companion&slau=FW%20Video-728x90%7CFW%20Video-970x66&ptgt=p&flag=+cmpn&w=728&h=90&cd=728%2C90%7C970%2C66;slid=728fullscreen&slau=FW%20Video-728x90-Image&ptgt=p&flag=+cmpn&w=728&h=90&cd=728%2C90%7C970%2C66;"

class VastExample {

    private var vastClient = VastClient()
    private var vastTracker: VastTracker?
    private var fakePlayheadProgressTimer: Timer?
    private var playhead = 123456.0
    private var currentAdEndTime: TimeInterval?

    init() {
        makeVastRequest()
    }

    private func makeVastRequest() {
        let urlStr = fw_test
        guard let url = URL(string: urlStr) else { return }
        let start = Date()
        vastClient.parseVast(withContentsOf: url) { [weak self] vastModel, error in
            print("Took \(-1 * start.timeIntervalSinceNow) seconds to parse vast document")
            if let error = error as? VastError {
                switch error {
                case .invalidXMLDocument:
                    print("Error: Invalid XML document")
                case .invalidVASTDocument:
                    print("Error: Invalid Vast Document")
                case .unableToCreateXMLParser:
                    print("Error: Unable to Create XML Parser")
                case .unableToParseDocument:
                    print("Error: Unable to Parse Vast Document")
                default:
                    print("Error: unexpected error ...")
                }
                return
            }
            
            guard let vastModel = vastModel else {
                print("Error: unexpected error ...")
                return
            }
            self?.trackAd(vastModel)
        }
    }
    
    private func trackAd(_ ad: VastModel) {
        let delay = 0.1
        vastTracker = VastTracker(id: "test", vastModel: ad, startTime: 123456.0, delegate: self)
        
        guard let tracker = vastTracker else { return }
        fakePlayheadProgressTimer = setInterval(delay) { [weak self] _ in
            guard var playhead = self?.playhead else { return }
            playhead += delay
            self?.playhead = playhead
            
            do {
                if let duration = self?.currentAdEndTime, playhead >= duration {
                    try tracker.finishedPlayback()
                } else {
                    try tracker.updateProgress(time: playhead)
                }
            } catch TrackingError.unableToUpdateProgress(msg: let msg) {
                print("Tracking Error > Unable to update progress: \(msg)")
            } catch {
                print("Tracking Error > unknown")
            }
        }
    }
}

extension VastExample: VastTrackerDelegate {
    func adBreakStart(vastTracker: VastTracker) {
        print("Ad Break Started > Playhead: \(playhead), Number of Ads: \(vastTracker.totalAds)")
    }
    
    func adStart(vastTracker: VastTracker, ad: VastAd) {
        let duration = ad.creatives.first?.linear?.duration
        currentAdEndTime = playhead + (duration ?? 0)
        print("Ad Started > Playhead: \(playhead), Id: \(ad.id), Sequence Number: \(ad.sequence ?? -1), Duration: \(duration ?? -1), skipOffset: \(ad.creatives.first?.linear?.skipOffset ?? "none")")
    }
    
    func adFirstQuartile(vastTracker: VastTracker, ad: VastAd) {
        print("Ad First Quartile > Playhead: \(playhead), Id: \(ad.id)")
    }
    
    func adMidpoint(vastTracker: VastTracker, ad: VastAd) {
        print("Ad Midpoint > Playhead: \(playhead), Id: \(ad.id)")
    }
    
    func adThirdQuartile(vastTracker: VastTracker, ad: VastAd) {
        print("Ad Third Quartile > Playhead: \(playhead), Id: \(ad.id)")
    }
    
    func adComplete(vastTracker: VastTracker, ad: VastAd) {
        print("Ad Complete > Playhead: \(playhead), Id: \(ad.id)")
    }
    
    func adBreakComplete(vastTracker: VastTracker) {
        print("Ad Break Complete > Playhead: \(playhead), Number of Ads: \(vastTracker.totalAds)")
        fakePlayheadProgressTimer?.invalidate()
        fakePlayheadProgressTimer = nil
    }
} 
