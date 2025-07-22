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
        
        controller.completionHandler = { [weak self] email, password in
            self?.registrationData.email = email
            self?.registrationData.password = password
            guard let user = self?.registrationData else { return }
            self?.didCompleteAuth(with: user, authMode: .signIn)
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
            
            guard let user = self?.registrationData else { return }
            self?.didCompleteAuth(with: user, authMode: .signUp)
        }
        
        controller.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    //    private func showProfileInfo() {
    //        let controller = moduleFactory.createProfileInfoModule()
    //
    //        controller.completionHandler = { [weak self] name, userPhoto in
    //            self?.registrationData.name = name
    //            self?.registrationData.userPhoto = userPhoto
    //
    //            guard let user = self?.registrationData else { return }
    //            self?.didCompleteAuth(with: user, authMode: .signUp)
    //        }
    //
    //        controller.onBack = { [weak self] in
    //            self?.navigationController.popViewController(animated: true)
    //        }
    //
    //        navigationController.pushViewController(controller, animated: true)
    //    }
    
    private func didCompleteAuth(
      with user: RegistrationData,
      authMode: AuthMode
    ) {
      switch authMode {
      case .signIn:
        do {
          let user = try UserFactory.makeLoginData(from: user)
          authService.signIn(with: user) { [weak self] result in
            if case .success = result {
              self?.completionHandler?()
            }
          }
        } catch {
          logger.log("Validation error: \(error)")
        }

      case .signUp:
        do {
          let user = try UserFactory.makeLoginData(from: user)
          authService.signUp(with: user) { [weak self] result in
            if case .success = result {
              self?.completionHandler?()
            }
          }
        } catch {
          logger.log("Validation error: \(error)")
        }
      }
    }
}
