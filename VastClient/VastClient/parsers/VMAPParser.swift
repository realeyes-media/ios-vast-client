//
//  VMAPParser.swift
//  VastClient
//
//  Created by John Gainfort Jr on 8/8/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

class VMAPParser: NSObject {

    private let options: VastClientOptions
    private let vastParser: VastParser

    var xmlParser: XMLParser?
    var validVMAPDocument = false
    var parsedFirstElement = false
    var fatalError: Error?

    var vmapModel: VMAPModel?

    var adBreaks = [VMAPAdBreak]()
    var currentAdBreak: VMAPAdBreak?

    var trackingEvents = [VMAPTrackingEvent]()
    var currentTrackingEvent: VMAPTrackingEvent?

    var currentVMAPAdSource: VMAPAdSource?

    var currentVastModel: VastModel?

    var currentContent = ""

    init(options: VastClientOptions) {
        self.options = options
        self.vastParser = VastParser(options: options)
    }

    func parse(url: URL) throws -> VMAPModel {
        xmlParser = XMLParser(contentsOf: url)
        guard let parser = xmlParser else {
            throw VMAPError.unableToCreateXMLParser
        }

        parser.delegate = self

        if parser.parse() {
            if !validVMAPDocument {
                throw VMAPError.invalidVMAPDocument
            }

            if let _ = fatalError {
                throw VMAPError.invalidXMLDocument
            }
        } else {
            throw VMAPError.unableToParseDocument
        }

        guard var vm = vmapModel else {
            throw VMAPError.internalError
        }
        
        let flattenedAdBreaks = vm.adBreaks.map { [weak self] adBreak -> VMAPAdBreak in
            var copiedAdBreak = adBreak
            guard let adSource = adBreak.adSource, var vastAdData = adSource.vastAdData else { return adBreak }
            
            let flattenedVastAds = vastAdData.ads.map { [weak self] ad -> VastAd in
                var copiedAd = ad
                
                guard ad.type == .wrapper, let strongSelf = self, let url = ad.wrapperUrl else { return ad }
                let wrapperParser = VastParser(options: strongSelf.options)
                
                do {
                    let wrapperModel = try wrapperParser.parse(url: url, count: 0)
                    wrapperModel.ads.forEach { wrapperAd in
                        if let adSystem = wrapperAd.adSystem {
                            copiedAd.adSystem = adSystem
                        }
                        
                        if !wrapperAd.adTitle.isEmpty {
                            copiedAd.adTitle = wrapperAd.adTitle
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
                                if let events = wrapperLinearCreative.linear?.trackingEvents {
                                    creative.linear?.trackingEvents.append(contentsOf: events)
                                }
                            }
                            copiedCreatives[idx] = creative
                        }
                        
                        copiedAd.creatives = copiedCreatives
                        copiedAd.extensions.append(contentsOf: wrapperAd.extensions)
//                        copiedAd.companionAds.append(contentsOf: wrapperAd.companionAds)
                    }
                } catch {
                    print("Unable to parse wrapper")
                }
                
                return copiedAd
            }
            
            vastAdData.ads = flattenedVastAds
            
            copiedAdBreak.adSource?.vastAdData = vastAdData

            return copiedAdBreak
        }
        
        vm.adBreaks = flattenedAdBreaks
        
        return vm
    }

}

extension VMAPParser: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if !validVMAPDocument && !parsedFirstElement {
            parsedFirstElement = true
            if elementName == VMAPElements.vmap {
                validVMAPDocument = true
                vmapModel = VMAPModel(attrDict: attributeDict)
            }
        }

        if validVMAPDocument && fatalError == nil {
            switch elementName {
            case VMAPAdBreakElements.adbreak:
                currentAdBreak = VMAPAdBreak(attrDict: attributeDict)
            case VMAPTrackingEventElements.tracking:
                currentTrackingEvent = VMAPTrackingEvent(attrDict: attributeDict)
            case VMAPAdSourceElements.adSource:
                currentVMAPAdSource = VMAPAdSource(attrDict: attributeDict)
            case VMAPAdSourceElements.vastAdData:
                vastParser.completeClosure = { [weak self] error, vastModel in
                    self?.fatalError = error
                    self?.currentVastModel = vastModel
                    
                    parser.delegate = self
                }
                parser.delegate = vastParser
            default:
                break
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentContent += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentContent = currentContent.trimmingCharacters(in: .whitespacesAndNewlines)

        if validVMAPDocument && fatalError == nil {
            switch elementName {
            case VMAPElements.vmap:
                vmapModel?.adBreaks = adBreaks
            case VMAPAdBreakElements.adbreak:
                if let adBreak = currentAdBreak {
                    adBreaks.append(adBreak)
                    currentAdBreak = nil
                }
            case VMAPTrackingEventElements.tracking:
                currentTrackingEvent?.url = URL(string: currentContent)
                if let event = currentTrackingEvent {
                    trackingEvents.append(event)
                    currentTrackingEvent = nil
                }
            case VMAPTrackingEventElements.trackingEvents:
                currentAdBreak?.trackingEvents = trackingEvents
                trackingEvents = [VMAPTrackingEvent]()
            case VMAPAdSourceElements.adSource:
                if let adSource = currentVMAPAdSource {
                    currentAdBreak?.adSource = adSource
                    currentVMAPAdSource = nil
                }
            case VMAPAdSourceElements.vastAdData:
                if let vastModel = currentVastModel {
                    currentVMAPAdSource?.vastAdData = vastModel
                    currentVastModel = nil
                }
            default:
                break
            }
        }

        currentContent = ""
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        fatalError = parseError
    }

}
