//
//  AuthService.swift
//  Todoist
//
//  Created by Artem Kriukov on 15.07.2025.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

final class AuthService: AuthServiceProtocol {
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()

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
                
                guard let uid = result?.user.uid else { return }
                
                self.setUserData(user: user, userId: uid) { isAdd in
                    if isAdd {
                        completion(.success(true))
                    }
                    return
                }
            }
    }
    
    func signIn(
        with user: User,
        completion: @escaping (Result<Bool, Error>) -> Void
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
    
    private func setUserData(
        user: User,
        userId: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let userPhoto = user.userPhoto else { return }
        
        firestore
            .collection(FirebaseKeys.collectionMain)
            .document(userId)
            .setData([
                "name": user.name,
                "email": user.email,
                "image": userPhoto
            ]) { error in
                guard error == nil else {
                    completion(false)
                    return
                }
                
                completion(true)
            }
    }
}
