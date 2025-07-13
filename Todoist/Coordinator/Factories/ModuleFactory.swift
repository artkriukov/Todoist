//
//  ModuleFactory.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.07.2025.
//

import Foundation

final class ModuleFactory {
    func createWelcomeModule() -> WelcomeViewController {
        WelcomeViewController()
    }
    
    func createEmailLoginModule() -> AuthViewController {
        AuthViewController(mode: .signIn)
    }

    func createEmailRegistrationModule() -> AuthViewController {
        AuthViewController(mode: .signUp)
    }
    
    func createProfileInfoModule() -> ProfileSetupViewController {
        ProfileSetupViewController()
    }
}
