//
//  VastErrors.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public enum VastErrors: Error {
    case invalidXMLDocument
    case invalidVASTDocument
    case unableToParseDocument
    case unableToCreateXMLParser
    case internalError
}
