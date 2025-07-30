//
//  AuthCoordinator.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.07.2025.
//

import FirebaseAnalytics
import FirebaseAuth
import UIKit

final class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    var completionHandler: CoordinatorHandler?
    
    private let moduleFactory: ModuleFactory
    private let authService: AuthServiceProtocol
    private let logger: Logger
    
    // Данные для регистрации/логина
    private var registrationData = RegistrationData(email: nil, password: nil)
    
    init(
        navigationController: UINavigationController,
        authService: AuthServiceProtocol,
        logger: Logger,
        moduleFactory: ModuleFactory
    ) {
        self.navigationController = navigationController
        self.authService = authService
        self.logger = logger
        self.moduleFactory = moduleFactory
    }
    
    func start() {
        showWelcome()
    }
    
    // MARK: Навигация
    
    func showWelcome() {
        let controller = moduleFactory.createWelcomeModule()
        controller.onSignIn = { [weak self] in self?.showEmailLogin() }
        controller.onSignUp = { [weak self] in self?.showEmailRegistration() }
        navigationController.setViewControllers([controller], animated: false)
    }
    
    func showEmailLogin() {
        let controller = moduleFactory.createEmailLoginModule()
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showEmailRegistration() {
        let controller = moduleFactory.createEmailRegistrationModule()
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }
}

// MARK: - AuthViewControllerDelegate

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
        case .signIn: performSignIn(with: userData)
        case .signUp: performSignUp(with: userData, from: controller)
        }
    }
    
    func authViewControllerDidTapBack(_ controller: AuthViewController) {
        navigationController.popViewController(animated: true)
    }
    
    func authViewController(_ controller: AuthViewController, didEncounterError error: Error) {
        if isEmailAlreadyRegisteredError(error) {
            showEmailAlreadyExistsAlert()
        } else if isMalformedOrExpiredCredential(error) {
            showMalformedOrExpiredCredentialAlert()
        } else {
            showGenericErrorAlert(message: error.localizedDescription)
            logger.log("Auth error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Бизнес обработка
    
    private func performSignIn(with userData: RegistrationData) {
        do {
            let user = try UserFactory.makeLoginData(from: userData)
            authService.signIn(with: user) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        self.completionHandler?()
                        Analytics.logEvent("sign_in_success", parameters: ["method": "email"])
                    case .failure(let error):
                        if self.isInvalidLoginOrPasswordError(error) {
                            self.showInvalidLoginOrPasswordAlert()
                        } else if self.isMalformedOrExpiredCredential(error) {
                            self.showMalformedOrExpiredCredentialAlert()
                        } else {
                            self.logger.log("Sign-In error: \(error.localizedDescription)")
                            self.showGenericErrorAlert(message: error.localizedDescription)
                        }
                    }
                }
            }
        } catch {
            logger.log("Validation error: \(error)")
            self.showGenericErrorAlert(message: "Ошибка валидации данных.")
        }
    }
    
    private func performSignUp(with userData: RegistrationData, from controller: AuthViewController) {
        do {
            let user = try UserFactory.makeLoginData(from: userData)
            authService.signUp(with: user) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        self.completionHandler?()
                        Analytics.logEvent("sign_up_success", parameters: ["method": "email"])
                    case .failure(let error):
                        self.authViewController(controller, didEncounterError: error)
                    }
                }
            }
        } catch {
            logger.log("Validation error: \(error)")
            self.showGenericErrorAlert(message: "Ошибка валидации данных.")
        }
    }
    
    // MARK: - Ошибки
    
    private func isEmailAlreadyRegisteredError(_ error: Error) -> Bool {
        let nsError = error as NSError
        if let code = AuthErrorCode.Code(rawValue: nsError.code) {
            return code == .emailAlreadyInUse
        }
        return false
    }
    
    private func isInvalidLoginOrPasswordError(_ error: Error) -> Bool {
        let nsError = error as NSError
        if let code = AuthErrorCode.Code(rawValue: nsError.code) {
            return code == .wrongPassword || code == .userNotFound
        }
        return false
    }

    private func isMalformedOrExpiredCredential(_ error: Error) -> Bool {
        let nsError = error as NSError
        if let code = AuthErrorCode.Code(rawValue: nsError.code) {
            return code == .invalidCredential || code == .invalidEmail
        }
        return false
    }
    
    // MARK: - Alerts
    
    private func showEmailAlreadyExistsAlert() {
        let alert = UIAlertController(
            title: "Регистрация невозможна",
            message: "Пользователь с такой почтой уже зарегистрирован.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.topViewController?.present(alert, animated: true)
    }
    
    private func showInvalidLoginOrPasswordAlert() {
        let alert = UIAlertController(
            title: "Ошибка входа",
            message: "Введён неверный логин или пароль.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.topViewController?.present(alert, animated: true)
    }
    
    private func showMalformedOrExpiredCredentialAlert() {
        let alert = UIAlertController(
            title: "Ошибка авторизации",
            message: "Недействительные или устаревшие данные для входа. Пожалуйста, проверьте e-mail и пароль и попробуйте снова.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.topViewController?.present(alert, animated: true)
    }
    
    private func showGenericErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.topViewController?.present(alert, animated: true)
    }
}
