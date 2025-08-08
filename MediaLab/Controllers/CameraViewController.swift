//
//  CameraViewController.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

import UIKit

class CameraViewController: UIViewController {
    let cameraController = CameraController()
    let previewView = CameraPreviewView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if targetEnvironment(simulator)
        showSimulatorWarning()
        return
        #endif
        
        
        title = "Camera"
        view.backgroundColor = .black

        previewView.frame = view.bounds
        previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(previewView)
        
        cameraController.setupCamera(in: previewView)
    }

    private func showSimulatorWarning() {
        let alert = UIAlertController(
            title: "Camera Unavailable",
            message: "Please use a real device to test camera features",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
