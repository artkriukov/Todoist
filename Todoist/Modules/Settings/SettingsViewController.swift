//
//  SettingsViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 27.04.2025.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - UI
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
        element.font = .systemFont(ofSize: 16, weight: .medium)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    private lazy var userNameTextField: UITextField = {
        let element = UITextField()
        element.placeholder = "Ваше имя"
        element.borderStyle = .roundedRect
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

private extension SettingsViewController {
    private func setupViews() {
        
        view.addSubview(userStackView)
        userStackView.addArrangedSubview(nameLabel)
        userStackView.addArrangedSubview(userNameTextField)
        userStackView.addArrangedSubview(saveButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
[
            userStackView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            userStackView.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            userStackView.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ]
)
    }
}
