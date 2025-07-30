//
//  ToDoService.swift
//  Todoist
//
//  Created by Artem Kriukov on 16.07.2025.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

final class ToDoService: ToDoServiceProtocol {
    private let uid = Auth.auth().currentUser?.uid
    private let firestore = Firestore.firestore()
    
    func createToDo(toDo: ToDoItem, completion: @escaping (Bool) -> Void) {
        guard let uid else { return }
        
        firestore
            .collection(FirebaseKeys.collectionMain)
            .document(uid)
            .collection(FirebaseKeys.collectionToDo)
            .document(toDo.id)
            .setData([
                FirebaseToDoKeys.title: toDo.title,
                FirebaseToDoKeys.description: toDo.description ?? "",
                FirebaseToDoKeys.expirationDate: toDo.expirationDate ?? nil,
                FirebaseToDoKeys.selectedImage: toDo.selectedImage ?? ""
            ]) { err in
                guard err == nil else { return }
                completion(true)
            }
    }
    
    func getAllToDo(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        guard let uid else { return }
        
        firestore
            .collection(FirebaseKeys.collectionMain)
            .document(uid)
            .collection(FirebaseKeys.collectionToDo)
            .getDocuments { snapshot, err in
                guard err == nil else {
                    return
                }
                guard let docs = snapshot?.documents else { return }
                
                var toDos = [ToDoItem]()
                docs.forEach { doc in
                    let title = doc[FirebaseToDoKeys.title] as? String
                    let description = doc[FirebaseToDoKeys.description] as? String
                    let dateStamp = doc[FirebaseToDoKeys.expirationDate] as? Timestamp
                    let date = dateStamp?.dateValue()
                    _ = doc[FirebaseToDoKeys.selectedImage] as? String
                    
                    let todo = ToDoItem(
                        title: title ?? "",
                        description: description,
                        expirationDate: date,
                        selectedImage: nil
                    )
                    
                    toDos.append(todo)
                }
                
                completion(.success(toDos))
            }
    }
    
    func deleteToDo(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid else {
            completion(.failure(URLError(.userAuthenticationRequired)))
            return
        }
        
        firestore.collection(FirebaseKeys.collectionMain)
            .document(uid)
            .collection(FirebaseKeys.collectionToDo)
            .document(id)
            .delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
}
