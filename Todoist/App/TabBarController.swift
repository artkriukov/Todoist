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
        let settingsVC = UserSettingsViewController()
        
        viewControllers = [
            configureNavigationBar(
                with: toDoListVC,
                title: LocalizableLabels.toDoList.localize(),
                image: "calendar.circle"
            ),
            configureNavigationBar(
                with: settingsVC,
                title: LocalizableLabels.profileKey.localize(),
                image: "person.circle.fill"
            )
        ]
        
    }
    
    private func configureNavigationBar(
        with viewController: UIViewController,
        title: String,
        image: String
    ) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: image)
        navController.navigationBar.prefersLargeTitles = true
        
        viewController.navigationItem.title = title
        
        return navController
    }
}
