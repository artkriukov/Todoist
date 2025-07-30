//
//  DependencyContainer.swift
//  Todoist
//
//  Created by Artem Kriukov on 19.05.2025.
//

import Foundation

struct DependencyContainer {
    let logger: Logger
    let authDependencyContainer: AuthDependencyContainer

    static let shared: DependencyContainer = {
        #if DEBUG
        let logger = Loggers.combined(loggers: [ConsoleLogger(), FileLogger.shared])
        #else
        let logger = NullLogger()
        #endif
        return DependencyContainer(
            logger: logger,
            authDependencyContainer: AuthDependencyContainer(logger: logger)
        )
    }()
}
