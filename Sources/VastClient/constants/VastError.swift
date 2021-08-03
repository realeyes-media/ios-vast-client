//
//  VastError.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public enum VastError: Error {
    case invalidXMLDocument
    case invalidVASTDocument
    case unableToParseDocument
    case unableToCreateXMLParser
    case wrapperLimitReached
    case singleRequestTimeLimitReached
    case wrapperTimeLimitReached
    case internalError
}
