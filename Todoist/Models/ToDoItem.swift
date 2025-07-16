//
//  ToDoItem.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit

struct ToDoItem: Codable {
    var id: String = UUID().uuidString
    let title: String
    let description: String?
    let expirationDate: Date?
    let selectedImage: Data?
}
