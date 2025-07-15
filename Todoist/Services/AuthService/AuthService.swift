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
        with user: User,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        auth.createUser(
            withEmail: user.email, password: user.password) { result, error in
                if let error = error {
                    print("Auth error:", error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(true))
            }
    }
    
    func signIn(
        with user: User,
        completion: @escaping (Result<Bool, any Error>) -> Void
    ) {
        auth.signIn(withEmail: user.email, password: user.password) { result, error in
            if let error = error {
                print("Auth error:", error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            completion(.success(true))
        }
    }
}
