//
//  NewToDoViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit

class NewToDoViewController: UIViewController {

    // MARK: - UI
    
    private lazy var titleTextField: UITextField = {
        let element = UITextField()
        element.placeholder = "ToDo title"
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let element = UITextView()
        element.text = "Hello"
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var addNewItemButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        element.backgroundColor = .systemRed
        element.tintColor = .white
        element.layer.cornerRadius = 8
        element.addTarget(
                self,
                action: #selector(addNewItemTapped),
                for: .touchUpInside
            )
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    @objc private func addNewItemTapped() {
        dismiss(animated: true)
    }
}

private extension NewToDoViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(addNewItemButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate(
[
            titleTextField.topAnchor
                .constraint(equalTo: view.topAnchor,constant: 15),
            titleTextField.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15),
            titleTextField.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionTextView.topAnchor
                .constraint(equalTo: titleTextField.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15),
            descriptionTextView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 140),
            
            addNewItemButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 15),
            addNewItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNewItemButton.widthAnchor.constraint(equalToConstant: 60),
            addNewItemButton.heightAnchor.constraint(equalToConstant: 30),
        ]
)
    }
}
