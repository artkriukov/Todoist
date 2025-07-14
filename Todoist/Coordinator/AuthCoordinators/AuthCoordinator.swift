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

    private var registrationData = RegistrationData(
        email: nil,
        password: nil,
        name: nil,
        userPhoto: nil
    )
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showWelcome()
    }
    
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
    
    private func showEmailLogin() {
        let controller = moduleFactory.createEmailLoginModule()
        
        controller.completionHandler = { [weak self] email, password in
            self?.registrationData.email = email
            self?.registrationData.password = password
            self?.completionHandler?()
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
            self?.completionHandler?()
            print("Успешный вход")
        }
        
        controller.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(controller, animated: true)
    }
}
