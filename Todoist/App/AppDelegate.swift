//
//  AppDelegate.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import FirebaseCore
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let dependencies = DependencyContainer.shared
    
    var window: UIWindow?
    var appCoordinator = CoordinatorFactory.createAppCoordinator(
        navigationController: UINavigationController()
    )
    
    func application(_ application: UIApplication,
                     // swiftlint:disable:next discouraged_optional_collection
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        dependencies.logger.log("App launched")
    
        window = UIWindow()
        
        self.window?.rootViewController = appCoordinator.navigationController
        appCoordinator.start()
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
