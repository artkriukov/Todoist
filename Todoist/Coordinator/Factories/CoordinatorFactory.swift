//
//  CoordinatorFactory.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.07.2025.
//

import UIKit

final class CoordinatorFactory {
    static func createAuthCoordinator(
        navigationController: UINavigationController
    ) -> AuthCoordinator {
        AuthCoordinator(navigationController: navigationController)
    }
}
