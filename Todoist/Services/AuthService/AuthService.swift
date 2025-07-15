//
//  AuthService.swift
//  Todoist
//
//  Created by Artem Kriukov on 15.07.2025.
//

import FirebaseAuth
import Foundation

final class AuthService: AuthServiceProtocol {
    private let auth = Auth.auth()

    func signUp(
        userData: RegistrationData,
        completion: @escaping (Result<User, any Error>) -> Void
    ) {
            
    }
}
