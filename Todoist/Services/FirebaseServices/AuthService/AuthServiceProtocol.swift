//
//  AuthServiceProtocol.swift
//  Todoist
//
//  Created by Artem Kriukov on 15.07.2025.
//

import Foundation

protocol AuthServiceProtocol {
    func signUp(with user: User,
                completion: @escaping (Result<Bool, Error>) -> Void)
    
        func signIn(with user: User,
                    completion: @escaping (Result<Bool, Error>) -> Void)
}
