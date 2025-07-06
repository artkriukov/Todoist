//
//  UserProfileViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 27.04.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let logger: Logger
    
    // MARK: - UI
    
    private lazy var profileHeader: ProfileHeaderControl = {
        let config = ProfileHeaderControl.Configuration(
            image: Asset.Images.defaultUserImage,
            name: "Artem Kriukov",
            tasks: nil,
            action: { [weak self] in
                self?.openProfileDetails()
            }
        )
        let element = ProfileHeaderControl(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var rightBarButtonItem: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(Asset.Images.settings, for: .normal)
        element.tintColor = .black
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
//    private lazy var logsButton: UIButton = {
//        
//        let element = FactoryUI.shared.makeStyledButton(
//            title: ProfileStrings.systemLogs.rawValue.localized()) {
//                self.logsButtonTapped()
//            }
//        
//        element.translatesAutoresizingMaskIntoConstraints = false
//        return element
//    }()
    
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonItem)
    }
    
    // MARK: - Private Methods
    
    private func openProfileDetails() {
        print("openProfileDetails")
    }
    
//    private func changeUserImageButtonTapped() {
//        let actionSheet = FactoryUI.shared.makeChangePhotoAlert(
//            onGalleryTap: { [weak self] in
//                guard let self else { return }
//                let imagePicker = self.createImagePickerController()
//                self.present(imagePicker, animated: true)
//            },
//            onUnsplashTap: {
//                print("onUnsplashTap")
//            }
//        )
//        
//        present(actionSheet, animated: true)
//    }
    
    private func loadDataFromUserDefoults() {
        let userSettings = UserSettings.load()
        
        let name = userSettings?.name
        let image = userSettings?.image ?? Asset.Images.defaultUserImage
        
        profileHeader.configure(image: image, name: name, tasks: nil)
    }
    
//    private func saveButtonTapped() {
//        guard let userName = userNameTextField.text, !userName.isEmpty else {
//            return
//        }
//        
//        let imageData = userImage.image?.jpegData(compressionQuality: 0.8)
//        
//        let userSettings = UserSettings(name: userName, imageData: imageData)
//        userSettings.save()
//    }
    
    private func logsButtonTapped() {
        let logsVC = LogsViewController()
        let navController = UINavigationController(rootViewController: logsVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
//    private func createImagePickerController() -> UIImagePickerController {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.sourceType = .photoLibrary
//        return imagePickerController
//    }
}

//extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    func imagePickerController(
//        _ picker: UIImagePickerController,
//        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
//    ) {
//        if let image = info[.editedImage] as? UIImage {
//            userImage.image = image
//        } else if let image = info[.originalImage] as? UIImage {
//            userImage.image = image
//        }
//        
//        dismiss(animated: true)
//    }
//}

private extension ProfileViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        view.addSubview(profileHeader)
//        view.addSubview(userImageStackView)
//        userImageStackView.addArrangedSubview(userImage)
//        userImageStackView.addArrangedSubview(changeUserImageButton)
//        
//        view.addSubview(userInfoStackView)
//        
//        userInfoStackView.addArrangedSubview(nameLabel)
//        userInfoStackView.addArrangedSubview(userNameTextField)
//        view.addSubview(saveButton)
        
//        view.addSubview(logsButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileHeader.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileHeader.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor, constant: 16),
            profileHeader.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor, constant: -16),
//            userImageStackView.topAnchor
//                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
//            userImageStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            userImage.heightAnchor.constraint(equalToConstant: 120),
//            userImage.widthAnchor.constraint(equalToConstant: 120),
//            
//            userInfoStackView.topAnchor
//                .constraint(equalTo: userImageStackView.bottomAnchor, constant: 15),
//            userInfoStackView.leadingAnchor
//                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
//            userInfoStackView.trailingAnchor
//                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
//            
//            nameLabel.widthAnchor.constraint(equalToConstant: 60),
//            
//            saveButton.topAnchor
//                .constraint(equalTo: userInfoStackView.bottomAnchor, constant: 10),
//            saveButton.widthAnchor.constraint(equalToConstant: 120),
//            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            saveButton.widthAnchor.constraint(equalToConstant: 120),
//            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            logsButton.topAnchor
//                .constraint(equalTo: saveButton.bottomAnchor, constant: 50),
//            logsButton.trailingAnchor
//                .constraint(equalTo: view.trailingAnchor, constant: -15),
//            logsButton.leadingAnchor
//                .constraint(equalTo: view.leadingAnchor, constant: 15)
            
        ])
    }
}
