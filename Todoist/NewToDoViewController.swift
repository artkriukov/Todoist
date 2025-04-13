//
//  NewToDoViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit

final class NewToDoViewController: UIViewController {
    
    var saveItem: ((ToDoItem) -> Void)?
    // MARK: - UI
    
    private lazy var infoStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 10
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var titleTextField: UITextField = {
        let element = UITextField()
        element.placeholder = "ToDo title"
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let element = UITextField()
        element.placeholder = "Описание"
        element.font = .systemFont(ofSize: 14)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actionStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    
    private lazy var addNewItemButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        element.backgroundColor = .systemRed
        element.tintColor = .white
        element.layer.cornerRadius = 15
        element.addAction(
                UIAction { [weak self] _ in
                    self?.addNewItemTapped()
                },
                for: .touchUpInside
            )
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Init
    init(saveItem: @escaping (ToDoItem) -> Void) {
        self.saveItem = saveItem
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    private func addNewItemTapped() {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        let descr = descriptionTextField.text
        
        let newItem = ToDoItem(title: title, description: descr)
        saveItem?(newItem)
        
        dismiss(animated: true)
    }
}

private extension NewToDoViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(infoStackView)
        infoStackView.addArrangedSubview(titleTextField)
        infoStackView.addArrangedSubview(descriptionTextField)
        
        
        view.addSubview(actionStackView)
        actionStackView.addArrangedSubview(addNewItemButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            infoStackView.topAnchor
                .constraint(equalTo: view.topAnchor, constant: 10),
            infoStackView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15),
            infoStackView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15),

            actionStackView.topAnchor
                .constraint(equalTo: infoStackView.bottomAnchor, constant: 15),
            actionStackView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15),
            actionStackView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15),
            

            addNewItemButton.widthAnchor.constraint(equalToConstant: 30),
            addNewItemButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
