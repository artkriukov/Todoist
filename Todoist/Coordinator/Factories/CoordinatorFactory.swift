//
//  CoordinatorFactory.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.07.2025.
//

import UIKit

final class CoordinatorFactory {
    static func createAppCoordinator(
        navigationController: UINavigationController
    ) -> AppCoordinator {
        AppCoordinator(navigationController: navigationController)
    }
    
    static func createAuthCoordinator(
        navigationController: UINavigationController,
        authService: AuthServiceProtocol,
        logger: Logger,
        moduleFactory: ModuleFactory
    ) -> AuthCoordinator {
        AuthCoordinator(
            navigationController: navigationController,
            authService: authService,
            logger: logger,
            moduleFactory: moduleFactory
        )
    }
}
