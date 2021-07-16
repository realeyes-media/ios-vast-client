//
//  Tracking.swift
//  VastClient
//
//  Created by John Gainfort Jr on 5/15/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

func track(url: URL, eventName: String? = nil) {
    track(urls: [url], eventName: eventName)
}

func track(urls: [URL], eventName: String? = nil) {
    urls.forEach{ makeRequest(withUrl: $0) }
    if let eventName = eventName {
        VastClient.trackingLogOutput?(eventName, urls)
    } else {
        VastClient.trackingLogOutput?("UNKNOWN", urls)
    }
}

private func makeRequest(withUrl url: URL) {
    let request = URLRequest(url: url)
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)

    let task = session.dataTask(with: request) {(data, response, error) in
        #if DEBUG
        DispatchQueue.global().async {
            if let error = error {
                print("Request \(request.debugDescription), finished with error: \(error)")
                return
            }
            print("Completed request: \(request.debugDescription)")
        }
        #endif
    }

    task.resume()
}
