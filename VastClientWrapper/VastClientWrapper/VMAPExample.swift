//
//  VMAPExample.swift
//  VastClientWrapper
//
//  Created by John Gainfort Jr on 8/8/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation
import VastClient

let fw_vmap = "http://29773.v.fwmrm.net/ad/g/1?nw=169843&mode=vod&resp=vmap1&prof=169843:nbcu_playmaker_tvos&csid=nbcsports_ctv_live_appletv&caid=nbcs_149984_vod&asnw=169843&ssnw=169843&vdur=-1&pvrn=955393070743561485&vprn=742593890088388868&flag=+qtcb-fbad+vicb+slcb+sltp+amsl-emcr-play-uapl&metr=1031&afid=140315314&sfid=7089953&vip=65.153.144.238&vclr=1.0.9;_fw_h_user_agent=NBCU/1.0%20(Apple%20TV)&_fw_ae=725bd42fc9c9394e790b9a73610da431&_fw_vcid2=169843:DF0A168D-511B-4FC3-9BE2-358E48013B68&ltlg=39.7393,-104.9844&_fw_player_width=1920&_fw_player_height=1130;slid=mid23&slau=midroll&tpos=9111.63900000008&ptgt=a&maxd=135.0&mind=135.0&cpsq=23;slid=mid25&slau=midroll&tpos=9887.314000000002&ptgt=a&maxd=135.0&mind=135.0&cpsq=25;slid=pre&slau=preroll&tpos=0&ptgt=a;slid=mid14&slau=midroll&tpos=4998.630000000007&ptgt=a&maxd=150.0&mind=150.0&cpsq=14;slid=mid24&slau=midroll&tpos=9499.961000000041&ptgt=a&maxd=135.0&mind=135.0&cpsq=24;slid=mid9&slau=midroll&tpos=3804.6049999999696&ptgt=a&maxd=120.0&mind=120.0&cpsq=9;slid=mid17&slau=midroll&tpos=6344.275000000075&ptgt=a&maxd=90.0&mind=90.0&cpsq=17;slid=mid3&slau=midroll&tpos=1239.1049999999996&ptgt=a&maxd=135.0&mind=135.0&cpsq=3;slid=mid18&slau=midroll&tpos=6995.559000000109&ptgt=a&maxd=135.0&mind=135.0&cpsq=18;slid=mid8&slau=midroll&tpos=3398.1989999999787&ptgt=a&maxd=120.0&mind=120.0&cpsq=8;slid=mid12&slau=midroll&tpos=4566.631999999987&ptgt=a&maxd=60.0&mind=60.0&cpsq=12;slid=mid22&slau=midroll&tpos=8673.86800000012&ptgt=a&maxd=90.0&mind=90.0&cpsq=22;slid=mid2&slau=midroll&tpos=353.2529999999996&ptgt=a&maxd=90.0&mind=90.0&cpsq=2;slid=mid21&slau=midroll&tpos=7983.077000000159&ptgt=a&maxd=120.0&mind=120.0&cpsq=21;slid=mid5&slau=midroll&tpos=2081.3810000000094&ptgt=a&maxd=90.0&mind=90.0&cpsq=5;slid=mid19&slau=midroll&tpos=7470.5660000001335&ptgt=a&maxd=135.0&mind=135.0&cpsq=19;slid=mid4&slau=midroll&tpos=1714.9480000000058&ptgt=a&maxd=135.0&mind=135.0&cpsq=4;slid=mid6&slau=midroll&tpos=2384.0840000000026&ptgt=a&maxd=135.0&mind=135.0&cpsq=6;slid=mid26&slau=midroll&tpos=11846.972999999809&ptgt=a&maxd=110.0&mind=110.0&cpsq=26;slid=mid16&slau=midroll&tpos=5703.634000000043&ptgt=a&maxd=90.0&mind=90.0&cpsq=16;slid=mid7&slau=midroll&tpos=2746.980999999994&ptgt=a&maxd=135.0&mind=135.0&cpsq=7;slid=mid11&slau=midroll&tpos=4334.199999999975&ptgt=a&maxd=30.0&mind=30.0&cpsq=11;slid=mid20&slau=midroll&tpos=7652.681000000142&ptgt=a&maxd=135.0&mind=135.0&cpsq=20;slid=mid15&slau=midroll&tpos=5387.4520000000275&ptgt=a&maxd=120.0&mind=120.0&cpsq=15;slid=mid10&slau=midroll&tpos=4156.789999999965&ptgt=a&maxd=30.0&mind=30.0&cpsq=10;slid=mid13&slau=midroll&tpos=4666.264999999991&ptgt=a&maxd=90.0&mind=90.0&cpsq=13"

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
