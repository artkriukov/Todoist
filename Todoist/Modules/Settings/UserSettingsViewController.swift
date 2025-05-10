//
//  SettingsViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 27.04.2025.
//

import UIKit

final class UserSettingsViewController: UIViewController {
    
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
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}

private extension UserSettingsViewController {
    func setupViews() {
        view.backgroundColor = UIConstants.Colors.mainBackground
        
        view.addSubview(userInfoStackView)
        
        userInfoStackView.addArrangedSubview(nameLabel)
        userInfoStackView.addArrangedSubview(userNameTextField)
        view.addSubview(saveButton)
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
            saveButton.trailingAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -15
                ),
            saveButton.leadingAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: 15
                )
        ])
    }
}
