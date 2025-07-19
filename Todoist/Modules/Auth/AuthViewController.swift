//
//  AuthViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 12.07.2025.
//

import UIKit

final class AuthViewController: UIViewController, FlowController {

    // MARK: - Private Properties
    private let mode: AuthMode
    
    // MARK: - Public Properties
    var completionHandler: ((String, String) -> Void)?
    var onBack: (() -> Void)?
    
    // MARK: - UI
    
    private lazy var topInfoStackView: InfoHeaderView = {
        let config = InfoHeaderView.Configuration(
            title: AuthStrings.signIn.rawValue.localized(),
            description: AuthStrings.enterEmailAndPassword.rawValue.localized()
        )
        let view = InfoHeaderView(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        setupNavigationBar()
    }
    
    // MARK: - Private Methods
    private func setupNavigationBar() {
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
            topInfoStackView.title = signInString
            actionButton.setTitle(signInString, for: .normal)
        case .signUp:
            topInfoStackView.title = signUpString
            actionButton.setTitle(signUpString, for: .normal)
        }
    }
    
    private func cancelButtonTapped() {
        onBack?()
    }
    
    private func actionButtonTapped() {
        let isEmailValid = validateEmail()
        let isPasswordValid = validatePassword()
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        if isEmailValid && isPasswordValid {
            switch mode {
            case .signIn:
                completionHandler?(email, password)
            case .signUp:
                print("\(email) \(password)")
                completionHandler?(email, password)
            }
        } else {
            print("Bad info")
        }
    }
    
    private func validateEmail() -> Bool {
        if let email = emailTextField.text,
           !email.isEmpty,
           email.isValidEmail() {
            print("Good")
            UIView.animate(withDuration: 0.3) {
                self.emailTextField.hideWarning()
            }
            return true
        } else {
            UIView.animate(withDuration: 0.3) {
                self.emailTextField.showWarning(
                    GlobalStrings.invalidEmail.rawValue.localized()
                )
            }
            return false
        }
    }
    
    private func validatePassword() -> Bool {
        if let psw = passwordTextField.text,
           !psw.isEmpty,
           psw.isValidPassword() {
            print("Good")
            UIView.animate(withDuration: 0.3) {
                self.passwordTextField.hideWarning()
            }
            return true
        } else {
            UIView.animate(withDuration: 0.3) {
                self.passwordTextField.showWarning(
                    GlobalStrings.passwordRequirements.rawValue.localized()
                )
            }
            return false
        }
    }
}

// MARK: - Setup Views & Setup Constraints
private extension AuthViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        view.addSubview(topInfoStackView)
        
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
