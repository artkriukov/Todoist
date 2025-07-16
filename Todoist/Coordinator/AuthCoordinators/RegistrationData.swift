//
//  RegistrationData.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.07.2025.
//

import Foundation

struct RegistrationData {
    var email: String?
    var password: String?
    var name: String?
    var userPhoto: String?
}

extension RegistrationData {
    func validate() throws -> (email: String, password: String) {
        
        guard let rawMail = email?
                .trimmingCharacters(in: .whitespacesAndNewlines),
              !rawMail.isEmpty else { throw AuthError.emptyEmail }
        
        guard rawMail.contains("@") else { throw AuthError.invalidEmailFormat }
        
        guard let pwd = password else { throw AuthError.emptyPassword }
        guard pwd.count >= 6 else { throw AuthError.weakPassword }
        
        return (rawMail, pwd)
    }
}

enum AuthError: LocalizedError {
    case emptyEmail
    case invalidEmailFormat
    case weakPassword
    case emptyPassword
    
    var errorDescription: String? {
        switch self {
        case .emptyEmail:          return "E-mail не указан."
        case .invalidEmailFormat:  return "Некорректный e-mail."
        case .weakPassword:        return "Пароль должен быть не короче 6 символов."
        case .emptyPassword:       return "Пароль не указан."
        }
    }
}
