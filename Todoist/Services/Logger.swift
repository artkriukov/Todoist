//
//  Logger.swift
//  Todoist
//
//  Created by Artem Kriukov on 12.05.2025.
//

import Foundation

protocol Logger {
    func log(_ message: String)
}

let logger = CombinedLogger(
    loggers: [
        ConsoleLogger(),
        FileLogger()
    ]
)

final class ConsoleLogger: Logger {
    func log(_ message: String) {
        print(message)
    }
}

final class FileLogger: Logger {
    static let shared = FileLogger()
    
    private let fileName = "applogs"
    private var fileURL: URL
    private var fileHandle: FileHandle?
    
    init() {
        guard let dataFilePath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first
        else {
            logger.log(" -> [FileLogger] Documents directory not found.")
            fatalError("Documents directory not found.")
        }
        
        fileURL = dataFilePath.appendingPathComponent(fileName)
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil)
        }
        
        do {
            fileHandle = try FileHandle(forWritingTo: fileURL)
            try fileHandle?.seekToEnd()
        } catch {
            print("Failed to initialize FileHandle: \(error)")
            fileHandle = nil
        }
    }
    
    func log(_ message: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = dateFormatter.string(from: Date())
        
        let logMessage = "\(timestamp): \(message)\n"
        guard let data = logMessage.data(using: .utf8) else { return }
        
        do {
            try fileHandle?.write(contentsOf: data)
        } catch {
            print("Failed to write log: \(error)")
        }
    }
    
    func getLogs() -> [String] {
        do {
            let content = try String(contentsOfFile: fileURL.path, encoding: .utf8)
            return content.components(separatedBy: .newlines)
        } catch {
            return []
        }
    }
}

final class CombinedLogger: Logger {
    private let loggers: [Logger]
    
    init(loggers: [Logger]) {
        self.loggers = loggers
    }
    
    func log(_ message: String) {
        loggers.forEach { $0.log(message) }
    }
}
