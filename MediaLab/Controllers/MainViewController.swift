//
//  MainViewController.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

import UIKit
import AVFoundation

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let cameraVC = CameraViewController()
        cameraVC.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(systemName: "camera.fill"), tag: 0)

        let audioVC = AudioViewController()
        audioVC.tabBarItem = UITabBarItem(title: "Audio", image: UIImage(systemName: "mic.fill"), tag: 1)

        let editorVC = MediaEditorViewController()
        editorVC.tabBarItem = UITabBarItem(title: "Edit", image: UIImage(systemName: "scissors"), tag: 2)

        let effectsVC = AudioEffectsViewController()
        effectsVC.tabBarItem = UITabBarItem(title: "Effects", image: UIImage(systemName: "speaker.wave.2.fill"), tag: 3)

        viewControllers = [cameraVC, audioVC, editorVC, effectsVC].map { UINavigationController(rootViewController: $0) }
    }
}
