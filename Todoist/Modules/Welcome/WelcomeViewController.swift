//
//  WelcomeViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 12.07.2025.
//

import UIKit

final class WelcomeViewController: UIViewController {
    var onSignIn: (() -> Void)?
    var onSignUp: (() -> Void)?
    
    // MARK: - UI

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Todoist"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var welcomeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.Images.welcomeImage
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 36
        imageView.layer.masksToBounds = true
        imageView.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 6)
        imageView.layer.shadowOpacity = 0.18
        imageView.layer.shadowRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = AuthStrings.authMotto.rawValue.localized()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stack = FactoryUI.shared.makeStackView(
            spacing: 20,
            backgroundColor: .clear
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

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

    // MARK: - Life Cycle

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
            secondaryActionTitle: AuthStrings.signUpWithEmail.rawValue.localized(),
            cancelActionTitle: GlobalStrings.cancel.rawValue.localized(),
            primaryAction: {
                self.onSignIn?()

            },
            secondaryAction: {
                self.onSignUp?()
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

// MARK: - Setup Views & Constraints

private extension WelcomeViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        view.addSubview(titleLabel)
        view.addSubview(welcomeImageView)
        view.addSubview(subtitleLabel)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(appleAuthButton)
        buttonsStackView.addArrangedSubview(googleAuthButton)
        buttonsStackView.addArrangedSubview(emailAuthButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 42),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            welcomeImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            welcomeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeImageView.widthAnchor.constraint(equalToConstant: 180),
            welcomeImageView.heightAnchor.constraint(equalToConstant: 180),

            subtitleLabel.topAnchor.constraint(equalTo: welcomeImageView.bottomAnchor, constant: 32),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            buttonsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 48),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
