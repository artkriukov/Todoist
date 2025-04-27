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
        
        toDoListVC.title = "Дела"
        toDoListVC.tabBarItem.image = UIImage(systemName: "calendar.circle")
        
        settingsVC.title = "Профиль"
        settingsVC.tabBarItem.image = UIImage(systemName: "person.circle.fill")
        
        viewControllers = [toDoListVC, settingsVC]
    }
}
