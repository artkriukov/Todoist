//
//  AppDelegate.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        self.window?.rootViewController = TabBarController()
        self.window?.makeKeyAndVisible()
        logger.log("App started")
        return true
    }
}

