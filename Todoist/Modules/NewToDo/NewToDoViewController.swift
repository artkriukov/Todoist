//
//  NewToDoViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit

final class NewToDoViewController: UIViewController {
    private var isDateChanged = false
    
    var expirationDate: Date?
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
        element.distribution = .fillEqually
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    
    private lazy var addNewItemButton: RoundedActionButton = {
        let config = RoundedActionButton.Configuration(
            image: UIImage(systemName: "arrow.up"),
            backgroundColor: .systemRed,
            action: { [weak self] in
                self?.addNewItemTapped()
            })
        
        let element = RoundedActionButton(configuration: config)
        element.layer.cornerRadius = 15
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var datePickerContainer: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let element = UIDatePicker()
        element.minimumDate = Date()
        element.addAction(
            UIAction { [weak self] _ in
                self?.datePickerValueChanged(element)
            },
            for: .valueChanged
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
        configureNavigationBar()
    }
    
    // MARK: - Private Methods
    private func addNewItemTapped() {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        let descr = descriptionTextField.text
        
        expirationDate = isDateChanged ? datePicker.date : nil
        
        let newItem = ToDoItem(
            title: title,
            description: descr,
            expirationDate: expirationDate
        )
        saveItem?(newItem)
        
        dismiss(animated: true)
    }
    
    private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func configureNavigationBar() {
        title = "Новое напоминание"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отменить",
            primaryAction: UIAction { [weak self] _ in
                self?.cancelButtonTapped()
            }
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Добавить",
            primaryAction: UIAction { [weak self] _ in
                self?.addNewItemTapped()
            }
        )
    }
    
    
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        isDateChanged = true
    }
}

private extension NewToDoViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(infoStackView)
        infoStackView.addArrangedSubview(titleTextField)
        infoStackView.addArrangedSubview(descriptionTextField)
        
        
        view.addSubview(actionStackView)
        actionStackView.addArrangedSubview(datePicker)
        actionStackView.addArrangedSubview(datePickerContainer)
        datePickerContainer.addSubview(addNewItemButton)


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
            
            addNewItemButton.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
}
