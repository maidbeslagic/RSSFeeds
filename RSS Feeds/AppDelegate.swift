//
//  AppDelegate.swift
//  RSS Feeds
//
//  Created by Maid Beslagic on 6. 12. 2021..
//

import UIKit

let logger = Logger()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainNavigationViewController.shared
        window?.makeKeyAndVisible()
        return true
    }
}

