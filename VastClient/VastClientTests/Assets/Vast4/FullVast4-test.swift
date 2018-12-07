//
//  FullVast4-test.swift
//  VastClientTests
//
//  Created by Jan Bednar on 07/12/2018.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation
@testable import VastClient

extension VastModel {
    static let fullVast4: VastModel = {
        // TODO: fill in proper values from "TestFullVast4.xml" file
        VastModel(version: "4.0", ads: [], errors: [])
    }()
}
