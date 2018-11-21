//
//  VastXMLParserPubadsWrapperTests.swift
//  VastClientTests
//
//  Created by Jan Bednar on 20/11/2018.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import XCTest
@testable import VastClient

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
        let model = try? client.parseVast(withContentsOf: url, testBundle: bundle)
        XCTAssertTrue(model != nil)
        XCTAssertEqual(model, VastModel.pubadsModel)
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
