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
    
    private lazy var infoStackView = UIStackView(
        spacing: 10,
        layoutMargins: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    )
    
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
    
    private lazy var expirationDateStackView = UIStackView(
        spacing: 15,
        layoutMargins: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    private lazy var datePickerSV: ExpirationDateStackView = {
        let config = ExpirationDateStackView.Configuration(
            image: UIImage(systemName: "calendar"),
            title: "Дата",
            backgroundColor: .red,
            switcherAction: { [weak self] in
                self?.dataSwitcherValueChanged()
            })
        
        let element = ExpirationDateStackView(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        
        return element
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker(
            datePickerMode: .date,
            datePickerStyle: .inline,
            handler: { [weak self] date in
                self?.datePickerValueChanged(date)
            }
        )
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var timePickerSV: ExpirationDateStackView = {
        let config = ExpirationDateStackView.Configuration(
            image: UIImage(systemName: "clock"),
            title: "Время",
            backgroundColor: .systemBlue,
            switcherAction: { [weak self] in
                self?.timeSwitcherValueChanged()
            })
        
        let element = ExpirationDateStackView(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        
        return element
    }()
    
    
    private lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker(
            datePickerMode: .time,
            datePickerStyle: .wheels,
            handler: { [weak self] date in
                self?.datePickerValueChanged(date)
            }
        )
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
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
    
#warning("refact dataSwitcherValueChanged and timeSwitcherValueChanged")
    private func dataSwitcherValueChanged() {
        if datePickerSV.switcher.isOn {
            datePicker.isHidden = false
        } else {
            datePicker.isHidden = true
        }
    }
    
    private func timeSwitcherValueChanged() {
        if timePickerSV.switcher.isOn {
            timePicker.isHidden = false
        } else {
            timePicker.isHidden = true
        }
    }
    
    private func datePickerValueChanged(_ date: Date) {
        isDateChanged = true
        print("Selected date:", date)
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
        
        view.addSubview(expirationDateStackView)
        
        expirationDateStackView.addArrangedSubview(datePickerSV)
        expirationDateStackView.addArrangedSubview(datePicker)
        
        expirationDateStackView.addArrangedSubview(timePickerSV)
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
