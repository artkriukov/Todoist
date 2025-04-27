//
//  TabBarController.swift
//  Todoist
//
//  Created by Artem Kriukov on 27.04.2025.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }
    
    private func setupTabBar() {
        let toDoListVC = ToDoListViewController()
        let settingsVC = SettingsViewController()
        
        toDoListVC.title = "To Do"
        toDoListVC.tabBarItem.image = UIImage(systemName: "calendar.circle")
        
        settingsVC.title = "Settings"
        settingsVC.tabBarItem.image = UIImage(systemName: "gear")
        
        viewControllers = [toDoListVC, settingsVC]
    }
}
