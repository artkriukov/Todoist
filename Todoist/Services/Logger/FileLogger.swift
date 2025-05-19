//
//  FileLogger.swift
//  Todoist
//
//  Created by Artem Kriukov on 19.05.2025.
//

import Foundation

final class FileLogger: Logger {
    static let shared = FileLogger()
    
    private let fileName = "applogs"
    private var fileURL: URL
    private var fileHandle: FileHandle?
    
    init() {
        guard let dataFilePath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            print(" -> [FileLogger] Documents directory not found.")
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
#if DEBUG
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
#endif
    }
    
    func getLogs() -> [String] {
#if DEBUG
        do {
            let content = try String(contentsOfFile: fileURL.path, encoding: .utf8)
            return content.components(separatedBy: .newlines)
        } catch {
            return []
        }
#else
        return []
#endif
    }
}
