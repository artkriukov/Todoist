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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? container.decode(String.self, forKey: .id)) ?? UUID().uuidString
        title = try container.decode(String.self, forKey: .title)
        description = try? container.decode(String.self, forKey: .description)
        expirationDate = try? container.decode(Date.self, forKey: .expirationDate)
        selectedImage = try? container.decode(Data.self, forKey: .selectedImage)
    }

    init(
        title: String,
        description: String? = nil,
        expirationDate: Date? = nil,
        selectedImage: Data? = nil
    ) {
        self.id = UUID().uuidString
        self.title = title
        self.description = description
        self.expirationDate = expirationDate
        self.selectedImage = selectedImage
    }
}
