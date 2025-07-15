//
//  User.swift
//  Todoist
//
//  Created by Artem Kriukov on 14.07.2025.
//

import Foundation

struct User {
    let email: String
    let password: String
    let name: String? = nil
    let userPhoto: String? = nil
    let toDo: [ToDoItem]? = nil
}
