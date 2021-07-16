//
//  VMAPError.swift
//  VastClient
//
//  Created by John Gainfort Jr on 8/8/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public enum VMAPError: Error {
    case invalidXMLDocument
    case invalidVMAPDocument
    case unableToParseDocument
    case unableToCreateXMLParser
    case internalError
}
