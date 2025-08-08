//
//  AudioEffectsController.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

import Foundation
import AVFoundation

class AudioEffectsController {
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    
    private let reverb = AVAudioUnitReverb()
    private let pitchControl = AVAudioUnitTimePitch()
    
    private var audioFile: AVAudioFile?

    init() {
        setupAudioEngine()
    }

    private func setupAudioEngine() {
        audioEngine.attach(playerNode)
        audioEngine.attach(reverb)
        audioEngine.attach(pitchControl)

        // Connect nodes: Player -> Pitch -> Reverb -> Output
        audioEngine.connect(playerNode, to: pitchControl, format: nil)
        audioEngine.connect(pitchControl, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.mainMixerNode, format: nil)

        // Reverb settings
        reverb.loadFactoryPreset(.largeHall)
        reverb.wetDryMix = 50

        // Pitch settings (can be adjusted)
        pitchControl.pitch = 0  // 0 = normal, +1000 = high pitch, -1000 = low pitch
    }

    func loadAudioFile(url: URL) throws {
        audioFile = try AVAudioFile(forReading: url)
    }

//    func play() {
//        guard let audioFile = audioFile else {
//            print("No audio file loaded")
//            return
//        }
//
//        do {
//            try audioEngine.start()
//            playerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
//            playerNode.play()
//            print("Playing with effects")
//        } catch {
//            print("Failed to start audio engine: \(error)")
//        }
//    }
    
    func play() {
        guard let audioFile = audioFile else {
            print("No audio file loaded")
            return
        }

        DispatchQueue.main.async {
            do {
                try self.audioEngine.start()
                self.playerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
                self.playerNode.play()
                print("Playing with effects")
            } catch {
                print("Failed to start audio engine: \(error)")
            }
        }
    }

    func stop() {
        playerNode.stop()
        audioEngine.stop()
        print("Audio playback stopped")
    }

    // Optional: expose effect controls
    func setPitch(_ value: Float) {
        pitchControl.pitch = value  // e.g. +1200 = chipmunk, -1200 = deep voice
    }

    func setReverbMix(_ mix: Float) {
        reverb.wetDryMix = mix  // 0-100
    }
}
