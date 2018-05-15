//
//  timer.swift
//  VastClientWrapper
//
//  Created by John Gainfort Jr on 5/15/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

func setInterval(_ delay: TimeInterval, block: @escaping (Timer) -> Void) -> Timer {
    return Timer.scheduledTimer(withTimeInterval: delay, repeats: true, block: block)
}

func setTimeout(_ delay: TimeInterval, block: @escaping (Timer) -> Void) -> Timer {
    return Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: block)
}
