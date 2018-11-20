//
//  VastMacros.swift
//  VastClient
//
//  Created by John Gainfort Jr on 6/5/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

enum VatMacros: String {
    case errorcode = "[ERRORCODE]"
    case contentplayhead = "[CONTENTPLAYHEAD]" //current time offset “HH:MM:SS.mmm” of the video content
    case cachebusting = "[CACHEBUSTING]" //replaced with a random 8-digit number.
    case asseturi = "[ASSETURI]"
    case timestamp = "[TIMESTAMP]" //date and time at which the URI using this macro is accessed using ISO 8601 with miliseconds: January 17, 2016 at 8:15:07 and 127 milleseconds, Eastern Time would be formatted as follows: 2016-01-17T8:15:07.127-05
}
