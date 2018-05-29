//
//  String+encode.swift
//  VastClient
//
//  Created by John Gainfort Jr on 5/29/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

extension String {

    var encoded: String {
        get {
            return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
        }
    }

    var decoded: String {
        get {
            return self.removingPercentEncoding ?? self
        }
    }

}
