//
//  TabBarController.swift
//  Todoist
//
//  Created by Artem Kriukov on 27.04.2025.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }
    
    private func setupTabBar() {
        let toDoListVC = ToDoListViewController()
        let settingsVC = UserSettingsViewController()
        settingsVC.onLogout = { NotificationCenter.default.post(name: .didLogoutNotification, object: nil) }

        viewControllers = [
            toDoListVC,
            settingsVC
        ]
        
        toDoListVC.tabBarItem = UITabBarItem(
            title: ToDoStrings.toDoList.rawValue.localized(),
            image: UIImage(systemName: "calendar.circle"),
            tag: 0
        )
        settingsVC.tabBarItem = UITabBarItem(
            title: ProfileStrings.profileKey.rawValue.localized(),
            image: UIImage(systemName: "person.circle.fill"),
            tag: 1
        )
    }
}

extension Notification.Name {
    static let didLogoutNotification = Notification.Name("didLogoutNotification")
}
