//
//  MediaEditor.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

import Foundation
import AVFoundation

class MediaEditor {
    
    /// Combines video and audio into a single file and exports it.
    func merge(videoURL: URL, audioURL: URL, completion: @escaping (URL?) -> Void) async {
        let mixComposition = AVMutableComposition()

        // Load assets
        let videoAsset = AVURLAsset(url: videoURL)
        let audioAsset = AVURLAsset(url: audioURL)

            // Add video track
//        guard let videoTrack = try? await videoAsset.loadTracks(withMediaType: .video).first else {
//                print("Failed to get video track")
//                completion(nil)
//                return
//            }
        
        guard let videoTrack = try? await videoAsset.loadTracks(withMediaType: .video).first else {
            DispatchQueue.main.async {
                print("Failed to get video track")
                completion(nil)
            }
            return
        }
        

        let videoCompositionTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                                    preferredTrackID: kCMPersistentTrackID_Invalid)

        do {
            try await videoCompositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.load(.duration)),
                                                       of: videoTrack,
                                                       at: .zero)
        } catch {
            print("Error inserting video track: \(error)")
            completion(nil)
            return
        }

        // Add audio track
        if let audioTrack = try? await audioAsset.loadTracks(withMediaType: .audio).first {
            let audioCompositionTrack = mixComposition.addMutableTrack(withMediaType: .audio,
                                                                        preferredTrackID: kCMPersistentTrackID_Invalid)
            do {
                try await audioCompositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.load(.duration)),
                                                           of: audioTrack,
                                                           at: .zero)
            } catch {
                print("Error inserting audio track: \(error)")
                completion(nil)
                return
            }
        }

        // Export merged media
        exportComposition(mixComposition, completion: completion)
    }

    /// Trims the given video to a specified time range.
    func trim(videoURL: URL, startTime: CMTime, endTime: CMTime, completion: @escaping (URL?) -> Void) async {
        let asset = AVURLAsset(url: videoURL)
        let composition = AVMutableComposition()

        guard let videoTrack = try? await asset.loadTracks(withMediaType: .video).first else {
            completion(nil)
            return
        }

        let videoCompositionTrack = composition.addMutableTrack(withMediaType: .video,
                                                                preferredTrackID: kCMPersistentTrackID_Invalid)
        do {
            try videoCompositionTrack?.insertTimeRange(CMTimeRange(start: startTime, duration: endTime - startTime),
                                                       of: videoTrack,
                                                       at: .zero)
        } catch {
            print("Error trimming video: \(error)")
            completion(nil)
            return
        }

        exportComposition(composition, completion: completion)
    }

    private func exportComposition(_ composition: AVMutableComposition, completion: @escaping (URL?) -> Void) {
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("edited_output.mov")

        // Remove if existing
        try? FileManager.default.removeItem(at: outputURL)

        exportSession?.outputURL = outputURL
        exportSession?.outputFileType = .mov
        exportSession?.shouldOptimizeForNetworkUse = true

        exportSession?.exportAsynchronously {
            switch exportSession?.status {
            case .completed:
                print("Export succeeded: \(outputURL)")
                completion(outputURL)
            case .failed, .cancelled:
                print("Export failed: \(exportSession?.error?.localizedDescription ?? "unknown error")")
                completion(nil)
            default:
                break
            }
        }
    }
}
