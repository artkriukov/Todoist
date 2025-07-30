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

    var window: UIWindow?
    private var appCoordinator: Coordinator?   

    func application(_ application: UIApplication,
                     // swiftlint:disable:next discouraged_optional_collection
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()

        let nav = UINavigationController()
        appCoordinator = CoordinatorFactory.createAppCoordinator(navigationController: nav)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        appCoordinator?.start()
        return true
    }
}
