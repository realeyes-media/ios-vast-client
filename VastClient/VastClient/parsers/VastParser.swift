//
//  VastParser.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

/**
 Vast Parser
 
 Use this parser to receive final unwrapped VastModel.
 
 When wrapper VAST response is received it recursively fetches the file specified in VastAdTagURI element and flattens the responses
 */
class VastParser {
    
    let options: VastClientOptions
    
    // for testing of local files only
    private let testFileBundle: Bundle?
    private let queue: DispatchQueue
    
    init(options: VastClientOptions, queue: DispatchQueue = DispatchQueue.init(label: "parser", qos: .userInitiated), testFileBundle: Bundle? = nil) {
        self.options = options
        self.queue = queue
        self.testFileBundle = testFileBundle
    }
    
    private var completion: ((VastModel?, Error?) -> ())?
    
    private func finish(vastModel: VastModel?, error: Error?) {
        DispatchQueue.main.async {
            self.completion?(vastModel, error)
            self.completion = nil
        }
    }
    
    func parse(url: URL, completion: @escaping (VastModel?, Error?) -> ()) {
        self.completion = completion
        let timer = Timer.scheduledTimer(withTimeInterval: options.timeLimit, repeats: false) { [weak self] _ in
            self?.finish(vastModel: nil, error: VastError.wrapperTimeLimitReached)
        }
        queue.async {
            do {
                let vastModel = try self.internalParse(url: url)
                timer.invalidate()
                self.finish(vastModel: vastModel, error: nil)
            } catch {
                timer.invalidate()
                self.finish(vastModel: nil, error: error)
            }
        }
    }
    
    private func internalParse(url: URL, count: Int = 0) throws -> VastModel {
        guard count < options.wrapperLimit else {
            throw VastError.wrapperLimitReached
        }
        let parser = VastXMLParser()
        
        var vm: VastModel
        if url.scheme?.contains("test") ?? false, let bundle = testFileBundle {
            let filename = url.absoluteString.replacingOccurrences(of: "test://", with: "")
            let filepath = bundle.path(forResource: filename, ofType: "xml")!
            let url = URL(fileURLWithPath: filepath)
            vm = try internalParse(url: url)
        } else {
            vm = try parser.parse(url: url)
        }
        
        let flattenedVastAds = unwrap(vm: vm, count: count)
        vm.ads = flattenedVastAds
        return vm
    }
    
    func unwrap(vm: VastModel, count: Int) -> [VastAd] {
        return vm.ads.map { ad -> VastAd in
            var copiedAd = ad
            
            guard ad.type == .wrapper, let wrapperUrl = ad.wrapper?.adTagUri else { return ad }
            
            do {
                let wrapperModel = try internalParse(url: wrapperUrl, count: count + 1)
                wrapperModel.ads.forEach { wrapperAd in
                    if let adSystem = wrapperAd.adSystem {
                        copiedAd.adSystem = adSystem
                    }
                    
                    if let title = wrapperAd.adTitle, !title.isEmpty {
                        copiedAd.adTitle = title
                    }
                    
                    if !wrapperAd.errors.isEmpty {
                        copiedAd.errors = wrapperAd.errors
                    }
                    
                    if wrapperAd.type != AdType.unknown {
                        copiedAd.type = wrapperAd.type
                    }
                    
                    copiedAd.impressions.append(contentsOf: wrapperAd.impressions)
                    
                    var copiedCreatives = copiedAd.creatives
                    for (idx, creative) in copiedCreatives.enumerated() {
                        var creative = creative
                        if idx < wrapperAd.creatives.count {
                            let wrapperCreative = wrapperAd.creatives[idx]
                            
                            // Copy values from previous wrappers
                            if let linear = wrapperCreative.linear {
                                creative.linear?.duration = linear.duration
                                creative.linear?.files.mediaFiles.append(contentsOf: linear.files.mediaFiles)
                                creative.linear?.files.interactiveCreativeFiles.append(contentsOf: linear.files.interactiveCreativeFiles)
                                creative.linear?.trackingEvents.append(contentsOf: linear.trackingEvents)
                                creative.linear?.icons.append(contentsOf: linear.icons)
                                creative.linear?.videoClicks.append(contentsOf: linear.videoClicks)
                            }
                            
                            if let companionAds = wrapperCreative.companionAds {
                                if creative.companionAds == nil {
                                    creative.companionAds = companionAds
                                } else {
                                    creative.companionAds?.companions.append(contentsOf: companionAds.companions)
                                }
                            }
                        }
                        copiedCreatives[idx] = creative
                    }
                    
                    copiedAd.creatives = copiedCreatives
                    copiedAd.extensions.append(contentsOf: wrapperAd.extensions)
                }
            } catch {
                print("Unable to unwrap wrapper")
            }
            return copiedAd
        }
    }
    
}
