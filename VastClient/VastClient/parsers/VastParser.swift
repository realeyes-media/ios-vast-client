//
//  VastParser.swift
//  VastClient
//
//  Created by Jan Bednar on 19/11/2018.
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
    
    init(options: VastClientOptions) {
        self.options = options
    }
    
    func parse(url: URL, count: Int = 0) throws -> VastModel {
        guard count < options.wrapperLimit else {
            throw VastError.wrapperLimitReached
        }
        let parser = VastXMLParser()
        var vm = try parser.parse(url: url)
        
        let flattenedVastAds = unwrap(vm: vm, count: count)
        vm.ads = flattenedVastAds
        return vm
    }
    
    func unwrap(vm: VastModel, count: Int) -> [VastAd] {
        return vm.ads.map { ad -> VastAd in
            var copiedAd = ad
            
            guard ad.type == .wrapper, let wrapperUrl = ad.wrapper?.adTagUri else { return ad }
            
            do {
                let wrapperModel = try parse(url: wrapperUrl, count: count + 1)
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
                            let wrapperLinearCreative = wrapperAd.creatives[idx]
                            creative.linear?.duration = wrapperLinearCreative.linear?.duration
                            if let mediaFiles = wrapperLinearCreative.linear?.mediaFiles.mediaFiles {
                                creative.linear?.mediaFiles.mediaFiles.append(contentsOf: mediaFiles)
                            }
                            if let interactiveFiles = wrapperLinearCreative.linear?.mediaFiles.interactiveCreativeFile {
                                creative.linear?.mediaFiles.interactiveCreativeFile.append(contentsOf: interactiveFiles)
                            }
                            if let events = wrapperLinearCreative.linear?.trackingEvents {
                                creative.linear?.trackingEvents.append(contentsOf: events)
                            }
                        }
                        copiedCreatives[idx] = creative
                    }
                    
                    copiedAd.creatives = copiedCreatives
                    copiedAd.extensions.append(contentsOf: wrapperAd.extensions)
                    // TODO: uncomments and fix parsing for /CompanionAds
                    //                    copiedAd.companionAds.append(contentsOf: wrapperAd.companionAds)
                }
            } catch {
                print("Unable to unwrap wrapper")
            }
            return copiedAd
        }
    }
    
}
