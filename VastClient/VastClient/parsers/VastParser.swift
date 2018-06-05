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

    var currentContent = ""

    init(options: VastClientOptions) {
        self.options = options
    }

    func parse(url: URL) throws -> VastModel {
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

        guard let vm = vastModel else {
            throw VastError.internalError
        }

        if let err = vm.error, vm.ads.count == 0 {
            makeRequest(withUrl: err.withErrorCode(VastErrorCodes.noAdsVastResponse))
        }

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
                vastModel?.ads = vastAds.sorted(by: { $0.sequence < $1.sequence })
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
                // TODO:
                break
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
