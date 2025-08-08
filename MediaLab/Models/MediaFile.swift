//
//  MediaFile.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

import Foundation
import AVFoundation

enum MediaType {
    case audio
    case video
    case mixed
}

struct MediaFile {
    let url: URL
    let type: MediaType
    let creationDate: Date

    var filename: String {
        return url.lastPathComponent
    }

    var duration: CMTime? {
        let asset = AVURLAsset(url: url)
        return asset.duration
    }

    var formattedDuration: String {
        guard let duration = duration else { return "--:--" }
        let totalSeconds = CMTimeGetSeconds(duration)
        let minutes = Int(totalSeconds / 60)
        let seconds = Int(totalSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
