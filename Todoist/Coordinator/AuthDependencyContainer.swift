//
//  AuthDependencyContainer.swift
//  Todoist
//
//  Created by Artem Kriukov on 30.07.2025.
//

import Foundation

final class AuthDependencyContainer {
    let logger: Logger
    let authService: AuthServiceProtocol
    let moduleFactory: ModuleFactory

    init(logger: Logger) {
        self.logger = logger
        self.authService = AuthService(logger: logger)
        self.moduleFactory = ModuleFactory()
    }
}
