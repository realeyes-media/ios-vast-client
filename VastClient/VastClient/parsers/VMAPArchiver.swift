//
//  VMAPArchiver.swift
//  VastClient
//
//  Created by Joe Lucero on 8/23/19.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.
//

import Foundation

class VMAPArchiver {
    // Use UserDefaults to store the time of last save.
    // This will prevent us from having to store this information in a much
    // larger file with all of the data associated with VMAP
    private let saveDateKey = "VASTClientTimeSince1970"
    private var lastSaveDate: Date? {
        let time = UserDefaults.standard.double(forKey: saveDateKey)
        if time <= 0 { return nil }
        return Date(timeIntervalSince1970: time)
    }
    private let amountOfTimeVMAPIsValidFor: TimeInterval = 5*60
    private var errorOccuredWhileParsing = false
    var shouldUseSavedVMAP: Bool {
        print("\nJoe:")
        print("Joe: lastSaveDate: \(lastSaveDate)")
        print("Joe:\n")

        guard let lastSaveDate = lastSaveDate else { return false }
        print("\nJoe:")
        print("Joe: dateSinceLastSave: \(Date().timeIntervalSince(lastSaveDate))")
        print("Joe:\n")

        return abs(Date().timeIntervalSince(lastSaveDate)) < amountOfTimeVMAPIsValidFor
    }

    var arrayOfJoesStuff = [(String, [String:String])]()

}

// Methods Relevant to Saving
extension VMAPArchiver {
    func parserDidStartDocument() {
        print("Joe: - parser about to start")
        errorOccuredWhileParsing = false
        arrayOfJoesStuff = []
    }

    func parserStartedNewElement(elementName: String, attributes attributeDict: [String : String]) {
//        guard !attributeDict.isEmpty else { return }
        arrayOfJoesStuff.append((elementName, attributeDict))
        print("Joe: - startedElement \(elementName). \(attributeDict)")
    }

    func parserFoundCharacters(string: String) {
        print("Joe: - foundCharacters \(string)")
    }


    func parserEndedElement(elementName: String) {
        print("Joe: - endedElement \(elementName)")
    }

    func parserDidEndDocument() {
        guard !errorOccuredWhileParsing else { return } // this is just a sanity check. you should never enter this block.
        print("Joe: - parser finished")
        print("Joe: - should save this: \(arrayOfJoesStuff)")
        arrayOfJoesStuff = []
    }

    func parserErrorOccurred() {
        errorOccuredWhileParsing = true
        print("Joe: - error occurred while saving, don't do anything here")
        arrayOfJoesStuff = []
    }

}

// Methods Relevant to Loading
extension VMAPArchiver {

}
