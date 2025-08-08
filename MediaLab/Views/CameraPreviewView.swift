//
//  CameraPreviewView.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? {
        return layer as? AVCaptureVideoPreviewLayer
    }

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    func configure(with session: AVCaptureSession) {
        videoPreviewLayer?.session = session
        videoPreviewLayer?.videoGravity = .resizeAspectFill
    }
}
