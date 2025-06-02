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
        element.text = "Имя"
        element.font = UIConstants.CustomFont.medium(size: 17)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    private lazy var userNameTextField: UITextField = {
        let element = UITextField()
        element.placeholder = "Ваше имя"
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var saveButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Сохранить", for: .normal)
        element.addAction(UIAction { [weak self] _ in
            self?.saveButtonTapped()
        },
                          for: .touchUpInside)
        element.backgroundColor = UIConstants.Colors.blueColor
        element.tintColor = .white
        element.layer.cornerRadius = 10
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var logsButton: UIButton = {
        
        let element = FactoryUI.shared.makeStyledButton(
            title: "Посмотреть логи") {
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
        
        let userSettings = UserSettings.load()
        userNameTextField.text = userSettings?.name
    }
    
    private func saveButtonTapped() {
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            return
        }
        
        let userSettings = UserSettings(name: userName)
        userSettings.save()
    }
    
    private func logsButtonTapped() {
        let logsVC = LogsViewController()
        let navController = UINavigationController(rootViewController: logsVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

private extension UserSettingsViewController {
    func setupViews() {
        view.backgroundColor = UIConstants.Colors.mainBackground
        
        view.addSubview(userInfoStackView)
        
        userInfoStackView.addArrangedSubview(nameLabel)
        userInfoStackView.addArrangedSubview(userNameTextField)
        view.addSubview(saveButton)
        
        view.addSubview(logsButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            userInfoStackView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
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
            
            logsButton.topAnchor
                .constraint(equalTo: saveButton.bottomAnchor, constant: 50),
            logsButton.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15),
            logsButton.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15)

        ])
    }
}
