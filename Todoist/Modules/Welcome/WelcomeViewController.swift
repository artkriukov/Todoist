//
//  WelcomeViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 12.07.2025.
//

import UIKit

final class WelcomeViewController: UIViewController {

    // MARK: - UI
    private lazy var buttonsStackView = FactoryUI.shared.makeStackView(
        spacing: 20,
        backgroundColor: .clear
    )
    
    private lazy var appleAuthButton: ActionButton = {
        let config = ActionButton.Configuration(
            title: AuthStrings.signInWithApple.rawValue.localized(),
            image: Asset.Images.authApple,
            backgroundColor: Asset.Colors.secondaryBackground,
            action: { [weak self] in
                self?.appleAuthButtonTapped()
            })
        let element = ActionButton(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var googleAuthButton: ActionButton = {
        let config = ActionButton.Configuration(
            title: AuthStrings.signInWithGoogle.rawValue.localized(),
            image: Asset.Images.authGoogle,
            backgroundColor: Asset.Colors.secondaryBackground,
            action: { [weak self] in
                self?.googleAuthButtonTapped()
            })
        let element = ActionButton(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var emailAuthButton: ActionButton = {
        let config = ActionButton.Configuration(
            title: AuthStrings.signInWithEmail.rawValue.localized(),
            image: Asset.Images.authMail,
            backgroundColor: Asset.Colors.secondaryBackground,
            action: { [weak self] in
                self?.mailAuthButtonTapped()
            })
        let element = ActionButton(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
    }
    
    // MARK: - Private Methods
    private func appleAuthButtonTapped() {
        print("appleAuthButtonTapped")
    }
    
    private func googleAuthButtonTapped() {
        print("googleAuthButtonTapped")
    }

    private func mailAuthButtonTapped() {
        let actionSheet = FactoryUI.shared.makeBottomAlert(
            alertTitle: nil,
            primaryActionTitle: AuthStrings.signInWithEmail.rawValue.localized(),
            secondaryActionTitle: AuthStrings.signUpWithEmail.rawValue
                .localized(),
            cancelActionTitle: GlobalStrings.cancel.rawValue.localized(),
            primaryAction: {
                self.openAuthVC(with: .signIn)
            },
            secondaryAction: {
                self.openAuthVC(with: .signUp)
            },
            cancelAction: {
                print("Отмена")
            }
        )
        present(actionSheet, animated: true)
    }
    
    private func openAuthVC(with mode: AuthMode) {
        let authVC = AuthViewController(mode: mode)
        let navVC = UINavigationController(rootViewController: authVC)
        self.present(navVC, animated: true)
    }
}

// MARK: - Setup Views & Setup Constraints
private extension WelcomeViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(appleAuthButton)
        buttonsStackView.addArrangedSubview(googleAuthButton)
        buttonsStackView.addArrangedSubview(emailAuthButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsStackView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -16)
            
        ])
    }
}
