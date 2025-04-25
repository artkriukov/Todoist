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
        element.backgroundColor = .white
        element.layer.cornerRadius = 10
        element.isLayoutMarginsRelativeArrangement = true
        element.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var titleTextField = UITextField(placeholder: "Название")
    private lazy var descriptionTextField = UITextField(placeholder: "Заметка")
    
    private lazy var lineView: UIView = {
        let element = UIView()
        element.backgroundColor = UIConstants.grayColor
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
    
    private lazy var expirationDateStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.backgroundColor = .white
        element.layer.cornerRadius = 10
        element.spacing = 15
        element.isLayoutMarginsRelativeArrangement = true
        element.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var dataPicker: ExpirationDateStackView = {
        let config = ExpirationDateStackView.Configuration(
            image: UIImage(systemName: "calendar"),
            title: "Дата",
            backgroundColor: .red
        )
        
        let element = ExpirationDateStackView(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        
        return element
    }()
    
    private lazy var timePicker: ExpirationDateStackView = {
        let config = ExpirationDateStackView.Configuration(
            image: UIImage(systemName: "clock"),
            title: "Время",
            backgroundColor: .systemBlue
        )
        
        let element = ExpirationDateStackView(configuration: config)
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
        view.backgroundColor = UIConstants.grayColor
        
        view.addSubview(infoStackView)
        infoStackView.addArrangedSubview(titleTextField)
        infoStackView.addArrangedSubview(lineView)
        infoStackView.addArrangedSubview(descriptionTextField)
        
        
        view.addSubview(actionStackView)
        actionStackView.addArrangedSubview(datePicker)
        actionStackView.addArrangedSubview(datePickerContainer)
        
        view.addSubview(expirationDateStackView)
        
        expirationDateStackView.addArrangedSubview(dataPicker)
        expirationDateStackView.addArrangedSubview(timePicker)

    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate(
[
            
            infoStackView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                            constant: 10),
            infoStackView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15),
            infoStackView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15),

            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            lineView.heightAnchor.constraint(equalToConstant: 2),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 40),

            
            actionStackView.topAnchor
                .constraint(equalTo: infoStackView.bottomAnchor, constant: 15),
            actionStackView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15),
            actionStackView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15),
            
            expirationDateStackView.topAnchor.constraint(equalTo: actionStackView.bottomAnchor, constant: 15),
            expirationDateStackView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15),
            expirationDateStackView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15),
            
        ]
)
    }
}
