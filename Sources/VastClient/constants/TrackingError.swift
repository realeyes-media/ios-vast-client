//
//  TrackingError.swift
//  VastClient
//
//  Created by John Gainfort Jr on 5/14/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public enum TrackingError: Error {
    case MissingAdBreak
    case unableToUpdateProgressTrackingComplete
    case unableToUpdateProgress(msg: String)
    case unableToProvideCreativeClickThroughUrls
    case internalError(msg: String)
    case unableToSkipAdAtThisTime
    case noAdFound(withId: String)
}
