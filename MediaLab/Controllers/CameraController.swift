//
//  CameraController.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

import AVFoundation
import UIKit

class CameraController: NSObject {
    var captureSession: AVCaptureSession?
    var movieOutput = AVCaptureMovieFileOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    func setupCamera(in view: UIView) {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high

        guard let camera = AVCaptureDevice.default(for: .video) else {
            print("Camera not available")
            return
        }
        
        guard let mic = AVCaptureDevice.default(for: .audio) else {
            print("Microphone not available")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: camera)
            let audioInput = try AVCaptureDeviceInput(device: mic)
            
            if captureSession?.canAddInput(videoInput) == true {
                captureSession?.addInput(videoInput)
            } else {
                print("Could not add video input")
                return
            }
            
            if captureSession?.canAddInput(audioInput) == true {
                captureSession?.addInput(audioInput)
            } else {
                print("Could not add audio input")
                return
            }
            
            // Rest of your setup...
        } catch {
            print("Error setting up camera inputs: \(error)")
            return
        }
    }

    func startRecording(to url: URL) {
        movieOutput.startRecording(to: url, recordingDelegate: self)
    }

    func stopRecording() {
        movieOutput.stopRecording()
    }
    
    func startCamera() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if self?.captureSession?.isRunning == false {
                self?.captureSession?.startRunning()
            }
        }
    }

    func stopCamera() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if self?.captureSession?.isRunning == true {
                self?.captureSession?.stopRunning()
            }
        }
    }
}

extension CameraController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection], error: Error?) {
        print("Video recorded at: \(outputFileURL)")
    }
}
