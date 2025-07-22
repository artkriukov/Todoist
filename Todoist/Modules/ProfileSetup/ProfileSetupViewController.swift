//
//  ProfileSetupViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 12.07.2025.
//

import FirebaseAnalytics
import UIKit

final class ProfileSetupViewController: UIViewController, FlowController {
    var completionHandler: ((String, String) -> Void)?
    var onBack: (() -> Void)?
    
    // MARK: - UI
    private lazy var topInfoStackView: InfoHeaderView = {
        let config = InfoHeaderView.Configuration(
            title: ProfileStrings.welcomeTitle.rawValue.localized(),
            description: ProfileStrings.welcomeSubtitle.rawValue.localized()
        )
        let view = InfoHeaderView(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.layer.borderColor = Asset.Colors.secondaryBackground.cgColor
        element.layer.borderWidth = 1
        element.spacing = 20
        element.alignment = .center
        element.axis = .vertical
        element.layer.cornerRadius = 8
        element.isLayoutMarginsRelativeArrangement = true
        element.layoutMargins = UIEdgeInsets(top: 26, left: 0, bottom: 26, right: 0)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var profileLabel: UILabel = {
        let element = UILabel()
        element.font = Asset.CustomFont.medium(size: 17)
        element.text = ProfileStrings.yourProfile.rawValue.localized()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var imageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFill
        element.image = Asset.Images.defaultUserImage
        element.layer.cornerRadius = 50
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var uploadPhotoButton: ActionButton = {
        let config = ActionButton.Configuration(
            title: ProfileStrings.uploadPhoto.rawValue.localized(),
            image: Asset.Images.camera,
            backgroundColor: Asset.Colors.secondaryBackground,
            action: { [weak self] in
                self?.uploadPhotoButtonTapped()
            })
        let element = ActionButton(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var nameTextField: CustomInputField = {
        let config = CustomInputField.Configuration(
            title: ProfileStrings.yourName.rawValue.localized(),
            placeholder: ProfileStrings.yourName.rawValue.localized(),
            isSecure: false,
            keyboardType: .default
        )
        let element = CustomInputField(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actionButton: UIButton = {
        let element = FactoryUI.shared.makeStyledButton(
            title: AuthStrings.goToTask.rawValue.localized(),
            alignment: .center,
            backgroundColor: Asset.Colors.blueColor,
            contentInsets: .zero
        ) {
            self.actionButtonTapped()
        }
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupNavigationBar()
        
        Analytics.logEvent("screen_opened", parameters: [
            "screen_name": "profile"
        ])
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
    
    private func cancelButtonTapped() {
        onBack?()
    }
    
    private func uploadPhotoButtonTapped() {
        print("Hello World!")
    }
    
    private func actionButtonTapped() {
        guard let name = nameTextField.text else { return }
        completionHandler?(name, "image")
    }
}

// MARK: - Setup Views & Setup Constraints
private extension ProfileSetupViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        
        view.addSubview(topInfoStackView)
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(profileLabel)
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(uploadPhotoButton)
        mainStackView.addArrangedSubview(nameTextField)
        
        view.addSubview(actionButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topInfoStackView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            topInfoStackView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15),
            topInfoStackView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15),
            
            mainStackView.topAnchor
                .constraint(equalTo: topInfoStackView.bottomAnchor, constant: 45),
            mainStackView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -16),
            
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            uploadPhotoButton.leadingAnchor
                .constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            uploadPhotoButton.trailingAnchor
                .constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            
            nameTextField.leadingAnchor
                .constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor
                .constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            
            actionButton.topAnchor
                .constraint(equalTo: mainStackView.bottomAnchor, constant: 30),
            actionButton.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 16),
            actionButton.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
