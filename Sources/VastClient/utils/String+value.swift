//
//  String+boolValue.swift
//  Nimble
//
//  Created by Jan Bednar on 07/11/2018.
//

import Foundation

extension String {
    var boolValue: Bool? {
        switch self.lowercased() {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    var intValue: Int? {
        return Int(self)
    }
    
    var doubleValue: Double? {
        return Double(self)
    }
}
