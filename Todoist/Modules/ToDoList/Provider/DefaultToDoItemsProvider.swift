//
//  DefaultToDoItemsProvider.swift
//  Todoist
//
//  Created by Artem Kriukov on 20.04.2025.
//

import Foundation

final class DefaultToDoItemsProvider: ToDoItemsProvider {
    
    private var toDoItems: [ToDoItem] = []
    
    private let dataFilePath: URL = {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first ?? fileManager.temporaryDirectory
        return directory.appendingPathComponent("ToDoItems.plist")
    }()

    func getAllToDoItems() -> [ToDoItem] {

        if let jsonData = try? Data(contentsOf: dataFilePath) {
            let decoder = PropertyListDecoder()
            
            do {
                toDoItems = try decoder.decode([ToDoItem].self, from: jsonData)
                return toDoItems
            } catch {
                assertionFailure("Error decoding items: \(error)")
                return []
            }
        }
        return toDoItems
    }

    func save(with item: ToDoItem) throws {
        toDoItems.append(item)
        
        encodingData()
    }
    
    func removeItem(at index: Int) {
        guard index < toDoItems.count  else { return }
        
        toDoItems.remove(at: index)
        encodingData()
    }
    
    private func encodingData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(toDoItems)
            try data.write(to: dataFilePath)
        } catch {
            assertionFailure("Error encoding items: \(error)")
        }
    }
}
