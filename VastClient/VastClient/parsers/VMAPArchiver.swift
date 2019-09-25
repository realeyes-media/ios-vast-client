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
        if let jsonData = try? JSONEncoder().encode(vmapModel), let vmapModelLocalURL = vmapModelLocalURL {
            print("Joe: SAVING THE VMAP MODEL!")
            do {
                try jsonData.write(to: vmapModelLocalURL)
                updateLastSaveDate()
            } catch {
                print("Joe: error while saving to local URL")
            }
        } else {
            print("Joe: Can't save this VMAPModel")
        }
    }

    private var vmapModelLocalURL: URL? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fullPath =  path.appendingPathComponent("VMAPModel.json")
        print("\nJoe:")
        print("Joe: fullPath \(fullPath)")
        print("Joe:\n")
        return fullPath
    }

    private func updateLastSaveDate() {
        let timeSince1970 = Date().timeIntervalSince1970
        print("\nJoe:")
        print("Joe: UpdateLastSaveDate with \(timeSince1970)")
        print("Joe:\n")

        UserDefaults.standard.set(timeSince1970, forKey: saveDateKey)
    }
}

// Methods Relevant to Loading
extension VMAPArchiver {
    func loadSavedVMAP() throws -> VMAPModel {
        guard shouldUseSavedVMAP else { throw VMAPArchiverError.dataNoLongerValid }
        do {
            guard let url = vmapModelLocalURL else { throw VMAPArchiverError.invalidURL }
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(VMAPModel.self, from: data)
        } catch {
            throw error
        }
    }

    enum VMAPArchiverError: Error {
        case dataNoLongerValid
        case invalidURL
    }
}
