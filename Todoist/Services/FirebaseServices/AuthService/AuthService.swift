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
    private let logger: Logger

    var isSignedIn: Bool { auth.currentUser != nil }
    
    init(logger: Logger = DependencyContainer.shared.logger) {
        self.logger = logger
    }
    
    func signUp(
          with user: User,
          completion: @escaping (Result<Bool, Error>) -> Void
        ) {
          auth.createUser(withEmail: user.email, password: user.password) { result, error in
            if let error = error {
              self.logger.log("Auth error: \(error.localizedDescription)")
              completion(.failure(error))
              return
            }
              
            completion(.success(true))

              guard let uid = result?.user.uid,
                    let name = user.name,
                    let photo = user.userPhoto
              else {
                  return
              }

            self.firestore
              .collection(FirebaseKeys.collectionMain)
              .document(uid)
              .setData([
                 "email": user.email,
                 "name": name,
                 "image": photo
              ]) { err in
                 if let err = err {
                   self.logger.log("Firestore save error: \(err)")
                 }
              }
          }
        }
    
    func signIn(
        with user: User,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        auth.signIn(withEmail: user.email, password: user.password) { result, error in
            if let error = error {
                self.logger.log("Auth error: \(error.localizedDescription)")
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
    
    func signOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(true))
        } catch {
            logger.log("Sign-out error: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}
