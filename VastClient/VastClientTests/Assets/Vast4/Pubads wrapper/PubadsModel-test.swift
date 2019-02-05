//
//  PubadsModel-test.swift
//  VastClientTests
//
//  Created by Jan Bednar on 20/11/2018.
//  Copyright © 2018 John Gainfort Jr. All rights reserved.
//

import Foundation
@testable import VastClient

extension VastModel {
    static let pubadsModel: VastModel = {
        let wrapper = VastModel.pubadsWrapperModel
        let inline = VastModel.pubadsInlineModel
        
        var model = wrapper
        model.ads[0].adSystem = inline.ads.first?.adSystem
        if let title = inline.ads.first?.adTitle, !title.isEmpty {
            model.ads[0].adTitle = title
        }
        
        model.ads[0].type = .inline
        model.ads[0].impressions.append(contentsOf: inline.ads.first!.impressions)
        model.ads[0].extensions.append(contentsOf: inline.ads.first!.extensions)

        let linear = inline.ads.first!.creatives.first!.linear
        
        model.ads[0].creatives[0].linear?.duration = linear?.duration
        if let mediaFiles = linear?.files.mediaFiles {
            model.ads[0].creatives[0].linear?.files.mediaFiles.append(contentsOf: mediaFiles)
        }
        if let interactiveCreativeFiles = linear?.files.interactiveCreativeFiles {
            model.ads[0].creatives[0].linear?.files.interactiveCreativeFiles.append(contentsOf: interactiveCreativeFiles)
        }
        if let trackingEvents = linear?.trackingEvents {
            model.ads[0].creatives[0].linear?.trackingEvents.append(contentsOf: trackingEvents)
        }
        if let videoClicks = linear?.videoClicks {
            model.ads[0].creatives[0].linear?.videoClicks.append(contentsOf: videoClicks)
        }
        
        return model
    }()
}
