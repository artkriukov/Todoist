//
//  UserFactory.swift
//  Todoist
//
//  Created by Artem Kriukov on 14.07.2025.
//

import Foundation

struct UserFactory {
    
    static func makeLoginData(from draft: RegistrationData) throws -> User {
        let (email, pwd) = try draft.validate()
        return User(email: email, password: pwd, name: nil, userPhoto: nil)
    }
    
    static func makeAuthData(from draft: RegistrationData) throws -> User {
        let (email, pwd) = try draft.validate()
        
        guard let name = draft.name,
              let userPhoto = draft.userPhoto else {
            throw AuthError.emptyEmail         
        }
        
        return User(email: email, password: pwd, name: name, userPhoto: userPhoto)
    }
}
