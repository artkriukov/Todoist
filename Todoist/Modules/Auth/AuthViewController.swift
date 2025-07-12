//
//  AuthViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 12.07.2025.
//

import UIKit

final class AuthViewController: UIViewController {
    private let mode: AuthMode
    
    // MARK: - UI
    private lazy var topInfoStackView = FactoryUI.shared.makeStackView(
        spacing: 15,
        layoutMargins: .zero,
        backgroundColor: .clear
    )
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.font = Asset.CustomFont.medium(size: 24)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var descrLabel: UILabel = {
        let element = UILabel()
        element.font = Asset.CustomFont.regular(size: 17)
        element.text = AuthStrings.enterEmailAndPassword.rawValue.localized()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var inputFieldsStackView = FactoryUI.shared.makeStackView(
        spacing: 15,
        layoutMargins: .zero,
        backgroundColor: .clear
    )
    
    private lazy var emailTextField: CustomInputField = {
        let config = CustomInputField.Configuration(
            title: AuthStrings.emailTitle.rawValue.localized(),
            placeholder: "Email",
            isSecure: false,
            keyboardType: .emailAddress
        )
        let element = CustomInputField(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var passwordTextField: CustomInputField = {
        let config = CustomInputField.Configuration(
            title: AuthStrings.passwordTitle.rawValue.localized(),
            placeholder: AuthStrings.passwordShort.rawValue.localized(),
            isSecure: true,
            keyboardType: .default
        )
        let element = CustomInputField(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actionButton: UIButton = {
        let element = FactoryUI.shared.makeStyledButton(
            alignment: .center,
            backgroundColor: Asset.Colors.blueColor,
            contentInsets: .zero
        ) {
            self.actionButtonTapped()
        }
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Init
    init(mode: AuthMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureViewController(with: mode)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: GlobalStrings.back.rawValue.localized(),
            primaryAction: UIAction { [weak self] _ in
                self?.cancelButtonTapped()
            }
        )
    }
    
    private func configureViewController(with mode: AuthMode) {
        let signInString = AuthStrings.signIn.rawValue.localized()
        let signUpString = AuthStrings.signUp.rawValue.localized()
        
        switch mode {
        case .signIn:
            titleLabel.text = signInString
            actionButton.setTitle(signInString, for: .normal)
        case .signUp:
            titleLabel.text = signUpString
            actionButton.setTitle(signUpString, for: .normal)
        }
    }
    
    private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func actionButtonTapped() {
        
    }
}

// MARK: - Setup Views & Setup Constraints
private extension AuthViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        view.addSubview(topInfoStackView)
        
        topInfoStackView.addArrangedSubview(titleLabel)
        topInfoStackView.addArrangedSubview(descrLabel)
        
        view.addSubview(inputFieldsStackView)
        inputFieldsStackView.addArrangedSubview(emailTextField)
        inputFieldsStackView.addArrangedSubview(passwordTextField)
        inputFieldsStackView.addArrangedSubview(actionButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topInfoStackView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            topInfoStackView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15),
            topInfoStackView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15),
            
            inputFieldsStackView.topAnchor
                .constraint(equalTo: topInfoStackView.bottomAnchor, constant: 40),
            inputFieldsStackView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 16),
            inputFieldsStackView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -16),
            
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
