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
    
    private var userDraft = UserDraft(
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
            self?.userDraft.email = email
            self?.userDraft.password = password
            self?.completionHandler?()
            print("Успешный вход")
            // проверка firebase - вход на aminVC
        }
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func showEmailRegistration() {
        let controller = moduleFactory.createEmailRegistrationModule()
        
        controller.completionHandler = { [weak self] email, password in
            self?.userDraft.email = email
            self?.userDraft.password = password
            self?.showProfileInfo()
        }
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func showProfileInfo() {
        let controller = moduleFactory.createProfileInfoModule()
        
        controller.completionHandler = { [weak self] name, userPhoto in
            self?.userDraft.name = name
            self?.userDraft.userPhoto = userPhoto
            self?.completionHandler?()
            // решистрация firebase - вход на aminVC
            print("Успешный вход")
        }
        
        navigationController.pushViewController(controller, animated: true)
    }
}
