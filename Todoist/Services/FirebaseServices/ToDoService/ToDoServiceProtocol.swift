//
//  ToDoServiceProtocol.swift
//  Todoist
//
//  Created by Artem Kriukov on 19.07.2025.
//

import Foundation

protocol ToDoServiceProtocol {
    func createToDo(toDo: ToDoItem, completion: @escaping (Bool) -> Void)
    func getAllToDo(completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    func deleteToDo(id: String, completion: @escaping (Result<Void, Error>) -> Void)
}
