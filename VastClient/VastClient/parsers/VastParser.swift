//
//  VastParser.swift
//  VastClient
//
//  Created by John Gainfort Jr on 4/6/18.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation

class VastParser: NSObject {

    private let options: VastClientOptions
    private var wrapperCount = 0

    // allows other xml parsing delegates to use this class's delegate to parse a VastModel out of a much larger XML document
    var completeClosure: ((_ error: Error?, _ vastModel: VastModel) -> Void)?

    var xmlParser: XMLParser?
    var validVastDocument = false
    var parsedFirstElement = false
    var fatalError: Error?

    var vastModel: VastModel?

    var vastAds = [VastAd]()
    var currentVastAd: VastAd?

    var vastImpression = [VastImpression]()
    var currentVastImpression: VastImpression?

    var vastLinearCreatives = [VastLinearCreative]()
    var currentLinearCreative: VastLinearCreative?

    var vastTrackingEvents = [VastTrackingEvent]()
    var currentTrackingEvent: VastTrackingEvent?

    var vastVideoClicks = [VastVideoClick]()
    var currentVideoClick: VastVideoClick?

    var vastMediaFiles = [VastMediaFile]()
    var currentMediaFile: VastMediaFile?

    var vastExtensions = [VastExtension]()
    var currentVastExtension: VastExtension?

    var creativeParameters = [VastCreativeParameter]()
    var currentCreativeParameter: VastCreativeParameter?

    var currentCompanionAds: VastCompanionAds?
    var companions = [VastCompanionCreative]()
    var currentCompanionCreative: VastCompanionCreative?

    var currentContent = ""

    init(options: VastClientOptions) {
        self.options = options
    }

    func parse(url: URL, count: Int = 0) throws -> VastModel {
        self.wrapperCount = count

        guard count < options.wrapperLimit else {
            throw VastError.wrapperLimitReached
        }

        xmlParser = XMLParser(contentsOf: url)
        guard let parser = xmlParser else {
            throw VastError.unableToCreateXMLParser
        }

        parser.delegate = self

        if parser.parse() {
            if !validVastDocument {
                throw VastError.invalidVASTDocument
            }

            if fatalError != nil {
                throw VastError.invalidXMLDocument
            }
        } else {
            throw VastError.unableToParseDocument
        }

        guard var vm = vastModel else {
            throw VastError.internalError
        }

        if let err = vm.error, vm.ads.count == 0 {
            makeRequest(withUrl: err.withErrorCode(VastErrorCodes.noAdsVastResponse))
        }

        let flattenedVastAds = vm.ads.map { [weak self] ad -> VastAd in
            var copiedAd = ad

            guard ad.type == .wrapper, let strongSelf = self, let url = ad.wrapperUrl else { return ad }
            let wrapperParser = VastParser(options: strongSelf.options)

            do {
                let wrapperModel = try wrapperParser.parse(url: url, count: strongSelf.wrapperCount + 1)
                wrapperModel.ads.forEach { wrapperAd in
                    if !wrapperAd.adSystem.isEmpty {
                        copiedAd.adSystem = wrapperAd.adSystem
                    }
                    
                    if !wrapperAd.adTitle.isEmpty {
                        copiedAd.adTitle = wrapperAd.adTitle
                    }
                    
                    if let error = wrapperAd.error {
                        copiedAd.error = error
                    }
                    
                    if wrapperAd.type != AdType.unknown {
                        copiedAd.type = wrapperAd.type
                    }
                    
                    copiedAd.impressions.append(contentsOf: wrapperAd.impressions)
                    
                    var copiedLinearCreatives = copiedAd.linearCreatives
                    for (idx, linearCreative) in copiedLinearCreatives.enumerated() {
                        var lc = linearCreative
                        if idx < wrapperAd.linearCreatives.count {
                            let wrapperLinearCreative = wrapperAd.linearCreatives[idx]
                            lc.duration = wrapperLinearCreative.duration
                            lc.mediaFiles.append(contentsOf: wrapperLinearCreative.mediaFiles)
                            lc.trackingEvents.append(contentsOf: wrapperLinearCreative.trackingEvents)
                        }
                        copiedLinearCreatives[idx] = lc
                    }
                    
                    copiedAd.linearCreatives = copiedLinearCreatives
                    copiedAd.extensions.append(contentsOf: wrapperAd.extensions)
                    copiedAd.companionAds.append(contentsOf: wrapperAd.companionAds)
                }
            } catch {
                print("Unable to parse wrapper")
            }

            return copiedAd
        }

        vm.ads = flattenedVastAds

        return vm
    }

}

extension VastParser: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if !validVastDocument && !parsedFirstElement {
            parsedFirstElement = true
            if elementName == VastElements.vast {
                validVastDocument = true
                vastModel = VastModel(attrDict: attributeDict)
            }
        }

        if validVastDocument && fatalError == nil {
            switch elementName {
            case AdElements.ad:
                currentVastAd = VastAd(attrDict: attributeDict)
            case ImpressionElements.impression:
                currentVastImpression = VastImpression(attrDict: attributeDict)
            case ExtensionElements.ext:
                currentVastExtension = VastExtension(attrDict: attributeDict)
            case ExtensionElements.creativeparameter:
                currentCreativeParameter = VastCreativeParameter(attrDict: attributeDict)
            case LinearCreativeElements.creative:
                currentLinearCreative = VastLinearCreative(attrDict: attributeDict)
            case TrackingEventElements.tracking:
                currentTrackingEvent = VastTrackingEvent(attrDict: attributeDict)
            case VideoClickElements.clickthrough, VideoClickElements.clicktracking, VideoClickElements.customclick:
                guard let type = ClickType(rawValue: elementName) else { break }
                currentVideoClick = VastVideoClick(type: type, attrDict: attributeDict)
            case MediaFileElements.mediafile:
                currentMediaFile = VastMediaFile(attrDict: attributeDict)
            case CompanionAdsElements.companionads:
                currentCompanionAds = VastCompanionAds(attrDict: attributeDict)
            case CompanionAdsElements.companion:
                currentCompanionCreative = VastCompanionCreative(attrDict: attributeDict)
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

        if validVastDocument && fatalError == nil {
            switch elementName {
            case VastElements.vast:
                vastModel?.ads = vastAds

                // If another class is using this delegate call complete
                if let vm = vastModel {
                    completeClosure?(fatalError, vm)
                }
            case VastElements.error:
                vastModel?.error =  URL(string: currentContent)
            case AdElements.ad:
                if let vastAd = currentVastAd {
                    vastAds.append(vastAd)
                    currentVastAd = nil
                }
            case AdElements.inline:
                currentVastAd?.type = .inline
            case AdElements.wrapper:
                currentVastAd?.type = .wrapper
            case AdElements.adsystem:
                currentVastAd?.adSystem = currentContent
            case AdElements.vastAdTagUri:
                currentVastAd?.wrapperUrl = URL(string: currentContent)
            case AdElements.adtitle:
                currentVastAd?.adTitle = currentContent
            case AdElements.error:
                currentVastAd?.error = URL(string: currentContent)
            case ImpressionElements.impression:
                currentVastImpression?.url = URL(string: currentContent)
                if let vastImpression = currentVastImpression {
                    currentVastAd?.impressions.append(vastImpression)
                    currentVastImpression = nil
                }
            case LinearCreativeElements.duration:
                currentLinearCreative?.duration = currentContent.toSeconds ?? -1.0
            case TrackingEventElements.tracking:
                currentTrackingEvent?.url = URL(string: currentContent)
                if let event = currentTrackingEvent {
                    vastTrackingEvents.append(event)
                    currentTrackingEvent = nil
                }
            case LinearCreativeElements.trackingevents:
                currentLinearCreative?.trackingEvents = vastTrackingEvents
                vastTrackingEvents = [VastTrackingEvent]()
            case VideoClickElements.clickthrough, VideoClickElements.clicktracking, VideoClickElements.customclick:
                currentVideoClick?.url = URL(string: currentContent)
                if let click = currentVideoClick {
                    vastVideoClicks.append(click)
                    currentVideoClick = nil
                }
            case LinearCreativeElements.videoclicks:
                currentLinearCreative?.videoClicks = vastVideoClicks
                vastVideoClicks = [VastVideoClick]()
            case MediaFileElements.mediafile:
                currentMediaFile?.url = URL(string: currentContent)
                if let mediaFile = currentMediaFile {
                    vastMediaFiles.append(mediaFile)
                    currentMediaFile = nil
                }
            case LinearCreativeElements.mediafiles:
                currentLinearCreative?.mediaFiles = vastMediaFiles
                vastMediaFiles = [VastMediaFile]()
            case LinearCreativeElements.creative:
                if let linearCreative = currentLinearCreative {
                    vastLinearCreatives.append(linearCreative)
                    currentLinearCreative = nil
                }
            case AdElements.creatives:
                currentVastAd?.linearCreatives = vastLinearCreatives
                vastLinearCreatives = [VastLinearCreative]()
            case ExtensionElements.creativeparameter:
                currentCreativeParameter?.content = currentContent
                if let creative = currentCreativeParameter {
                    creativeParameters.append(creative)
                    currentCreativeParameter = nil
                }
                break
            case ExtensionElements.creativeparameters:
                currentVastExtension?.creativeParameters = creativeParameters
                creativeParameters = [VastCreativeParameter]()
            case ExtensionElements.ext:
                if let ext = currentVastExtension {
                    vastExtensions.append(ext)
                    currentVastExtension = nil
                }
            case AdElements.extensions:
                currentVastAd?.extensions = vastExtensions
                vastExtensions = [VastExtension]()
            case CompanionResourceType.htmlresource.rawValue, CompanionResourceType.iframeresource.rawValue, CompanionResourceType.staticresource.rawValue:
                currentCompanionCreative?.type = CompanionResourceType(rawValue: elementName) ?? .unknown
                currentCompanionCreative?.content = currentContent
            case CompanionAdsElements.companion:
                if let companion = currentCompanionCreative {
                    companions.append(companion)
                    currentCompanionCreative = nil
                }
            case CompanionElements.alttext:
                currentCompanionCreative?.altText = currentContent
            case CompanionElements.companionclickthrough:
                currentCompanionCreative?.clickThrough = URL(string: currentContent)
            case CompanionElements.companionclicktracking:
                currentCompanionCreative?.clickTracking = URL(string: currentContent)
            case CompanionElements.trackingevents:
                if let _ = currentCompanionCreative {
                    currentCompanionCreative?.trackingEvents = vastTrackingEvents
                    vastTrackingEvents = [VastTrackingEvent]()
                }
            case CompanionAdsElements.companionads:
                currentCompanionAds?.companions = companions
                companions = [VastCompanionCreative]()
                if let companionAds = currentCompanionAds {
                    currentVastAd?.companionAds.append(companionAds)
                    currentCompanionAds = nil
                }
            default:
                break
            }
            currentContent = ""
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        fatalError = parseError
    }

}
