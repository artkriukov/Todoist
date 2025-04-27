//
//  DefaultToDoItemsProvider.swift
//  Todoist
//
//  Created by Artem Kriukov on 20.04.2025.
//

import Foundation

final class DefaultToDoItemsProvider: ToDoItemsProvider {
    
    private var toDoItems: [ToDoItem] = []
    
    func getAllToDoItems() -> [ToDoItem] {
        toDoItems
    }

    func save(with item: ToDoItem) throws {
        toDoItems.append(item)
    }
}
