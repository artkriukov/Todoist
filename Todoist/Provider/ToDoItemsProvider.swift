//
//  ToDoItemsProvider.swift
//  Todoist
//
//  Created by Artem Kriukov on 20.04.2025.
//

import Foundation

protocol ToDoItemsProvider {
    func getAllToDoItems() -> [ToDoItem]
    func save(with item: ToDoItem) throws
}
