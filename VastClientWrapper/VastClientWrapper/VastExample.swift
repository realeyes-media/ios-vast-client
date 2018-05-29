//
//  VastExample.swift
//  VastClientWrapper
//
//  Created by John Gainfort Jr on 5/15/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation
import VastClient

class VastExample {

    private var vastClient = VastClient()
    private var vastTracker: VastTracker?
    private var fakePlayheadProgressTimer: Timer?
    private var playhead = 123456.0

    init() {
        makeVastRequest()
    }

    private func makeVastRequest() {
        let urlStr = "http://29773.v.fwmrm.net/ad/g/1?flag=+sltp-slcb+qtcb+aeti+emcr&nw=169843&mode=live&prof=nbcsports_adobe_web&csid=nbcsports_nfl_snf_main_cam&sfid=7090576&afid=140315314&caid=nbcs_136401&vdur=600&resp=vast3&metr=7&pvrn=4980890867&vprn=5987497628;_fw_ae=&_fw_vcid2=169843:9cd22d95-7966-4a38-81f5-5de4c5;slid=mid1&tpos=0&slau=midroll&ptgt=a&tpcl=MIDROLL&maxd=120&cpsq=85&mind=120;"
        guard let url = URL(string: urlStr) else { return }
        do {
            let start = Date()
            let vastModel = try vastClient.parse(contentsOf: url)
            print("Took \(-1 * start.timeIntervalSinceNow) seconds to parse vast document")
            trackAd(vastModel)
        } catch VastError.invalidXMLDocument {
            print("Error: Invalid XML document")
        } catch VastError.invalidVASTDocument {
            print("Error: Invalid Vast Document")
        } catch VastError.unableToCreateXMLParser {
            print("Error: Unable to Create XML Parser")
        } catch VastError.unableToParseDocument {
            print("Error: Unable to Parse Vast Document")
        } catch {
            print("Error: unexpected error ...")
        }
    }

}

extension VastExample: VastTrackerDelegate {

    func trackAd(_ ad: VastModel) {
        let delay = 0.1
        vastTracker = VastTracker(id: "test", vastModel: ad, startTime: 123456.0, delegate: self)

        guard let tracker = vastTracker else { return }
        fakePlayheadProgressTimer = setInterval(delay) { [weak self] _ in
            guard var playhead = self?.playhead else { return }
            playhead += delay
            self?.playhead = playhead
            do {
                try tracker.updateProgress(time: playhead)
            } catch TrackingError.UnableToUpdateProgress {
                print("Tracking Error > Unable to update progress")
            } catch {
                print("Tracking Error > unknown")
            }
        }
    }

    func adBreakStart(_ id: String, _ vastModel: VastModel) {
        print("Ad Break Started > Playhead: \(playhead), Number of Ads: \(vastModel.ads.count), Duration: \(vastModel.ads.reduce(0, { acc, cur in return acc + (cur.linearCreatives.first?.duration ?? 0)}))")
    }

    func adStart(_ id: String, _ ad: VastAd) {
        print("Ad Started > Playhead: \(playhead), Id: \(ad.id), Sequence Number: \(ad.sequence), Duration: \(ad.linearCreatives.first?.duration ?? -1)")
    }

    func adFirstQuatile(_ id: String, _ ad: VastAd) {
        print("Ad First Quartile > Playhead: \(playhead), Id: \(ad.id)")
    }

    func adMidpoint(_ id: String, _ ad: VastAd) {
        print("Ad Midpoint > Playhead: \(playhead), Id: \(ad.id)")
    }

    func adThirdQuartile(_ id: String, _ ad: VastAd) {
        print("Ad Third Quartile > Playhead: \(playhead), Id: \(ad.id)")
    }

    func adComplete(_ id: String, _ ad: VastAd) {
        print("Ad Complete > Playhead: \(playhead), Id: \(ad.id)")
    }

    func adBreakComplete(_ id: String, _ vastModel: VastModel) {
        print("Ad Break Complete > Playhead: \(playhead), Number of Ads: \(vastModel.ads.count)")
        fakePlayheadProgressTimer?.invalidate()
        fakePlayheadProgressTimer = nil
    }

} 