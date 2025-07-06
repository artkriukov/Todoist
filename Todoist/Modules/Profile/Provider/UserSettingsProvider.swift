//
//  UserSettingsProvider.swift
//  Todoist
//
//  Created by Artem Kriukov on 28.04.2025.
//

import Foundation

protocol ProfileProvider {
    func save()
    static func load() -> UserSettings?
}
