//
//  PlayerView.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
    
    private var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }

    func playMedia(from url: URL) {
        let player = AVPlayer(url: url)
        self.player = player
        player.play()
    }
}
