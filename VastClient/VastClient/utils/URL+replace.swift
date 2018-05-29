//
//  URL+replace.swift
//  VastClient
//
//  Created by John Gainfort Jr on 5/29/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

extension URL {

    func withErrorCode(_ code: VastErrorCodes) -> URL {
        return URL(string: self.absoluteString.decoded.replacingOccurrences(of: "[ERRORCODE]", with: "\(code.rawValue)").encoded) ?? self
    }

}
