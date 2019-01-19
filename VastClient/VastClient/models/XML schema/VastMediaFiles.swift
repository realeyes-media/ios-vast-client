//
//  VastMediaFiles.swift
//  VastClient
//
//  Created by Jan Bednar on 13/11/2018.
//

import Foundation

public struct VastMediaFiles {
    public var mediaFiles: [VastMediaFile] = []
    public var interactiveCreativeFiles: [VastInteractiveCreativeFile] = []
}

extension VastMediaFiles: Equatable {
}
