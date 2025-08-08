//
//  MainViewController.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

//import UIKit
//import AVFoundation
//
//class MainViewController: UITabBarController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let cameraVC = CameraViewController()
//        cameraVC.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(systemName: "camera.fill"), tag: 0)
//
//        let audioVC = AudioViewController()
//        audioVC.tabBarItem = UITabBarItem(title: "Audio", image: UIImage(systemName: "mic.fill"), tag: 1)
//
//        let editorVC = MediaEditorViewController()
//        editorVC.tabBarItem = UITabBarItem(title: "Edit", image: UIImage(systemName: "scissors"), tag: 2)
//
//        let effectsVC = AudioEffectsViewController()
//        effectsVC.tabBarItem = UITabBarItem(title: "Effects", image: UIImage(systemName: "speaker.wave.2.fill"), tag: 3)
//
//        viewControllers = [cameraVC, audioVC, editorVC, effectsVC].map { UINavigationController(rootViewController: $0) }
//    }
//}

import UIKit
import AVFoundation

class MainViewController: UITabBarController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViewControllers()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        customizeTabBarAppearance()
        addCustomTopBorder()
        adjustTabBarItemPositions()
    }

//    private func customizeTabBarAppearance() {
//        // Customize tab bar colors
//        if #available(iOS 15.0, *) {
//            let appearance = UITabBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .systemBackground
//            
//            // Selected item color
//            appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
//            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
//            
//            // Unselected item color
//            appearance.stackedLayoutAppearance.normal.iconColor = .systemGray
//            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
//            
//            tabBar.standardAppearance = appearance
//            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
//        } else {
//            // Fallback for earlier iOS versions
//            tabBar.tintColor = .systemBlue
//            tabBar.unselectedItemTintColor = .systemGray
//        }
//    }
    
    private func customizeTabBarAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            
            // Configure glass effect with your color
            appearance.configureWithTransparentBackground()
            
            // Blur effect with your color tint
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundEffect = blurEffect
            
            // Color overlay (using your specified color)
            let backgroundColor = UIColor.customTabColor.withAlphaComponent(0.2)
            appearance.backgroundColor = backgroundColor
            
            // Remove default borders/shadows
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            
            // Selected item styling - your exact color
            appearance.stackedLayoutAppearance.selected.iconColor = .customTabColor
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.customTabColor,
                .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
            ]
            
            // Unselected item styling - slightly transparent version
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.customTabUnselected
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.customTabUnselected,
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ]
            
            // Apply appearances
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
            
            // Visual properties
            tabBar.isTranslucent = true
            tabBar.tintColor = .customTabColor
            tabBar.unselectedItemTintColor = .customTabUnselected
            tabBar.layer.masksToBounds = false
            
            // Rounded corners
            tabBar.layer.cornerRadius = 20
            tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
        } else {
            // iOS 14 and earlier fallback
            tabBar.isTranslucent = true
            tabBar.backgroundImage = UIImage()
            tabBar.shadowImage = UIImage()
            tabBar.backgroundColor = .clear
            
            // Blur view with your color tint
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            blurView.frame = tabBar.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // Add color overlay
            let tintView = UIView(frame: blurView.bounds)
            tintView.backgroundColor = UIColor.customTabColor.withAlphaComponent(0.2)
            tintView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            blurView.contentView.addSubview(tintView)
            tabBar.insertSubview(blurView, at: 0)
            
            tabBar.tintColor = .customTabColor
            tabBar.unselectedItemTintColor = .customTabUnselected
        }
    }

    
    private func addCustomTopBorder() {
        // Remove any existing border layers
        tabBar.layer.sublayers?.filter { $0.name == "topBorder" }.forEach { $0.removeFromSuperlayer() }
        
        // Add new border with your color
        let borderLayer = CALayer()
        borderLayer.name = "topBorder"
        borderLayer.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5)
        borderLayer.backgroundColor = UIColor.customTabColor.withAlphaComponent(0.3).cgColor
        
        let shadowLayer = CALayer()
        shadowLayer.frame = borderLayer.frame
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        shadowLayer.shadowRadius = 1
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.addSublayer(borderLayer)
        
        tabBar.layer.addSublayer(shadowLayer)
    }
    
    private func adjustTabBarItemPositions() {
        guard let items = tabBar.items else { return }
        
        for item in items {
            // Adjust icon and text positions
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
            
            // If you want to make the selected icon slightly larger
            if item == tabBar.selectedItem {
                item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            }
        }
    }
    
    private func setupViewControllers() {
        var viewControllers = [UIViewController]()
        
        // 1. Camera Tab (only on real devices)
        #if !targetEnvironment(simulator)
        let cameraVC = CameraViewController()
        cameraVC.tabBarItem = UITabBarItem(
            title: "Camera",
            image: UIImage(systemName: "camera.fill"),
            tag: 0
        )
        viewControllers.append(UINavigationController(rootViewController: cameraVC))
        #else
        let simulatorCameraVC = createSimulatorCameraPlaceholder()
        viewControllers.append(UINavigationController(rootViewController: simulatorCameraVC))
        #endif
        
        // 2. Audio Tab (works everywhere)
        let audioVC = AudioViewController()
        audioVC.tabBarItem = UITabBarItem(
            title: "Audio",
            image: UIImage(systemName: "mic.fill"),
            tag: 1
        )
        viewControllers.append(UINavigationController(rootViewController: audioVC))
        
        // 3. Editor Tab
        let editorVC = MediaEditorViewController()
        editorVC.tabBarItem = UITabBarItem(
            title: "Edit",
            image: UIImage(systemName: "scissors"),
            tag: 2
        )
        viewControllers.append(UINavigationController(rootViewController: editorVC))
        
        // 4. Effects Tab
        let effectsVC = AudioEffectsViewController()
        effectsVC.tabBarItem = UITabBarItem(
            title: "Effects",
            image: UIImage(systemName: "speaker.wave.2.fill"),
            tag: 3
        )
        viewControllers.append(UINavigationController(rootViewController: effectsVC))
        
        self.viewControllers = viewControllers
    }

    private func createSimulatorCameraPlaceholder() -> UIViewController {
        let placeholderVC = UIViewController()
        placeholderVC.view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Camera unavailable in simulator\nUse a real device for camera features"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        
        let imageView = UIImageView(image: UIImage(systemName: "camera.fill"))
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        
        placeholderVC.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: placeholderVC.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: placeholderVC.view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: placeholderVC.view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: placeholderVC.view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        placeholderVC.tabBarItem = UITabBarItem(
            title: "Camera",
            image: UIImage(systemName: "camera.fill"),
            tag: 0
        )
        
        return placeholderVC
    }
}
