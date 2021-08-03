//
//  VastAdVerificationParameters.swift
//  VastClient
//
//  Created by Austin Christensen on 7/11/19.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.
//

import Foundation

public struct VastAdVerificationParameters: Codable {
    public var data: String?
}

extension VastAdVerificationParameters: Equatable {
}
