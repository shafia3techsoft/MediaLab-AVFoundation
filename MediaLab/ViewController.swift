//
//  ViewController.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

//import UIKit
//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        previewView.configure(with: captureSession)
//    }
//
//
//}

import UIKit
import AVFoundation

//class ViewController: UIViewController {
//
//    let cameraController = CameraController()
//    let previewView = CameraPreviewView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Camera"
//        view.backgroundColor = .black
//
//        // Setup preview view
//        previewView.frame = view.bounds
//        previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(previewView)
//
//        // Configure the camera session
//        cameraController.setupCamera(in: previewView)
//    }
//}

class ViewController: UIViewController {
    let cameraController = CameraController()
    let previewView = CameraPreviewView()
    let placeholderLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Camera"
        view.backgroundColor = .black
        
        #if targetEnvironment(simulator)
        setupSimulatorPlaceholder()
        #else
        setupCameraPreview()
        #endif
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Move alert presentation here when view is fully in hierarchy
        #if targetEnvironment(simulator)
        showSimulatorAlert()
        #else
        checkCameraPermissions()
        #endif
    }
    
    private func setupCameraPreview() {
        previewView.frame = view.bounds
        previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(previewView)
    }
    
    private func setupSimulatorPlaceholder() {
        // ... existing placeholder setup code ...
    }
    
    private func showSimulatorAlert() {
        let alert = UIAlertController(
            title: "Camera Unavailable",
            message: "Please use a real device to test camera features",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func checkCameraPermissions() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.cameraController.startCamera()
                    } else {
                        self?.showCameraDeniedAlert()
                    }
                }
            }
        case .denied, .restricted:
            showCameraDeniedAlert()
        case .authorized:
            cameraController.startCamera()
        @unknown default:
            break
        }
    }
    
    private func showCameraDeniedAlert() {
        let alert = UIAlertController(
            title: "Camera Access Denied",
            message: "Please enable camera access in Settings",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        present(alert, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        #if !targetEnvironment(simulator)
        cameraController.stopCamera()
        #endif
    }
}
