//
//  AudioRecorderController.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

import Foundation
import AVFoundation

class AudioRecorderController: NSObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder?
    var recordingSession: AVAudioSession!

    var recordedAudioURL: URL?

    override init() {
        super.init()
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try recordingSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session configuration error: \(error)")
            // Handle error appropriately
        }

//        do {
//            try recordingSession.setCategory(.playAndRecord, mode: .default)
//            try recordingSession.setActive(true)
//            recordingSession.requestRecordPermission { allowed in
//                if !allowed {
//                    print("Microphone permission denied")
//                }
//            }
//        } catch {
//            print("Failed to configure audio session: \(error.localizedDescription)")
//        }
    }

    func startRecording() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filename = documents.appendingPathComponent("recorded_audio.m4a")
        recordedAudioURL = filename

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            print("Audio recording started")
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        print("Audio recording stopped: \(recordedAudioURL?.path ?? "no file")")
    }
}
