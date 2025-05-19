//
//  Loggers+Combined.swift
//  Todoist
//
//  Created by Artem Kriukov on 19.05.2025.
//

import Foundation

enum Loggers {}

extension Loggers {
    static func combined(loggers: [Logger]) -> Logger {
#if DEBUG
        return CombinedLogger(loggers: loggers)
#else
        return NullLogger()
#endif
    }
}

final class CombinedLogger: Logger {
    let loggers: [Logger]
    
    init(loggers: [Logger]) {
        self.loggers = loggers
    }
    
    func log(_ message: String) {
        loggers.forEach { $0.log(message) }
    }
}
