//
//  AppCoordinator.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.07.2025.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let authService: AuthServiceProtocol
    private var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    var completionHandler: CoordinatorHandler?

    init(
        navigationController: UINavigationController,
        authService: AuthServiceProtocol = AuthService()
    ) {
        self.navigationController = navigationController
        self.authService = authService
    }
    
    func start() {
        if authService.isSignedIn {
            showMainFlow()
        } else {
            showAuthFlow()
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
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
}
