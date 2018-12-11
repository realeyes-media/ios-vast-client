//
//  http.swift
//  VastClient
//
//  Created by John Gainfort Jr on 5/15/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

func makeRequest(withUrl url: URL) {
    let request = URLRequest(url: url)
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)

    let task = session.dataTask(with: request) {(data, response, error) in
        #if DEBUG
        NSLog("Completed request: \(request.debugDescription)")
        if let error = error {
            NSLog("Request \(request.debugDescription), finished with error: \(error)")
            return
        }
        #endif
    }

    task.resume()
}
