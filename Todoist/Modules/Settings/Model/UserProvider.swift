//
//  UserProvider.swift
//  Todoist
//
//  Created by Artem Kriukov on 28.04.2025.
//

import Foundation

protocol UserProvider {
    func save()
    static func load() -> UserSettings?
}
