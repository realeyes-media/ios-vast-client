//
//  VastXMLParserPubadsWrapperTests.swift
//  VastClientTests
//
//  Created by Jan Bednar on 20/11/2018.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

@testable import VastClient
import XCTest

class VastXMLParserPubadsWrapperTests: XCTestCase {
    var client: VastClient!
    private lazy var bundle = Bundle(for: type(of: self))
    
    override func setUp() {
        super.setUp()
        client = VastClient(options: VastClientOptions(wrapperLimit: 2))
    }
    
    func test_parse_wrapper_from_XML_success() {
        let model = loadVastFile(named: "Pubads_Wrapper_Model-test")
        let testModel = VastModel.pubadsWrapperModel
        XCTAssertEqual(model, testModel)
    }
    
    func test_parse_inline_from_XML_success() {
        let model = loadVastFile(named: "Pubads_Inline_Model-test")
        let testModel = VastModel.pubadsInlineModel
        XCTAssertEqual(model, testModel)
    }
    
    func test_parse_response_success() {
        let url = URL(string: "test://Pubads_Wrapper_Model-test")!
        let expect = expectation(description: "model")
        var model: VastModel?
        
        client.parseVast(withContentsOf: url, testBundle: bundle) { vastModel, _ in
            model = vastModel
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: { _ in
            XCTAssertTrue(model != nil)
            XCTAssertEqual(model, VastModel.pubadsModel)
        })
    }
    
    func test_parse_remote_response_success() {
        let url = URL(string: "https://pubads.g.doubleclick.net/gampad/ads?slotname=/9233/npoplayer.nl/pauw&sz=720x404&cust_params=genre%3Dinformatief%26dur%3D3392%26prid%3DBV_101388618%26srid%3DVARA_101377247%26net%3D%26player%3Dweb%26device%3Ddesktop%26os%3Dwindows%26osversion%3D10%26playername%3Dnpo-app-desktop%26playerversion%3D5.20.0%26omroep%3Dbnnvara%26programma%3Dpauw%26ncc%3D%24%24ncc%24%24%26stationid%3Dnpo%26afleveringstitel%3Dpauw%26subgenre%3Dnieuws%2Factualiteiten%26abtest%3DA2%26site%3Dnpostart%26interessechannels%3D&url=https://www.npostart.nl/pauw/15-10-2018/BV_101388618%3Fttype%3Dchoice%26tevent%3D%257B%2522spvid%2522%253A%25220%253AZNIXpyFzDnLAWOOSrVawDvIiB7y3LWAu%2522%252C%2522comScoreName%2522%253A%2522npo.home.index%2522%252C%2522brand%2522%253A%2522npoportal%2522%252C%2522section%2522%253A%2522home%2522%252C%2522broadcaster%2522%253A%2522npo%2522%252C%2522subBroadcaster%2522%253A%2522npo%2522%252C%2522brandType%2522%253A%2522zenderportal%2522%252C%2522platform%2522%253A%2522site%2522%252C%2522platformType%2522%253A%2522site%2522%252C%2522avType%2522%253A%2522video%2522%252C%2522panel%2522%253A%2522home.regular.1%2522%252C%2522type%2522%253A%2522editorial%2522%252C%2522offerId%2522%253A%2522749540cd-0f0f-4817-bc95-db37bf3a5cc9%2522%252C%2522destination%2522%253A%257B%2522contentId%2522%253A%2522BV_101388618%2522%252C%2522index%2522%253A1%252C%2522numberDisplayed%2522%253A10%252C%2522recommender%2522%253A%2522meest-bekeken%2522%257D%252C%2522sourceContentId%2522%253A%2522no_source_available%2522%257D&unviewed_position_start=1&impl=s&env=vp&gdfp_req=1&ad_rule=0&output=xml_vast4&video_url_to_fetch=%5Breferrer_url%5D&vad_type=linear&vpos=preroll&pod=1&vrid=1334&pmnd=0&pmxd=30000&pmad=2&is_amp=0&adk=421971784&correlator=461400697701781&scor=2627431874535605&pucrd=CgwIARAAGAAgACgAOAF4Aw&ged=ve4_td2_er0.0.152.300_vi0.0.392.696_vp100_eb24424&osd=2&jar=2018-10-17-14&hl=nl&frm=2&sdkv=h.3.244.2&sdki=44d&mpt=videojs-ima&mpv=0.2.0&sdr=1&u_so=l&afvsz=450x50,468x60,480x70&kfa=0&tfcd=0")!
        let expect = expectation(description: "model")
        var model: VastModel?
        
        client.parseVast(withContentsOf: url) { vastModel, _ in
            model = vastModel
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: { _ in
            XCTAssertTrue(model != nil)
        })
    }
    
    private func loadVastFile(named filename: String) -> VastModel {
        let parser = VastXMLParser()
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: filename, ofType: "xml")!
        let url = URL(fileURLWithPath: filepath)
        let model = try! parser.parse(url: url)
        return model
    }
}
