//
//  AuthCoordinator.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.07.2025.
//

import FirebaseAnalytics
import UIKit

final class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    var completionHandler: CoordinatorHandler?
    
    private let moduleFactory = ModuleFactory()
    private let authService: AuthServiceProtocol
    private let logger: Logger
    
    private var registrationData = RegistrationData(
        email: nil,
        password: nil
    )
    
    init(navigationController: UINavigationController,
         authService: AuthServiceProtocol = AuthService(),
         logger: Logger = DependencyContainer.shared.logger
    ) {
        self.navigationController = navigationController
        self.authService = authService
        self.logger = logger
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
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func showEmailRegistration() {
        let controller = moduleFactory.createEmailRegistrationModule()
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }
    
}

extension AuthCoordinator: AuthViewControllerDelegate {
    func authViewController(
        _ controller: AuthViewController,
        didAuthenticateWith email: String,
        password: String,
        mode: AuthMode
    ) {
        registrationData.email = email
        registrationData.password = password
        let userData = registrationData
        
        switch mode {
        case .signIn:
            performSignIn(with: userData)
        case .signUp:
            performSignUp(with: userData)
        }
    }

    private func performSignIn(with userData: RegistrationData) {
        do {
            let user = try UserFactory.makeLoginData(from: userData)
            authService.signIn(with: user) { [weak self] result in
                switch result {
                case .success:
                    self?.completionHandler?()
                    Analytics.logEvent("sign_in_success", parameters: ["method": "email"])
                case .failure(let error):
                    self?.logger.log("Sign-In error: \(error)")
                }
            }
        } catch {
            logger.log("Validation error: \(error)")
        }
    }

    private func performSignUp(with userData: RegistrationData) {
        do {
            let user = try UserFactory.makeLoginData(from: userData)
            authService.signUp(with: user) { [weak self] result in
                switch result {
                case .success:
                    self?.completionHandler?()
                    Analytics.logEvent("sign_up_success", parameters: ["method": "email"])
                case .failure(let error):
                    self?.logger.log("Sign-Up error: \(error)")
                }
            }
        } catch {
            logger.log("Validation error: \(error)")
        }
    }
    
    func authViewControllerDidTapBack(_ controller: AuthViewController) {
        navigationController.popViewController(animated: true)
    }
}
