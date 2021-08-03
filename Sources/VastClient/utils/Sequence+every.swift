//
//  Sequence+every.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

extension Sequence {

    // https://stackoverflow.com/a/37933006
    func every(predicate: (Iterator.Element) -> Bool) -> Bool {
        return first(where: { !predicate($0) }) == nil
    }

}
