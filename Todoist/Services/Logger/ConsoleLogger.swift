//
//  ConsoleLogger.swift
//  Todoist
//
//  Created by Artem Kriukov on 19.05.2025.
//

import Foundation

final class ConsoleLogger: Logger {
    func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
