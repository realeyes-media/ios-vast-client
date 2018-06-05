//
//  VastClient.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public struct VastClientOptions {
    public var wrapperLimit: Int
}

extension VastClientOptions {
    public init() {
        self.wrapperLimit = 5
    }
}

public class VastClient {

    private let options: VastClientOptions

    public init(options: VastClientOptions = VastClientOptions()) {
        self.options = options
    }

    public func parse(contentsOf url: URL) throws -> VastModel {
        let parser = VastParser(options: options)
        return try parser.parse(url: url)
    }

}
