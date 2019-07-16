//
//  String+seconds.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public extension String {

    // takes time format hh:mm:ss and converts to seconds
    var toSeconds: Double? {
        let arr = self.split(separator: ":").map { Double($0) ?? -1.0 }
        if arr.count != 3 && !arr.every(predicate: { $0 >= 0  }) {
            return nil
        }
        
        return arr.enumerated().reduce(0.0, { acc, cur in
            let acc = acc ?? 0.0
            let (idx, val) = cur
            var sec = 0.0
            if idx == 0 {
                sec += val * 3600
            } else if idx == 1 {
                sec += val * 60
            } else {
                sec += val
            }
            return acc + sec
        })
    }

}
