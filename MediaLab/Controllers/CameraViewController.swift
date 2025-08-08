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
        title = "Camera"
        view.backgroundColor = .black

        previewView.frame = view.bounds
        previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(previewView)
        
        cameraController.setupCamera(in: previewView)
    }
}
