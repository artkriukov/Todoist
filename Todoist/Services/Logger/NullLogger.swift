//
//  NullLogger.swift
//  Todoist
//
//  Created by Artem Kriukov on 19.05.2025.
//

import Foundation

final class NullLogger: Logger {
    func log(_ message: String) { }
}
