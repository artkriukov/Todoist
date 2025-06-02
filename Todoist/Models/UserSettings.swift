//
//  UserModel.swift
//  Todoist
//
//  Created by Artem Kriukov on 27.04.2025.
//

import UIKit

enum SettingsKeys: String {
    case userName
    case userImage
}

struct UserSettings {
    let name: String
    let imageData: Data?
    
    var image: UIImage? {
        guard let imageData else { return nil }
        return UIImage(data: imageData)
    }
}

extension UserSettings: UserSettingsProvider {
    func save() {
        UserDefaults.standard.set(name, forKey: SettingsKeys.userName.rawValue)
        UserDefaults.standard
            .set(imageData, forKey: SettingsKeys.userImage.rawValue)
    }
    
    static func load() -> UserSettings? {
        guard let name = UserDefaults.standard.string(forKey: SettingsKeys.userName.rawValue) else {
            return nil
        }
        let imageData = UserDefaults.standard.data(forKey: SettingsKeys.userImage.rawValue)
        
        return UserSettings(name: name, imageData: imageData)
    }
}
