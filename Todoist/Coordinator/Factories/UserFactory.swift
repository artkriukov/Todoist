//
//  UserFactory.swift
//  Todoist
//
//  Created by Artem Kriukov on 14.07.2025.
//

import Foundation

struct UserFactory {
    
    static func makeLoginData(from draft: RegistrationData) -> User {
        guard let email = draft.email,
              let password = draft.password else {
            fatalError("Invalid user data")
        }
        
        return User(
            email: email,
            password: password,
            name: nil,
            userPhoto: nil
        )
    }
    
    static func makeAuthData(from draft: RegistrationData) -> User {
        guard let email = draft.email,
              let password = draft.password,
                let name = draft.name,
                let userPhoto = draft.userPhoto else {
            fatalError("Invalid user data")
        }
        
        return User(
            email: email,
            password: password,
            name: name,
            userPhoto: userPhoto
        )
    }
}
