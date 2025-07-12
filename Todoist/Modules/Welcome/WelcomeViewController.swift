//
//  WelcomeViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 12.07.2025.
//

import UIKit

final class WelcomeViewController: UIViewController {

    private lazy var buttonsStackView = FactoryUI.shared.makeStackView(
        spacing: 20,
        backgroundColor: .clear
    )
    
    private lazy var appleAuthButton: AuthButton = {
        let config = AuthButton.Configuration(
            title: "Войти через Apple",
            image: Asset.Images.authApple,
            backgroundColor: Asset.Colors.secondaryBackground,
            action: { [weak self] in
                self?.emailButtonTapped()
            })
        let element = AuthButton(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var googleAuthButton: AuthButton = {
        let config = AuthButton.Configuration(
            title: "Войти через Google",
            image: Asset.Images.authGoogle,
            backgroundColor: Asset.Colors.secondaryBackground,
            action: { [weak self] in
                self?.emailButtonTapped()
            })
        let element = AuthButton(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var emailAuthButton: AuthButton = {
        let config = AuthButton.Configuration(
            title: "Продолжить через Email",
            image: Asset.Images.authMail,
            backgroundColor: Asset.Colors.secondaryBackground,
            action: { [weak self] in
                self?.emailButtonTapped()
            })
        let element = AuthButton(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
    }

    private func emailButtonTapped() {
        print(1)
    }
}

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
