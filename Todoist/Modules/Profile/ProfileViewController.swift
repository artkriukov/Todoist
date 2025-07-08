//
//  UserProfileViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 27.04.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let logger: Logger
    
    private var user: UserInfo?
    // MARK: - UI
    
    private lazy var profileHeader: ProfileHeaderControl = {
        let config = ProfileHeaderControl.Configuration(
            image: Asset.Images.defaultUserImage,
            name: ProfileStrings.userName.rawValue.localized(),
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
        element.tintColor = Asset.Colors.lightGrayColor
        element.addAction(
            UIAction { [weak self] _ in
                self?.settingsButtonTapped()
            }, for: .touchUpInside)
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
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataFromUserDefoults()
    }
    
    // MARK: - Private Methods
    
    private func openProfileDetails() {
        let userToEdit = user ?? UserInfo(name: "", imageData: nil)
        let editProfileVC = EditProfileViewController(user: userToEdit)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    private func loadDataFromUserDefoults() {
        user = UserInfo.load()
        
        let name = user?.name ?? ProfileStrings.userName.rawValue.localized()
        let image = user?.image ?? Asset.Images.defaultUserImage
        
        profileHeader.configure(image: image, name: name, tasks: nil)
    }
    
    private func settingsButtonTapped() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    private func logsButtonTapped() {
        let logsVC = LogsViewController()
        let navController = UINavigationController(rootViewController: logsVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonItem)
    }
}

private extension ProfileViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        view.addSubview(profileHeader)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileHeader.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileHeader.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor, constant: 16),
            profileHeader.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor, constant: -16)
            
        ])
    }
}
