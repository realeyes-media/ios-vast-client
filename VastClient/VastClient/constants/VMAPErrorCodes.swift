//
//  VMAPErrorCodes.swift
//  VastClient
//
//  Created by John Gainfort Jr on 8/8/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public enum VMAPErrorCodes: Int {
    case undefined = 900
    case vmapSchemaError = 1000
    case vmapResponesVersionNotSupported = 1001
    case vmapParsingError = 1002
    case adBreakTypeNotSupported = 1003
    case generalAdResponseDocumentError = 1004
    case adResponseTemplateTypeNotSupported = 1005
    case adResponseDocumentExtractionOrParsingError = 1006
    case adResponseDocumentRetrievalTimeout = 1007
    case adResponseDocumentRetrievalError = 1008
}
