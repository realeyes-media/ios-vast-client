//
//  FullVast4-test.swift
//  VastClientTests
//
//  Created by Jan Bednar on 07/12/2018.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation
@testable import VastClient

extension VastModel {
    static let fullVast4: VastModel = {
        let firstAd = getFirstAd()
        let secondAd = getSecondAd()
        let ads: [VastAd] = [firstAd, secondAd]
        let errors: [URL] = []
        return VastModel(version: "4.0", ads: ads, errors: errors)
    }()
    
    fileprivate static func getFirstAd() -> VastAd {
        let type: AdType = AdType.wrapper
        let id: String = "AdId1"
        let sequence: Int? = 1
        let conditionalAd: Bool? = false
        let adSystem: VastAdSystem? = VastAdSystem(version: "1.0", system: "AdSystem1")
    
        let impressions: [VastImpression] = [VastImpression(id: "ImpressionId1", url: URL(string: "http://example.com/track/impression1")!), VastImpression(id: "ImpressionId2", url: URL(string: "http://example.com/track/impression2")!)]
        
        let firstAdVerification = VastVerification(vendor: URL(string: "http://vendor1.com"), viewableImpression: VastViewableImpression(id: "VerificationViewableImpression1", url: URL(string: "http://example.com/track/VerificationViewableImpression1"), viewable: [], notViewable: [], viewUndetermined: []), javaScriptResource: [], flashResources: [], verificationParameters: nil)
        let secondAdVerification = VastVerification(vendor: URL(string: "http://vendor2.com"), viewableImpression: VastViewableImpression(id: "VerificationViewableImpression2", url: URL(string: "http://example.com/track/VerificationViewableImpression2"), viewable: [], notViewable: [], viewUndetermined: []), javaScriptResource: [], flashResources: [], verificationParameters: nil)
        
        let adVerifications: [VastVerification] = [firstAdVerification, secondAdVerification]
        
        let viewableURLs: [URL] = [URL(string: "http://example.com/track/viewable1")!, URL(string: "http://example.com/track/viewable2")!]
        let notViewableURLs: [URL] = [URL(string: "http://example.com/track/notViewable1")!, URL(string: "http://example.com/track/notViewable2")!]
        let viewUndeterminedURLs: [URL] = [URL(string: "http://example.com/track/viewUndetermined1")!, URL(string: "http://example.com/track/viewUndetermined2")!]
        let viewableImpression: VastViewableImpression? = VastViewableImpression(id: "ViewableImpressionId1", url: nil, viewable: viewableURLs, notViewable: notViewableURLs, viewUndetermined: viewUndeterminedURLs)
        
        let pricing: VastPricing? = VastPricing(model: .cpc, currency: "EUR", pricing: 10)
        let errors: [URL] = [URL(string: "http://example.com/error1")!, URL(string: "http://example.com/error2")!]
        
        
        let videoClick1 = VastVideoClick(id: "VideoClickTrackingId1", type: .clickTracking, url: URL(string: "http://example.com/track/VideoClickTracking1"))
        let videoClick2 = VastVideoClick(id: "VideoClickTrackingId2", type: .clickTracking, url: URL(string: "http://example.com/track/VideoClickTracking2"))
        let videoClick3 = VastVideoClick(id: "VideoCustomClick1", type: .customClick, url: URL(string: "http://example.com/track/VideoCustomClick1"))
        let videoClick4 = VastVideoClick(id: "VideoCustomClick2", type: .customClick, url: URL(string: "http://example.com/track/VideoCustomClick2"))
        let videoClicks: [VastVideoClick] = [videoClick1, videoClick2, videoClick3, videoClick4]
        
        func tracking(hour: Int, minute: Int, second: Int, type: TrackingEventType, url: String) -> VastTrackingEvent {
            return VastTrackingEvent(type: type, offset: Double(second + minute * 60 + hour * 3600) , url: URL(string: url), tracked: false)
        }
        
        let trackingEvents: [VastTrackingEvent] = [
            tracking(hour: 1, minute: 0, second: 1, type: .mute, url: "http://example.com/track/mute1"),
            tracking(hour: 1, minute: 0, second: 2, type: .unmute, url: "http://example.com/track/unmute1"),
            tracking(hour: 1, minute: 0, second: 3, type: .pause, url: "http://example.com/track/pause1"),
            tracking(hour: 1, minute: 0, second: 4, type: .resume, url: "http://example.com/track/resume1"),
            tracking(hour: 1, minute: 0, second: 5, type: .rewind, url: "http://example.com/track/rewind1"),
            tracking(hour: 1, minute: 0, second: 6, type: .skip, url: "http://example.com/track/skip1"),
            tracking(hour: 1, minute: 0, second: 7, type: .playerExpand, url: "http://example.com/track/playerExpand1"),
            tracking(hour: 1, minute: 0, second: 8, type: .playerCollapse, url: "http://example.com/track/playerCollapse1"),
            tracking(hour: 1, minute: 0, second: 9, type: .acceptInvitationLinear, url: "http://example.com/track/acceptInvitationLinear1"),
            tracking(hour: 1, minute: 0, second: 10, type: .unknown, url: "http://example.com/track/timeSpentViewing1"),
            tracking(hour: 1, minute: 0, second: 11, type: .progress, url: "http://example.com/track/progress1"),
            tracking(hour: 1, minute: 0, second: 12, type: .creativeView, url: "http://example.com/track/creativeView1"),
            tracking(hour: 1, minute: 0, second: 13, type: .acceptInvitation, url: "http://example.com/track/acceptInvitation1"),
            tracking(hour: 1, minute: 0, second: 14, type: .unknown, url: "http://example.com/track/adExpand1"),
            tracking(hour: 1, minute: 0, second: 15, type: .unknown, url: "http://example.com/track/adCollapse1"),
            tracking(hour: 1, minute: 0, second: 16, type: .unknown, url: "http://example.com/track/minimize1"),
            tracking(hour: 1, minute: 0, second: 17, type: .close, url: "http://example.com/track/close1"),
            tracking(hour: 1, minute: 0, second: 18, type: .unknown, url: "http://example.com/track/overlayViewDuration1"),
            tracking(hour: 1, minute: 0, second: 19, type: .unknown, url: "http://example.com/track/otherAdInteraction1"),
            tracking(hour: 1, minute: 1, second: 1, type: .start, url: "http://example.com/track/start1"),
            tracking(hour: 1, minute: 1, second: 2, type: .firstQuartile, url: "http://example.com/track/firstQuartile1"),
            tracking(hour: 1, minute: 1, second: 3, type: .midpoint, url: "http://example.com/track/midpoint1"),
            tracking(hour: 1, minute: 1, second: 4, type: .thirdQuartile, url: "http://example.com/track/thirdQuartile1"),
            tracking(hour: 1, minute: 1, second: 5, type: .complete, url: "http://example.com/track/complete1")
        ]
        let iconViewTracking: [URL] = [URL(string: "http://example.com/track/IconViewTracking3")!, URL(string: "http://example.com/track/IconViewTracking4")!]
        let iconClicks: IconClicks? = IconClicks(iconClickThrough: URL(string: "http://example.com/track/IconClickThrough1"), iconClickTracking: [VastIconClickTracking(id: "IconClickTrackingId3", url: URL(string: "http://example.com/track/IconClickTracking3")), VastIconClickTracking(id: "IconClickTrackingId4", url: URL(string: "http://example.com/track/IconClickTracking4"))])
        let staticResource: [VastStaticResource] = [VastStaticResource(creativeType: "StaticResourceCreativeType3", url: URL(string: "http://example.com/StaticResource3")!), VastStaticResource(creativeType: "StaticResourceCreativeType4", url: URL(string: "http://example.com/StaticResource4"))]
        
        let mediaFile: [VastMediaFile] = []
        let interactiveCreativeFile: [VastInteractiveCreativeFile] = []
        let mediaFiles = VastMediaFiles(mediaFiles: mediaFile, interactiveCreativeFiles: interactiveCreativeFile)
        
        let icons: [VastIcon] = [VastIcon(program: "program", width: 11, height: 10, xPosition: "20", yPosition: "21", duration: 5, offset: 6, apiFramework: "IconApiFramework1", pxratio: 1.1, iconViewTracking: iconViewTracking, iconClicks: iconClicks, staticResource: staticResource)]
        let firstLinear = VastLinearCreative(skipOffset: "00:00:10", duration: nil, adParameters: nil, videoClicks: videoClicks, trackingEvents: trackingEvents, files: mediaFiles, icons: icons)
        
        
        let companion1staticResources: [VastStaticResource] = [
            VastStaticResource(creativeType: "StaticResourceCreativeType1", url: URL(string: "http://example.com/StaticResource1")),
            VastStaticResource(creativeType: "StaticResourceCreativeType2", url: URL(string: "http://example.com/StaticResource2"))]
        let companion1iFrameResources: [URL] = [URL(string: "http://example.com/IFrameResource1")!, URL(string: "http://example.com/IFrameResource2")!]
        let companion1htmlResources: [URL] = [URL(string: "http://example.com/HTMLResource1")!, URL(string: "http://example.com/HTMLResource2")!]
        let companion1trackingEvents: [VastTrackingEvent] = [
            tracking(hour: 0, minute: 0, second: 1, type: .mute, url: "http://example.com/track/mute"),
            tracking(hour: 0, minute: 0, second: 2, type: .unmute, url: "http://example.com/track/unmute"),
            tracking(hour: 0, minute: 0, second: 3, type: .pause, url: "http://example.com/track/pause"),
            tracking(hour: 0, minute: 0, second: 4, type: .resume, url: "http://example.com/track/resume"),
            tracking(hour: 0, minute: 0, second: 5, type: .rewind, url: "http://example.com/track/rewind"),
            tracking(hour: 0, minute: 0, second: 6, type: .skip, url: "http://example.com/track/skip"),
            tracking(hour: 0, minute: 0, second: 7, type: .playerExpand, url: "http://example.com/track/playerExpand"),
            tracking(hour: 0, minute: 0, second: 8, type: .playerCollapse, url: "http://example.com/track/playerCollapse"),
            tracking(hour: 0, minute: 0, second: 9, type: .acceptInvitationLinear, url: "http://example.com/track/acceptInvitationLinear"),
            tracking(hour: 0, minute: 0, second: 10, type: .unknown, url: "http://example.com/track/timeSpentViewing"),
            tracking(hour: 0, minute: 0, second: 11, type: .progress, url: "http://example.com/track/progress"),
            tracking(hour: 0, minute: 0, second: 12, type: .creativeView, url: "http://example.com/track/creativeView"),
            tracking(hour: 0, minute: 0, second: 13, type: .acceptInvitation, url: "http://example.com/track/acceptInvitation"),
            tracking(hour: 0, minute: 0, second: 14, type: .unknown, url: "http://example.com/track/adExpand"),
            tracking(hour: 0, minute: 0, second: 15, type: .unknown, url: "http://example.com/track/adCollapse"),
            tracking(hour: 0, minute: 0, second: 16, type: .unknown, url: "http://example.com/track/minimize"),
            tracking(hour: 0, minute: 0, second: 17, type: .close, url: "http://example.com/track/close"),
            tracking(hour: 0, minute: 0, second: 18, type: .unknown, url: "http://example.com/track/overlayViewDuration"),
            tracking(hour: 0, minute: 0, second: 19, type: .unknown, url: "http://example.com/track/otherAdInteraction"),
            tracking(hour: 0, minute: 1, second: 1, type: .start, url: "http://example.com/track/start"),
            tracking(hour: 0, minute: 1, second: 2, type: .firstQuartile, url: "http://example.com/track/firstQuartile"),
            tracking(hour: 0, minute: 1, second: 3, type: .midpoint, url: "http://example.com/track/midpoint"),
            tracking(hour: 0, minute: 1, second: 4, type: .thirdQuartile, url: "http://example.com/track/thirdQuartile"),
            tracking(hour: 0, minute: 1, second: 5, type: .complete, url: "http://example.com/track/complete")
            ]
        let companion1adParameters = VastAdParameters(xmlEncoded: "true", content: "http://example.com/AdParameters1")
        
        let companion1 = VastCompanionCreative(width: 200, height: 50, id: "CompanionId1", assetWidth: 201, assetHeight: 51, expandedWidth: 202, expandedHeight: 52, apiFramework: "CompanionApiFramework1", adSlotId: "AdSlot1", pxRatio: 1, staticResource: companion1staticResources, iFrameResource: companion1iFrameResources, htmlResource: companion1htmlResources, altText: "AltText1", companionClickThrough: URL(string: "http://example.com/track/CompanionClickThrough1"), companionClickTracking: [URL(string: "http://example.com/track/CompanionClickTracking1")!, URL(string: "http://example.com/track/CompanionClickTracking2")!], trackingEvents: companion1trackingEvents, adParameters: companion1adParameters)
        
        let companion2 = VastCompanionCreative(width: 55, height: 205, id: "CompanionId2", assetWidth: nil, assetHeight: nil, expandedWidth: nil, expandedHeight: nil, apiFramework: nil, adSlotId: nil, pxRatio: nil, staticResource: [], iFrameResource: [], htmlResource: [], altText: nil, companionClickThrough: nil, companionClickTracking: [], trackingEvents: [], adParameters: nil)
        let companionAds = VastCompanionAds(required: .none, companions: [companion1, companion2])
        let events: [VastTrackingEvent] = [
            VastTrackingEvent(type: .mute, offset: 7201.0, url: URL(string: "http://example.com/track/mute2"), tracked: false),
            VastTrackingEvent(type: .unmute, offset: 7202.0, url: URL(string: "http://example.com/track/unmute2"), tracked: false),
            VastTrackingEvent(type: .pause, offset: 7203.0, url: URL(string: "http://example.com/track/pause2"), tracked: false),
            VastTrackingEvent(type: .resume, offset: 7204.0, url: URL(string: "http://example.com/track/resume2"), tracked: false),
            VastTrackingEvent(type: .rewind, offset: 7205.0, url: URL(string: "http://example.com/track/rewind2"), tracked: false),
            VastTrackingEvent(type: .skip, offset: 7206.0, url: URL(string: "http://example.com/track/skip2"), tracked: false),
            VastTrackingEvent(type: .playerExpand, offset: 7207.0, url: URL(string: "http://example.com/track/playerExpand2"), tracked: false),
            VastTrackingEvent(type: .playerCollapse, offset: 7208.0, url: URL(string: "http://example.com/track/playerCollapse2"), tracked: false),
            VastTrackingEvent(type: .acceptInvitationLinear, offset: 7209.0, url: URL(string: "http://example.com/track/acceptInvitationLinear2"), tracked: false),
            VastTrackingEvent(type: .unknown, offset: 7210.0, url: URL(string: "http://example.com/track/timeSpentViewing2"), tracked: false),
            VastTrackingEvent(type: .progress, offset: 7211.0, url: URL(string: "http://example.com/track/progress2"), tracked: false),
            VastTrackingEvent(type: .creativeView, offset: 7212.0, url: URL(string: "http://example.com/track/creativeView2"), tracked: false),
            VastTrackingEvent(type: .acceptInvitation, offset: 7213.0, url: URL(string: "http://example.com/track/acceptInvitation2"), tracked: false),
            VastTrackingEvent(type: .unknown, offset: 7214.0, url: URL(string: "http://example.com/track/adExpand2"), tracked: false),
            VastTrackingEvent(type: .unknown, offset: 7215.0, url: URL(string: "http://example.com/track/adCollapse2"), tracked: false),
            VastTrackingEvent(type: .unknown, offset: 7216.0, url: URL(string: "http://example.com/track/minimize2"), tracked: false),
            VastTrackingEvent(type: .close, offset: 7217.0, url: URL(string: "http://example.com/track/close2"), tracked: false),
            VastTrackingEvent(type: .unknown, offset: 7218.0, url: URL(string: "http://example.com/track/overlayViewDuration2"), tracked: false),
            VastTrackingEvent(type: .unknown, offset: 7219.0, url: URL(string: "http://example.com/track/otherAdInteraction2"), tracked: false),
            VastTrackingEvent(type: .start, offset: 7261.0, url: URL(string: "http://example.com/track/start2"), tracked: false),
            VastTrackingEvent(type: .firstQuartile, offset: 7262.0, url: URL(string: "http://example.com/track/firstQuartile2"), tracked: false),
            VastTrackingEvent(type: .midpoint, offset: 7263.0, url: URL(string: "http://example.com/track/midpoint2"), tracked: false),
            VastTrackingEvent(type: .thirdQuartile, offset: 7264.0, url: URL(string: "http://example.com/track/thirdQuartile2"), tracked: false),
            VastTrackingEvent(type: .complete, offset: 7265.0, url: URL(string: "http://example.com/track/complete2"), tracked: false)
        ]
        let nonLinear = [
            VastNonLinear(height: "", id: "", width: "", staticResource: nil, nonLinearClickTracking: URL(string: "http://example.com/track/NonLinearClickTracking1")),
            VastNonLinear(height: "", id: "", width: "", staticResource: nil, nonLinearClickTracking: URL(string: "http://example.com/track/NonLinearClickTracking2"))
        ]
        let nonLinearCreative = VastNonLinearAdsCreative(trackingEvents: events, nonLinear: nonLinear)
        
        let firstCreative = VastCreative(id: "CreativeId1", adId: "CreativeAdId1", sequence: 1, apiFramework: "CreativeApiFramework1", universalAdId: nil, creativeExtensions: [], linear: firstLinear, nonLinearAds: nil, companionAds: companionAds)
        let secondCreative = VastCreative(id: "CreativeId2", adId: "CreativeAdId2", sequence: 2, apiFramework: "CreativeApiFramework2", universalAdId: nil, creativeExtensions: [], linear: nil, nonLinearAds: nonLinearCreative, companionAds: nil)
        
        let creatives: [VastCreative] = [firstCreative ,secondCreative]
        let extensions: [VastExtension] = [VastExtension(type: "ExtensionType1", creativeParameters: []), VastExtension(type: "ExtensionType2", creativeParameters: [])]
        let adTitle: String? = nil
        let adCategories: [VastAdCategory] = []
        let description: String? = nil
        let advertiser: String? = nil
        let surveys: [VastSurvey] = []
        
        let followAdditionalWrappers: Bool? = true
        let allowMultipleAds: Bool? = true
        let fallbackOnNoAd: Bool? = false
        let adTagUri: URL? = URL(string: "http://example.com/VASTAdTagURI")
        let wrapper: VastWrapper? = VastWrapper(followAdditionalWrappers: followAdditionalWrappers, allowMultipleAds: allowMultipleAds, fallbackOnNoAd: fallbackOnNoAd, adTagUri: adTagUri)
        
        return VastAd(type: type, id: id, sequence: sequence, conditionalAd: conditionalAd, adSystem: adSystem, impressions: impressions, adVerifications: adVerifications, viewableImpression: viewableImpression, pricing: pricing, errors: errors, creatives: creatives, extensions: extensions, adTitle: adTitle, adCategories: adCategories, description: description, advertiser: advertiser, surveys: surveys, wrapper: wrapper)
    }
    
    fileprivate static func getSecondAd() -> VastAd {
        let type: AdType = AdType.inline
        let id: String = "AdId2"
        let sequence: Int? = 2
        let conditionalAd: Bool? = true
        let adSystem: VastAdSystem? = VastAdSystem(version: "2.0", system: "AdSystem2")
        
        let errors: [URL] = [URL(string: "http://example.com/error3")!, URL(string: "http://example.com/error4")!]
        
        let pricing: VastPricing? = VastPricing(model: .cpm, currency: "CZK", pricing: 99.90)
        
        let impressions: [VastImpression] = [VastImpression(id: "ImpressionId3", url: URL(string: "http://example.com/track/impression3")!), VastImpression(id: "ImpressionId4", url: URL(string: "http://example.com/track/impression4")!)]
        
        let firstAdVerification = VastVerification(vendor: URL(string: "http://vendor3.com"), viewableImpression: VastViewableImpression(id: "VerificationViewableImpression3", url: URL(string: "http://example.com/track/VerificationViewableImpression3"), viewable: [], notViewable: [], viewUndetermined: []), javaScriptResource: [VastResource(apiFramework: "JavaScriptResourceApiFramework1", url: URL(string: "http://example.com/track/JavaScriptResource1")), VastResource(apiFramework: "JavaScriptResourceApiFramework2", url: URL(string: "http://example.com/track/JavaScriptResource2"))], flashResources: [VastResource(apiFramework: "FlashResourceApiFramework1", url: URL(string: "http://example.com/track/FlashResource1")), VastResource(apiFramework: "FlashResourceApiFramework2", url: URL(string: "http://example.com/track/FlashResource2"))], verificationParameters: nil)
        let secondAdVerification = VastVerification(vendor: URL(string: "http://vendor4.com"), viewableImpression: VastViewableImpression(id: "VerificationViewableImpression4", url: URL(string: "http://example.com/track/VerificationViewableImpression4"), viewable: [], notViewable: [], viewUndetermined: []), javaScriptResource: [VastResource(apiFramework: "JavaScriptResourceApiFramework3", url: URL(string: "http://example.com/track/JavaScriptResource3")), VastResource(apiFramework: "JavaScriptResourceApiFramework4", url: URL(string: "http://example.com/track/JavaScriptResource4"))], flashResources: [VastResource(apiFramework: "FlashResourceApiFramework3", url: URL(string: "http://example.com/track/FlashResource3")), VastResource(apiFramework: "FlashResourceApiFramework4", url: URL(string: "http://example.com/track/FlashResource4"))], verificationParameters: nil)
        
        let adVerifications: [VastVerification] = [firstAdVerification, secondAdVerification]
        
        let viewableURLs: [URL] = [URL(string: "http://example.com/track/viewable3")!, URL(string: "http://example.com/track/viewable4")!]
        let notViewableURLs: [URL] = [URL(string: "http://example.com/track/notViewable3")!, URL(string: "http://example.com/track/notViewable4")!]
        let viewUndeterminedURLs: [URL] = [URL(string: "http://example.com/track/viewUndetermined3")!, URL(string: "http://example.com/track/viewUndetermined4")!]
        let viewableImpression: VastViewableImpression? = VastViewableImpression(id: "ViewableImpressionId2", url: nil, viewable: viewableURLs, notViewable: notViewableURLs, viewUndetermined: viewUndeterminedURLs)
        
        
        let videoClick1 = VastVideoClick(id: "VideoClickTrackingId3", type: .clickTracking, url: URL(string: "http://example.com/track/VideoClickTracking3"))
        let videoClick2 = VastVideoClick(id: "VideoClickTrackingId4", type: .clickTracking, url: URL(string: "http://example.com/track/VideoClickTracking4"))
        let videoClick3 = VastVideoClick(id: "VideoCustomClick3", type: .customClick, url: URL(string: "http://example.com/track/VideoCustomClick3"))
        let videoClick4 = VastVideoClick(id: "VideoCustomClick4", type: .customClick, url: URL(string: "http://example.com/track/VideoCustomClick4"))
        let videoClick5 = VastVideoClick(id: "ClickThrough", type: .clickThrough, url: URL(string: "http://example.com/track/videoClickThrough"))
        let videoClicks: [VastVideoClick] = [videoClick1, videoClick2, videoClick3, videoClick4, videoClick5]
        
        func tracking(hour: Int, minute: Int, second: Int, type: TrackingEventType, url: String) -> VastTrackingEvent {
            return VastTrackingEvent(type: type, offset: Double(second + minute * 60 + hour * 3600) , url: URL(string: url), tracked: false)
        }
        
        let trackingEvents: [VastTrackingEvent] = [
            tracking(hour: 4, minute: 0, second: 1, type: .mute, url: "http://example.com/track/mute4"),
            tracking(hour: 4, minute: 0, second: 2, type: .unmute, url: "http://example.com/track/unmute4"),
            tracking(hour: 4, minute: 0, second: 3, type: .pause, url: "http://example.com/track/pause4"),
            tracking(hour: 4, minute: 0, second: 4, type: .resume, url: "http://example.com/track/resume4"),
            tracking(hour: 4, minute: 0, second: 5, type: .rewind, url: "http://example.com/track/rewind4"),
            tracking(hour: 4, minute: 0, second: 6, type: .skip, url: "http://example.com/track/skip4"),
            tracking(hour: 4, minute: 0, second: 7, type: .playerExpand, url: "http://example.com/track/playerExpand4"),
            tracking(hour: 4, minute: 0, second: 8, type: .playerCollapse, url: "http://example.com/track/playerCollapse4"),
            tracking(hour: 4, minute: 0, second: 9, type: .acceptInvitationLinear, url: "http://example.com/track/acceptInvitationLinear4"),
            tracking(hour: 4, minute: 0, second: 10, type: .unknown, url: "http://example.com/track/timeSpentViewing4"),
            tracking(hour: 4, minute: 0, second: 11, type: .progress, url: "http://example.com/track/progress4"),
            tracking(hour: 4, minute: 0, second: 12, type: .creativeView, url: "http://example.com/track/creativeView4"),
            tracking(hour: 4, minute: 0, second: 13, type: .acceptInvitation, url: "http://example.com/track/acceptInvitation4"),
            tracking(hour: 4, minute: 0, second: 14, type: .unknown, url: "http://example.com/track/adExpand4"),
            tracking(hour: 4, minute: 0, second: 15, type: .unknown, url: "http://example.com/track/adCollapse4"),
            tracking(hour: 4, minute: 0, second: 16, type: .unknown, url: "http://example.com/track/minimize4"),
            tracking(hour: 4, minute: 0, second: 17, type: .close, url: "http://example.com/track/close4"),
            tracking(hour: 4, minute: 0, second: 18, type: .unknown, url: "http://example.com/track/overlayViewDuration4"),
            tracking(hour: 4, minute: 0, second: 19, type: .unknown, url: "http://example.com/track/otherAdInteraction4"),
            tracking(hour: 4, minute: 1, second: 1, type: .start, url: "http://example.com/track/start4"),
            tracking(hour: 4, minute: 1, second: 2, type: .firstQuartile, url: "http://example.com/track/firstQuartile4"),
            tracking(hour: 4, minute: 1, second: 3, type: .midpoint, url: "http://example.com/track/midpoint4"),
            tracking(hour: 4, minute: 1, second: 4, type: .thirdQuartile, url: "http://example.com/track/thirdQuartile4"),
            tracking(hour: 4, minute: 1, second: 5, type: .complete, url: "http://example.com/track/complete4")
        ]
        let iconViewTracking: [URL] = [URL(string: "http://example.com/track/IconViewTracking5")!, URL(string: "http://example.com/track/IconViewTracking6")!]
        let iconClicks: IconClicks? = IconClicks(iconClickThrough: URL(string: "http://example.com/track/IconClickThrough2"), iconClickTracking: [VastIconClickTracking(id: "IconClickTrackingId5", url: URL(string: "http://example.com/track/IconClickTracking5")), VastIconClickTracking(id: "IconClickTrackingId6", url: URL(string: "http://example.com/track/IconClickTracking6"))])
        let staticResource: [VastStaticResource] = [VastStaticResource(creativeType: "StaticResourceCreativeType7", url: URL(string: "http://example.com/StaticResource7")!), VastStaticResource(creativeType: "StaticResourceCreativeType8", url: URL(string: "http://example.com/StaticResource8"))]
        
        let mediaFile1 = VastMediaFile(delivery: "progressive", type: "video/mp4", width: "100", height: "50", codec: "H.246", id: "1", bitrate: 100, minBitrate: 50, maxBitrate: 200, scalable: true, maintainAspectRatio: true, apiFramework: "MediaFileApiFramework1", url: URL(string: "http://example.com/video.mp4"))
        let mediaFile2 = VastMediaFile(delivery: "streaming", type: "video/mp4", width: "101", height: "51", codec: "H.247", id: "2", bitrate: 101, minBitrate: 51, maxBitrate: 201, scalable: false, maintainAspectRatio: false, apiFramework: "MediaFileApiFramework2", url: URL(string: "http://example.com/video1.mp4"))
        let mediaFile: [VastMediaFile] = [mediaFile1, mediaFile2]
        
        let interactiveCreativeFile1 = VastInteractiveCreativeFile(type: "text/html", apiFramework: "InteractiveCreativeFileApiFramework1", url: URL(string: "http://example.com/InteractiveCreativeFile1"))
        let interactiveCreativeFile2 = VastInteractiveCreativeFile(type: "text/text", apiFramework: "InteractiveCreativeFileApiFramework2", url: URL(string: "http://example.com/InteractiveCreativeFile2"))
        let interactiveCreativeFile: [VastInteractiveCreativeFile] = [interactiveCreativeFile1, interactiveCreativeFile2]
        let mediaFiles = VastMediaFiles(mediaFiles: mediaFile, interactiveCreativeFiles: interactiveCreativeFile)
        
        let icons: [VastIcon] = [VastIcon(program: "program2", width: 211, height: 210, xPosition: "220", yPosition: "221", duration: 125, offset: 126, apiFramework: "IconApiFramework2", pxratio: 1.2, iconViewTracking: iconViewTracking, iconClicks: iconClicks, staticResource: staticResource)]
        let adParameters = VastAdParameters(xmlEncoded: "true", content: "http://example.com/AdParameters3")
        let firstLinear = VastLinearCreative(skipOffset: "00:00:08", duration: 70, adParameters: adParameters, videoClicks: videoClicks, trackingEvents: trackingEvents, files: mediaFiles, icons: icons)
        
        let creativeExtensions: [VastCreativeExtension] = [VastCreativeExtension(mimeType: "CreativeExtensionType5", content: ""), VastCreativeExtension(mimeType: "CreativeExtensionType6", content: "")]
        
        let companion1staticResources: [VastStaticResource] = [
            VastStaticResource(creativeType: "StaticResourceCreativeType5", url: URL(string: "http://example.com/StaticResource5")),
            VastStaticResource(creativeType: "StaticResourceCreativeType6", url: URL(string: "http://example.com/StaticResource6"))]
        let companion1iFrameResources: [URL] = [URL(string: "http://example.com/IFrameResource5")!, URL(string: "http://example.com/IFrameResource6")!]
        let companion1htmlResources: [URL] = [URL(string: "http://example.com/HTMLResource5")!, URL(string: "http://example.com/HTMLResource6")!]
        let companion1trackingEvents: [VastTrackingEvent] = [
            tracking(hour: 3, minute: 0, second: 1, type: .mute, url: "http://example.com/track/mute3"),
            tracking(hour: 3, minute: 0, second: 2, type: .unmute, url: "http://example.com/track/unmute3"),
            tracking(hour: 3, minute: 0, second: 3, type: .pause, url: "http://example.com/track/pause3"),
            tracking(hour: 3, minute: 0, second: 4, type: .resume, url: "http://example.com/track/resume3"),
            tracking(hour: 3, minute: 0, second: 5, type: .rewind, url: "http://example.com/track/rewind3"),
            tracking(hour: 3, minute: 0, second: 6, type: .skip, url: "http://example.com/track/skip3"),
            tracking(hour: 3, minute: 0, second: 7, type: .playerExpand, url: "http://example.com/track/playerExpand3"),
            tracking(hour: 3, minute: 0, second: 8, type: .playerCollapse, url: "http://example.com/track/playerCollapse3"),
            tracking(hour: 3, minute: 0, second: 9, type: .acceptInvitationLinear, url: "http://example.com/track/acceptInvitationLinear3"),
            tracking(hour: 3, minute: 0, second: 10, type: .unknown, url: "http://example.com/track/timeSpentViewing3"),
            tracking(hour: 3, minute: 0, second: 11, type: .progress, url: "http://example.com/track/progress3"),
            tracking(hour: 3, minute: 0, second: 12, type: .creativeView, url: "http://example.com/track/creativeView3"),
            tracking(hour: 3, minute: 0, second: 13, type: .acceptInvitation, url: "http://example.com/track/acceptInvitation3"),
            tracking(hour: 3, minute: 0, second: 14, type: .unknown, url: "http://example.com/track/adExpand3"),
            tracking(hour: 3, minute: 0, second: 15, type: .unknown, url: "http://example.com/track/adCollapse3"),
            tracking(hour: 3, minute: 0, second: 16, type: .unknown, url: "http://example.com/track/minimize3"),
            tracking(hour: 3, minute: 0, second: 17, type: .close, url: "http://example.com/track/close3"),
            tracking(hour: 3, minute: 0, second: 18, type: .unknown, url: "http://example.com/track/overlayViewDuration3"),
            tracking(hour: 3, minute: 0, second: 19, type: .unknown, url: "http://example.com/track/otherAdInteraction3"),
            tracking(hour: 3, minute: 1, second: 1, type: .start, url: "http://example.com/track/start3"),
            tracking(hour: 3, minute: 1, second: 2, type: .firstQuartile, url: "http://example.com/track/firstQuartile3"),
            tracking(hour: 3, minute: 1, second: 3, type: .midpoint, url: "http://example.com/track/midpoint3"),
            tracking(hour: 3, minute: 1, second: 4, type: .thirdQuartile, url: "http://example.com/track/thirdQuartile3"),
            tracking(hour: 3, minute: 1, second: 5, type: .complete, url: "http://example.com/track/complete3"),
        ]
        let companion1adParameters = VastAdParameters(xmlEncoded: "true", content: "http://example.com/AdParameters2")
        
        let companion1 = VastCompanionCreative(width: 3200, height: 350, id: "CompanionId3", assetWidth: 3201, assetHeight: 351, expandedWidth: 3202, expandedHeight: 352, apiFramework: "CompanionApiFramework3", adSlotId: "AdSlot3", pxRatio: 1.3, staticResource: companion1staticResources, iFrameResource: companion1iFrameResources, htmlResource: companion1htmlResources, altText: "AltText2", companionClickThrough: URL(string: "http://example.com/track/CompanionClickThrough2"), companionClickTracking: [URL(string: "http://example.com/track/CompanionClickTracking3")!, URL(string: "http://example.com/track/CompanionClickTracking4")!], trackingEvents: companion1trackingEvents, adParameters: companion1adParameters)
        
        let companion2 = VastCompanionCreative(width: 455, height: 4205, id: "CompanionId4", assetWidth: nil, assetHeight: nil, expandedWidth: nil, expandedHeight: nil, apiFramework: nil, adSlotId: nil, pxRatio: nil, staticResource: [], iFrameResource: [], htmlResource: [], altText: nil, companionClickThrough: nil, companionClickTracking: [], trackingEvents: [], adParameters: nil)
        let companionAds = VastCompanionAds(required: .any, companions: [companion1, companion2])
        
        let firstCreative = VastCreative(id: "CreativeId3", adId: "CreativeAdId3", sequence: 3, apiFramework: "CreativeApiFramework3", universalAdId: VastUniversalAdId(idRegistry: "unknown", idValue: "unknown", uniqueCreativeId: "UniversalAdId1"), creativeExtensions: creativeExtensions, linear: nil, nonLinearAds: nil, companionAds: companionAds)
        let secondCreative = VastCreative(id: "CreativeId4", adId: "CreativeAdId4", sequence: 4, apiFramework: "CreativeApiFramework4", universalAdId: VastUniversalAdId(idRegistry: "unknown", idValue: "unknown", uniqueCreativeId: "UniversalAdId2"), creativeExtensions: [], linear: firstLinear, nonLinearAds: nil, companionAds: nil)
        
        let creatives: [VastCreative] = [firstCreative ,secondCreative]
        let extensions: [VastExtension] = [VastExtension(type: "ExtensionType3", creativeParameters: []), VastExtension(type: "ExtensionType4", creativeParameters: [])]
        let adTitle: String? = "AdTitle"
        let adCategories: [VastAdCategory] = [VastAdCategory(authority: URL(string: "CategoryAuthority1"), category: "Category1"), VastAdCategory(authority: URL(string: "CategoryAuthority2"), category: "Category2")]
        let description: String? = "Description"
        let advertiser: String? = "Advertiser"
        let surveys: [VastSurvey] = [VastSurvey(type: "text/html", survey: URL(string: "http://example.com/survey"))]
        
        
        let wrapper: VastWrapper? = nil
        
        return VastAd(type: type, id: id, sequence: sequence, conditionalAd: conditionalAd, adSystem: adSystem, impressions: impressions, adVerifications: adVerifications, viewableImpression: viewableImpression, pricing: pricing, errors: errors, creatives: creatives, extensions: extensions, adTitle: adTitle, adCategories: adCategories, description: description, advertiser: advertiser, surveys: surveys, wrapper: wrapper)
        
    }
    
}
