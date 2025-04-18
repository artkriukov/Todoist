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
        
        let toDoListViewController = ToDoListViewController()
        self.window?.rootViewController = toDoListViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print(1)
    }
}

