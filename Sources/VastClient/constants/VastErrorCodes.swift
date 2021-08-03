//
//  VastErrorCodes.swift
//  VastClient
//
//  Created by John Gainfort Jr on 5/29/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public enum VastErrorCodes: Int {
    case xmlParsingError = 100
    case vastSchemaValidationError = 101
    case vastVersionOfResponseNotSupported = 102
    case traffickingError = 200
    case videoPlayerExpectingDifferentLinearity = 201
    case videoPlayerExpectingDifferentDuration = 202
    case videoPlayerExpectingDifferentSize = 203
    case adCategoryNotProvided = 204
    case generalWrapperError = 300
    case timeoutOfVastURI = 301
    case wrapperLimitReached = 302
    case noAdsVastResponse = 303
    case inlineResponseFailedToDisplayInTime = 304
    case generalLinearError = 400
    case fileNotFound = 401
    case timeoutOfMediaFile = 402
    case mediaFileNotSupported = 403
    case problemDisplayingMediaFile = 405
    case conditionalAdRejected = 408
    case interactiveUnitInNodeNotExecuted = 409
    case verificationUnitInNodeNotExecuted = 410
    case generalNonLinearAdsError = 500
    case creativeDimensionTooLarge = 501
    case unableToFetchResource = 502
    case nonLinearResourceNotSupported = 503
    case generalCompanionAdsError = 600
    case noAvailableSpace = 601
    case unableToDisplayCompanion = 602
    case unableToFetchCompanionResource = 603
    case companionResourceNotSupported = 604
    case undefinedError = 900
    case generalVPAIDError = 901
}
