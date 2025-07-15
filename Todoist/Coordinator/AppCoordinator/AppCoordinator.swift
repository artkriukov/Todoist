//
//  AppCoordinator.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.07.2025.
//

import UIKit

final class AppCoordinator: Coordinator {

    var navigationController: UINavigationController
    var completionHandler: CoordinatorHandler?

    private var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let isAuth = false
        
        if !isAuth {
            showAuthFlow()
        } else {
            showMainFlow()
        }
    }

    private func showAuthFlow() {
        let authCoordinator = CoordinatorFactory.createAuthCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(authCoordinator)
        
        authCoordinator.completionHandler = { [weak self] in
            self?.showMainFlow()
        }
        
        authCoordinator.start()
    }
    
    private func showMainFlow() {
        let tabBarController = TabBarController()
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}
