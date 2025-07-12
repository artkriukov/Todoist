//
//  SettingsViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 27.04.2025.
//

import UIKit

final class UserSettingsViewController: UIViewController {
    
    private let logger: Logger
    
    // MARK: - UI
    
    private lazy var userImageStackView = FactoryUI.shared.makeStackView(
        axis: .vertical,
        spacing: 10,
        backgroundColor: .clear
    )
    
    private lazy var userImage: UIImageView = {
        let element = UIImageView()
        element.image = Asset.Images.defaultUserImage
        element.tintColor = .gray
        element.layer.cornerRadius = 60
        element.clipsToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var changeUserImageButton: UIButton = {
        let element = UIButton(type: .system)
        element
            .setTitle(
                ProfileStrings.changePhoto.rawValue.localized(),
                for: .normal
            )
        element.addAction(
            UIAction { _ in
                self.changeUserImageButtonTapped()
            }, for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var userInfoStackView = FactoryUI.shared.makeStackView(
        axis: .horizontal,
        spacing: 5,
        layoutMargins: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    )
    
    private lazy var userStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 8
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var nameLabel: UILabel = {
        let element = UILabel()
        element.text = GlobalStrings.name.rawValue.localized()
        element.font = Asset.CustomFont.medium(size: 17)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    private lazy var userNameTextField: UITextField = {
        let element = UITextField()
        element.placeholder = ProfileStrings.yourName.rawValue.localized()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var saveButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle(GlobalStrings.save.rawValue.localized(), for: .normal)
        element.addAction(UIAction { [weak self] _ in
            self?.saveButtonTapped()
        },
                          for: .touchUpInside)
        element.backgroundColor = Asset.Colors.blueColor
        element.tintColor = .white
        element.layer.cornerRadius = 10
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var logsButton: UIButton = {
        let element = FactoryUI.shared.makeStyledButton(
            title: "Посмотреть логи",
            backgroundColor: Asset.Colors.secondaryBackground
        ) {
            self.logsButtonTapped()
        }
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Init
    
    init(logger: Logger = DependencyContainer.shared.logger) {
        self.logger = logger
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logger.log("UserSettingsViewController loaded")
        
        setupViews()
        setupConstraints()
        
        loadDataFromUserDefoults()
    }
    
    // MARK: - Private Methods
    
    private func changeUserImageButtonTapped() {
        let actionSheet = FactoryUI.shared.makeBottomAlert(
            alertTitle: ProfileStrings.changePhoto.rawValue.localized(),
            primaryActionTitle: ProfileStrings.selectFromGallery.rawValue.localized(),
            secondaryActionTitle: nil,
            cancelActionTitle: GlobalStrings.cancel.rawValue.localized(),
            primaryAction: { [weak self] in
                guard let self else { return }
                let imagePicker = self.createImagePickerController()
                self.present(imagePicker, animated: true)
            },
            secondaryAction: {
                print("onUnsplashTap")
            }

        )
        present(actionSheet, animated: true)
    }
    
    private func loadDataFromUserDefoults() {
        let userSettings = UserSettings.load()
        userNameTextField.text = userSettings?.name
        
        if let image = userSettings?.image {
            userImage.image = image
        } else {
            userImage.image = Asset.Images.defaultUserImage
        }
    }
    
    private func saveButtonTapped() {
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            return
        }
        
        let imageData = userImage.image?.jpegData(compressionQuality: 0.8)
        
        let userSettings = UserSettings(name: userName, imageData: imageData)
        userSettings.save()
    }
    
    private func logsButtonTapped() {
        let logsVC = LogsViewController()
        let navController = UINavigationController(rootViewController: logsVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    private func createImagePickerController() -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        return imagePickerController
    }
}

extension UserSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[.editedImage] as? UIImage {
            userImage.image = image
        } else if let image = info[.originalImage] as? UIImage {
            userImage.image = image
        }
        
        dismiss(animated: true)
    }
}

private extension UserSettingsViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        
        view.addSubview(userImageStackView)
        userImageStackView.addArrangedSubview(userImage)
        userImageStackView.addArrangedSubview(changeUserImageButton)
        
        view.addSubview(userInfoStackView)
        
        userInfoStackView.addArrangedSubview(nameLabel)
        userInfoStackView.addArrangedSubview(userNameTextField)
        view.addSubview(saveButton)
        
        view.addSubview(logsButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            userImageStackView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            userImageStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userImage.heightAnchor.constraint(equalToConstant: 120),
            userImage.widthAnchor.constraint(equalToConstant: 120),
            
            userInfoStackView.topAnchor
                .constraint(equalTo: userImageStackView.bottomAnchor, constant: 15),
            userInfoStackView.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            userInfoStackView.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            nameLabel.widthAnchor.constraint(equalToConstant: 60),
            
            saveButton.topAnchor
                .constraint(equalTo: userInfoStackView.bottomAnchor, constant: 10),
            saveButton.widthAnchor.constraint(equalToConstant: 120),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveButton.widthAnchor.constraint(equalToConstant: 120),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            
            logsButton.topAnchor
                .constraint(equalTo: saveButton.bottomAnchor, constant: 50),
            logsButton.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15),
            logsButton.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15),
            logsButton.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
}
