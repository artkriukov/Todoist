//
//  UserModel.swift
//  Todoist
//
//  Created by Artem Kriukov on 27.04.2025.
//

import UIKit

enum UserInfoKeys: String {
    case userName
    case userImage
}

struct UserInfo {
    let name: String
    let imageData: Data?
    
    var image: UIImage? {
        guard let imageData else { return nil }
        return UIImage(data: imageData)
    }
}

extension UserInfo: ProfileProvider {
    func save() {
        UserDefaults.standard.set(name, forKey: UserInfoKeys.userName.rawValue)
        UserDefaults.standard
            .set(imageData, forKey: UserInfoKeys.userImage.rawValue)
    }
    
    static func load() -> UserInfo? {
        guard let name = UserDefaults.standard.string(forKey: UserInfoKeys.userName.rawValue) else {
            return nil
        }
        let imageData = UserDefaults.standard.data(forKey: UserInfoKeys.userImage.rawValue)
        
        return UserInfo(name: name, imageData: imageData)
    }
}
