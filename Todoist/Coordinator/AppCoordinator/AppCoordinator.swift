//
//  AppCoordinator.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.07.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private let dependencyContainer: DependencyContainer
    private var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    var completionHandler: CoordinatorHandler?
    
    init(navigationController: UINavigationController, dependencyContainer: DependencyContainer = .shared) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        let authService = dependencyContainer.authDependencyContainer.authService
        if authService.isSignedIn {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }

    private func showAuthFlow() {
        let authContainer = dependencyContainer.authDependencyContainer
        let authCoordinator = CoordinatorFactory.createAuthCoordinator(
            navigationController: navigationController,
            authService: authContainer.authService,
            logger: dependencyContainer.logger
        )
        childCoordinators.append(authCoordinator)
        
        authCoordinator.completionHandler = { [weak self] in self?.showMainFlow() }
        authCoordinator.start()
    }
    
    private func showMainFlow() {
        let tabBarController = TabBarController()
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
}
