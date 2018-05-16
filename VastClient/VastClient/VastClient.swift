//
//  VastClient.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public class VastClient {

    public init() {}

    public func parse(contentsOf url: URL) throws -> VastModel {
        let parser = VastParser()
        return try parser.parse(url: url)
    }

}
