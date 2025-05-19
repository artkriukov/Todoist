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
    let dependencies = DependencyContainer.shared
    
    func application(_ application: UIApplication,
                     // swiftlint:disable:next discouraged_optional_collection
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        dependencies.logger.log("App launched")
        
        window = UIWindow()
        
        self.window?.rootViewController = TabBarController()
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
