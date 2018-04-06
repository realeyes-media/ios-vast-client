//
//  VastClient.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

public class VastClient {

    private let vastParser = VastParser()

    public init() {}

    public func parse(contentsOf url: URL) throws -> VastModel {
        // TODO: the catch and throw seems repetitive
//        do {
            return try vastParser.parse(url: url)
//        } catch VastErrors.unableToCreateXMLParser {
//            throw VastErrors.unableToCreateXMLParser
//        } catch VastErrors.unableToParseDocument {
//            throw VastErrors.unableToParseDocument
//        } catch VastErrors.invalidVASTDocument {
//            throw VastErrors.invalidVASTDocument
//        } catch VastErrors.invalidXMLDocument {
//            throw VastErrors.invalidXMLDocument
//        } catch VastErrors.internalError {
//            throw VastErrors.internalError
//        }
    }

}
