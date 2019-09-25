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
    private let saveDateKey = "VASTClient.timeSince1970"
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

// Simpler way of saving VMAPModel?
extension VMAPArchiver {
    func save(vmapModel: VMAPModel) {
        print("\nJoe:")
        print("Joe: Here's where I should save the VMAP Model")
        print("Joe: \(vmapModel.version)")
        print("Joe: \(vmapModel.adBreaks)")
        print("Joe:\n")
    }
}

// Methods Relevant to Loading
extension VMAPArchiver {
    func loadSavedVMAP() throws -> VMAPModel {
        print("Joe: - Here's where I'd return a saved VMAP... if I had one")
        throw VMAPArchiverError.vmapArchiverIsCurrentlyShitty
    }
}

enum VMAPArchiverError: Error {
    case vmapArchiverIsCurrentlyShitty
}
