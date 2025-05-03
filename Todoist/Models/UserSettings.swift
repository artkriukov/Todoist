//
//  UserModel.swift
//  Todoist
//
//  Created by Artem Kriukov on 27.04.2025.
//

import Foundation

enum SettingsKeys: String {
    case userName
}

struct UserSettings {
    let name: String
}

extension UserSettings: UserSettingsProvider {
    func save() {
        UserDefaults.standard.set(name, forKey: SettingsKeys.userName.rawValue)
    }
    
    static func load() -> UserSettings? {
        guard let name = UserDefaults.standard.string(forKey: SettingsKeys.userName.rawValue) else {
            return nil
        }
        return UserSettings(name: name)
    }
}
