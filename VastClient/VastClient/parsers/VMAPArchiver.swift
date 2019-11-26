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
    private let saveURLKey = "VASTClient.lastSavedURL"
    private var lastSavedURL: URL? {
        return UserDefaults.standard.url(forKey: saveURLKey)
    }

    // MARK: - Methods
    func doesHaveSavedVMAP(for url: URL) -> Bool {
        return lastSavedURL == url
    }
}

// MARK: - Methods relevant to saving VMAP Model
extension VMAPArchiver {
    func save(vmapModel: VMAPModel, for url: URL) {
        if let jsonData = try? JSONEncoder().encode(vmapModel), let vmapModelLocalURL = vmapModelLocalURL {
            do {
                try jsonData.write(to: vmapModelLocalURL)
                UserDefaults.standard.set(url, forKey: saveURLKey)
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
}

// MARK: - Methods relevant to loading VMAP Model
extension VMAPArchiver {
    func loadSavedVMAP(for url: URL) throws -> VMAPModel {
        guard doesHaveSavedVMAP(for: url) else {
            throw VMAPArchiverError.noSavedVMAPAvailable }
        do {
            guard let vmapModelLocalURL = vmapModelLocalURL else {
                throw VMAPArchiverError.invalidURL }
            let data = try Data(contentsOf: vmapModelLocalURL)
            let vmapModel = try JSONDecoder().decode(VMAPModel.self, from: data)
            return vmapModel
        } catch {
            throw error
        }
    }

    enum VMAPArchiverError: Error {
        case noSavedVMAPAvailable
        case invalidURL
    }
}
