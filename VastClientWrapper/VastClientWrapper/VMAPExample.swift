//
//  VMAPExample.swift
//  VastClientWrapper
//
//  Created by John Gainfort Jr on 8/8/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation
import VastClient

let fw_vmap = "http://29773.v.fwmrm.net/ad/g/1?flag=+amcb+fbad+vicb+slcb+sltp+amsl+emcr-play-uapl&nw=169843&mode=on-demand&asnw=169843&ssnw=169843&prof=169843:nbcu_dualplayer_ios&csid=nbcsports_golf_live&sfid=7090576&afid=35437277&caid=nbcs_142334_vod&vdur=1997.0&resp=vmap1&metr=1031&pvrn=3670333477107723572&vprn=4599041730011751642&ltlg=111,222&vclr=nbcsn1-1.0.0-r0000;_fw_ae=&_fw_vcid2=169843:26026DA7-3BCC-4C70-8877-A06BECEA7ACA;slid=midroll_3&slau=midroll&tpos=850.319999999997&cpsq=3&ptgt=a&mind=150.0&maxd=150.0;slid=midroll_2&slau=midroll&tpos=374.444&cpsq=2&ptgt=a&mind=135.0&maxd=135.0;slid=midroll_4&slau=midroll&tpos=1384.787&cpsq=4&ptgt=a&mind=135.0&maxd=135.0;slid=midroll_5&slau=midroll&tpos=1835.97200000001&cpsq=5&ptgt=a&mind=60.0&maxd=60.0;"

class VMAPExample {

    private var vastClient = VastClient()

    init() {
        makeVMAPRequest()
    }

    private func makeVMAPRequest() {
        let urlStr = fw_vmap
        guard let url = URL(string: urlStr) else { return }
        do {
            let start = Date()
            let vmapModel = try vastClient.parseVMAP(withContentsOf: url)
            print("Took \(-1 * start.timeIntervalSinceNow) seconds to parse vmap document")
            print(vmapModel)
        } catch VMAPError.invalidXMLDocument {
            print("Error: InvalidXMLDocument")
        } catch VMAPError.invalidVMAPDocument {
            print("Error: Invalid VMAP Document")
        } catch VMAPError.unableToCreateXMLParser {
            print("Error: Unabled to Create XML Parser")
        } catch VMAPError.unableToParseDocument {
            print("Error: Unabled to Parse VMAP Document")
        } catch {
            print("Error: unexpected error ...")
        }
    }
    
}
