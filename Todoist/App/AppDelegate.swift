//
//  AppDelegate.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     // swiftlint:disable:next discouraged_optional_collection
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        self.window?.rootViewController = TabBarController()
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
