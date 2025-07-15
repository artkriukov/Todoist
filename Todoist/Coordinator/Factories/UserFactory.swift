//
//  UserFactory.swift
//  Todoist
//
//  Created by Artem Kriukov on 14.07.2025.
//

import Foundation

struct UserFactory {
    static func makeUser(from draft: RegistrationData) -> User {
        guard let email = draft.email,
              let password = draft.password,
              let name = draft.name,
              let userPhoto = draft.userPhoto else {
            fatalError("Invalid user data")
        }
        
        return User(
            email: email,
            name: name,
            userPhoto: userPhoto,
            toDo: []
        )
    }
}
