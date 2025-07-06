//
//  EditProfileViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 06.07.2025.
//

import UIKit

final class EditProfileViewController: UIViewController {
    
    private var user: UserInfo
    
    // MARK: - UI
    private lazy var imageStackView = FactoryUI.shared.makeStackView(
        backgroundColor: .clear
    )
    
    private lazy var userImage: UIImageView = {
        let element = UIImageView()
        element.image = Asset.Images.defaultUserImage
        element.layer.cornerRadius = 60
        element.contentMode = .scaleAspectFill
        element.clipsToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var changeImageButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle(
            ProfileStrings.changePhoto.rawValue.localized(),
            for: .normal
        )
        element.addAction(
            UIAction { [weak self] _ in
                self?.changeUserImageButtonTapped()
            }, for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var infoStackView = FactoryUI.shared.makeStackView(
        backgroundColor: .clear
    )
    
    private lazy var nameLabel: UILabel = {
        let element = UILabel()
        element.text = ProfileStrings.yourName.rawValue.localized()
        element.font = Asset.CustomFont.bold(size: 20)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var userNameTextField = FactoryUI.shared.makeTetxField(
        placeholder: ProfileStrings.yourName.rawValue.localized(),
        backgroundColor: Asset.Colors.secondaryBackground,
        horizontalInset: 12,
        image: Asset.Images.edit
    )
    
    // MARK: - Init
    
    init(user: UserInfo) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupViews()
        setupConstraints()
        configureNavigationBar()
        configureUserData()
    }
    
    // MARK: - Private Methods
    private func configureUserData() {
        userNameTextField.text = user.name
        userImage.image = user.image ?? Asset.Images.defaultUserImage
    }
    
    private func changeUserImageButtonTapped() {
        let actionSheet = FactoryUI.shared.makeChangePhotoAlert(
            onGalleryTap: { [weak self] in
                guard let self else { return }
                let imagePicker = self.createImagePickerController()
                self.present(imagePicker, animated: true)
            },
            onUnsplashTap: {
                print("onUnsplashTap")
            }
        )
        
        present(actionSheet, animated: true)
    }
    
    private func createImagePickerController() -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        return imagePickerController
    }
    
    private func saveItemTapped() {
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            return
        }
        
        let imageData = userImage.image?.jpegData(compressionQuality: 0.8)
        
        let userInfo = UserInfo(name: userName, imageData: imageData)
        userInfo.save()
        
        navigationController?.popViewController(animated: true)
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: GlobalStrings.save.rawValue.localized(),
            primaryAction: UIAction { [weak self] _ in
                self?.saveItemTapped()
            }
        )
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

private extension EditProfileViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        
        view.addSubview(imageStackView)
        imageStackView.addArrangedSubview(userImage)
        imageStackView.addArrangedSubview(changeImageButton)
        
        view.addSubview(infoStackView)
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(userNameTextField)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageStackView.topAnchor
                .constraint( equalTo: view.topAnchor, constant: 5),
            imageStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userImage.widthAnchor.constraint(equalToConstant: 120),
            userImage.heightAnchor.constraint(equalToConstant: 120),
            
            changeImageButton.widthAnchor.constraint(equalToConstant: 120),
            
            infoStackView.topAnchor
                .constraint(equalTo: imageStackView.bottomAnchor, constant: 20),
            infoStackView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15),
            infoStackView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15),
            
            userNameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
