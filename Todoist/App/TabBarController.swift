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
        let settingsVC = ProfileViewController()
        
        viewControllers = [
            configureNavigationBar(
                with: toDoListVC,
                title: ToDoStrings.toDoList.rawValue.localized(),
                image: "calendar.circle"
            ),
            configureNavigationBar(
                with: settingsVC,
                title: ProfileStrings.profileKey.rawValue.localized(),
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
