//
//  VMAPArchiver.swift
//  VastClient
//
//  Created by Joe Lucero on 8/23/19.
//  Copyright © 2019 John Gainfort Jr. All rights reserved.
//

import Foundation

class VMAPArchiver {
    // MARK: - Private Variables
    private let saveDateKey = "VASTClient.timeSince1970"
    private let saveURLKey = "VASTClient.lastSavedURL"
    private var lastSavedDate: Date? {
        let time = UserDefaults.standard.double(forKey: saveDateKey)
        if time <= 0 { return nil }
        return Date(timeIntervalSince1970: time)
    }
    private var lastSavedURL: URL? {
        return UserDefaults.standard.url(forKey: saveURLKey)
    }
    private let amountOfTimeVMAPIsValidFor: TimeInterval = 5*60
    private var errorOccuredWhileParsing = false

    // MARK: - Methods
    func shouldUseSavedVMAP(url: URL) -> Bool {
        guard let lastSavedURL = lastSavedURL, lastSavedURL == url, let lastSavedDate = lastSavedDate else { return false }
        return abs(Date().timeIntervalSince(lastSavedDate)) < amountOfTimeVMAPIsValidFor
    }
}

// MARK: - Methods relevant to saving VMAP Model
extension VMAPArchiver {
    func save(vmapModel: VMAPModel, for url: URL) {
        if let jsonData = try? JSONEncoder().encode(vmapModel), let vmapModelLocalURL = vmapModelLocalURL {
            do {
                try jsonData.write(to: vmapModelLocalURL)
                updateLastSaveDate(for: url)
            } catch {
                print("Unable to save VMAPModel")
            }
        }
    }

    private var vmapModelLocalURL: URL? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fullPath =  path.appendingPathComponent("VMAPModel.json")
        return fullPath
    }

    private func updateLastSaveDate(for url: URL) {
        let timeSince1970 = Date().timeIntervalSince1970
        UserDefaults.standard.set(timeSince1970, forKey: saveDateKey)
        UserDefaults.standard.set(url, forKey: saveURLKey)
    }
}

// MARK: - Methods relevant to loading VMAP Model
extension VMAPArchiver {
    func loadSavedVMAP(for url: URL) throws -> VMAPModel {
        guard shouldUseSavedVMAP(url: url) else { throw VMAPArchiverError.dataTimedOut }
        do {
            guard let vmapModelLocalURL = vmapModelLocalURL else { throw VMAPArchiverError.invalidURL }
            let data = try Data(contentsOf: vmapModelLocalURL)
            let vmapModel = try JSONDecoder().decode(VMAPModel.self, from: data)
            return vmapModel
        } catch {
            throw error
        }
    }

    enum VMAPArchiverError: Error {
        case dataTimedOut
        case invalidURL
    }
}
