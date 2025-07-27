//
//  DependencyContainer.swift
//  Todoist
//
//  Created by Artem Kriukov on 19.05.2025.
//

import Foundation

struct DependencyContainer {
    let logger: Logger
    
#if DEBUG
    static let shared = DependencyContainer(
        logger: Loggers.combined(loggers: [ConsoleLogger(), FileLogger.shared])
    )
#else
    static let shared = DependencyContainer(logger: NullLogger())
#endif
}
