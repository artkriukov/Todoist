//
//  AuthDependencyContainer.swift
//  Todoist
//
//  Created by Artem Kriukov on 30.07.2025.
//

import Foundation

struct AuthDependencyContainer {
    let authService: AuthServiceProtocol

    init(logger: Logger) {
        self.authService = AuthService(logger: logger)
    }
}
