//
//  AppDelegate.swift
//  MediaLab
//
//  Created by shafia on 08/08/2025.
//

//import UIKit
//
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        return true
//    }
//
//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//
//
//}


import UIKit
import AVFAudio

//@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    var window: UIWindow?
//
//    // For iOS 12 or earlier
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = MainViewController()
//        window?.makeKeyAndVisible()
//
//        return true
//    }
//    
////    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
////        do {
////            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
////            try AVAudioSession.sharedInstance().setActive(true)
////        } catch {
////            print("Audio session setup error: \(error)")
////        }
////        return true
////    }
//
//    // For iOS 13+, SceneDelegate handles the window
//}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // For iOS 12 and earlier
        if #available(iOS 13.0, *) {
            // SceneDelegate will handle this
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = MainViewController()
            window?.makeKeyAndVisible()
        }
        
        return true
    }
}


