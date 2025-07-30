//
//  Extension+String.swift
//  Todoist
//
//  Created by Artem Kriukov on 02.07.2025.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let passwordRegEx = "^(?=.*[A-ZА-ЯЁ])(?=.*\\d).{6,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: self)
    }
    // минимум 6 символов,
    // содержит хотя бы одну цифру,
    // содержит хотя бы одну заглавную букву.
}
