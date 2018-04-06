//
//  ViewController.swift
//  VastClientWrapper
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import UIKit
import VastClient

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let vastClient = VastClient()
        let urlStr = "http://29773.v.fwmrm.net/ad/g/1?flag=+sltp-slcb+qtcb+aeti+emcr&nw=169843&mode=live&prof=nbcsports_adobe_web&csid=nbcsports_nfl_snf_main_cam&sfid=7090576&afid=140315314&caid=nbcs_136401&vdur=600&resp=vast3&metr=7&pvrn=4980890867&vprn=5987497628;_fw_ae=&_fw_vcid2=169843:9cd22d95-7966-4a38-81f5-5de4c5;slid=mid1&tpos=0&slau=midroll&ptgt=a&tpcl=MIDROLL&maxd=120&cpsq=85&mind=120;"
        guard let url = URL(string: urlStr) else { return }
        do {
            let start = Date()
            let vastModel = try vastClient.parse(contentsOf: url)
            print("Took \(-1 * start.timeIntervalSinceNow) seconds to parse vast document")
            print("vastModel: ", vastModel)
        } catch VastErrors.invalidXMLDocument {
            print("Error: Invalid XML document")
        } catch VastErrors.invalidVASTDocument {
            print("Error: Invalid Vast Document")
        } catch VastErrors.unableToCreateXMLParser {
            print("Error: Unable to Create XML Parser")
        } catch VastErrors.unableToParseDocument {
            print("Error: Unable to Parse Vast Document")
        } catch {
            print("Error: unexpected error ...")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

