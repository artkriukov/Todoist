//
//  AuthCoordinator.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.07.2025.
//

import UIKit

final class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    var completionHandler: CoordinatorHandler?
    
    private let moduleFactory = ModuleFactory()
    private let authService: AuthServiceProtocol
    private var registrationData = RegistrationData(
        email: nil,
        password: nil,
        name: nil,
        userPhoto: nil
    )
    
    init(navigationController: UINavigationController,
         authService: AuthServiceProtocol = AuthService()
    ) {
        self.navigationController = navigationController
        self.authService = authService
    }
    
    func start() {
        showWelcome()
    }
    
    // welcome
    private func showWelcome() {
        let controller = moduleFactory.createWelcomeModule()
        
        controller.onSignIn = { [weak self] in
            self?.showEmailLogin()
        }
        
        controller.onSignUp = { [weak self] in
            self?.showEmailRegistration()
        }
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    // login
    private func showEmailLogin() {
        let controller = moduleFactory.createEmailLoginModule()
        
        controller.completionHandler = { [weak self] email, password in
            self?.registrationData.email = email
            self?.registrationData.password = password
            guard let user = self?.registrationData else { return }
            self?.didCompleteAuth(with: user, authMode: .signIn)
            print("Успешный вход")
            // проверка firebase - вход на aminVC
        }
        
        controller.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func showEmailRegistration() {
        let controller = moduleFactory.createEmailRegistrationModule()
        
        controller.completionHandler = { [weak self] email, password in
            self?.registrationData.email = email
            self?.registrationData.password = password
            self?.showProfileInfo()
        }
        
        controller.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func showProfileInfo() {
        let controller = moduleFactory.createProfileInfoModule()
        
        controller.completionHandler = { [weak self] name, userPhoto in
            self?.registrationData.name = name
            self?.registrationData.userPhoto = userPhoto
            
            guard let user = self?.registrationData else { return }
            self?.didCompleteAuth(with: user, authMode: .signUp)
            
            print("Успешный вход")
        }
        
        controller.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func didCompleteAuth(
            with user: RegistrationData,
            authMode: AuthMode
    ) {
        switch authMode {
        case .signIn:
            do {
                let loginUser = try UserFactory.makeLoginData(from: registrationData)
                authService.signIn(with: loginUser) { [weak self] result in
                    switch result {
                    case .success: self?.completionHandler?()
                    case .failure(let error):  print("Sign-in error:", error)
                    }
                }
            } catch {
                print("❌ Validation error:", error.localizedDescription)
            }
            
        case .signUp:
            do {
                let newUser = try UserFactory.makeAuthData(from: registrationData)
                authService.signUp(with: newUser) { [weak self] result in
                    switch result {
                    case .success: self?.completionHandler?()
                    case .failure(let error): print("Sign-up error:", error)
                    }
                }
            } catch {
                print("❌ Validation error:", error.localizedDescription)
            }
        }
    }
}
