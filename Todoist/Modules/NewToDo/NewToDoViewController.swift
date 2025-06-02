//
//  NewToDoViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit

private enum PickerType {
    case date
    case time
}

final class NewToDoViewController: UIViewController {
    
    private var selectedDate: Date?
    private var selectedTime: Date?
    
    var expirationDate: Date?
    
    var saveItem: ((ToDoItem) -> Void)?
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let element = UIScrollView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var contentView: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var infoStackView = FactoryUI.shared.makeStackView()
    
    private lazy var titleTextField = FactoryUI.shared.makeTetxField(
        placeholder: "Название"
    )
    
    private lazy var descriptionTextField = FactoryUI.shared.makeTetxField(
        placeholder: "Заметка"
    )
    
    private lazy var lineView: UIView = {
        let element = UIView()
        element.backgroundColor = UIConstants.Colors.separatorLine
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var expirationDateStackView = FactoryUI.shared.makeStackView(
        layoutMargins: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    private lazy var datePickerSV: ExpirationDateStackView = {
        let config = ExpirationDateStackView.Configuration(
            image: UIImage(systemName: "calendar"),
            title: "Дата",
            subtitle: nil,
            backgroundColor: .red,
            switcherAction: { [weak self] in
                self?.dataSwitcherValueChanged()
            })
        
        let element = ExpirationDateStackView(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        
        return element
    }()
    
    private lazy var datePicker = FactoryUI.shared.makeDatePicker(
        style: .inline,
        handler: { [weak self] date in
            self?.pickerValueChanged(date, pickerType: .date)
        }
    )
    
    private lazy var timePickerSV: ExpirationDateStackView = {
        let config = ExpirationDateStackView.Configuration(
            image: UIImage(systemName: "clock"),
            title: "Время",
            subtitle: nil,
            backgroundColor: .systemBlue,
            switcherAction: { [weak self] in
                self?.timeSwitcherValueChanged()
            })
        
        let element = ExpirationDateStackView(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        
        return element
    }()
    
    private lazy var timePicker = FactoryUI.shared.makeDatePicker(
        mode: .time,
        style: .wheels,
        handler: { [weak self] date in
            self?.pickerValueChanged(date, pickerType: .time)
        }
    )
    
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
        let date = combineDateAndTime(with: selectedDate, and: selectedTime)
        
        let newItem = ToDoItem(
            title: title,
            description: descr,
            expirationDate: date
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
    
    private func dataSwitcherValueChanged() {
        handlePickerSwitch(isOn: datePickerSV.switcher.isOn, picker: datePicker)
    }
    
    private func timeSwitcherValueChanged() {
        handlePickerSwitch(isOn: timePickerSV.switcher.isOn, picker: timePicker)
    }
    
    private func handlePickerSwitch(isOn: Bool, picker: UIView) {
        UIView.animate(withDuration: 0.3) {
            picker.isHidden = !isOn
        }
    }
    
    private func pickerValueChanged(_ date: Date, pickerType: PickerType) {
        
        let formatter = DateFormatter()
        formatter.timeZone = .current
        
        switch pickerType {
        case .date:
            selectedDate = date
            formatter.dateFormat = "MMM d"
            let dateString = formatter.string(from: date)
            DispatchQueue.main.async {
                self.datePickerSV.subtitleLabel.text = dateString
            }
            
        case .time:
            selectedTime = date
            formatter.dateFormat = "HH:mm"
            let timeString = formatter.string(from: date)
            DispatchQueue.main.async {
                self.timePickerSV.subtitleLabel.text = timeString
            }
        }
    }
    
    private func combineDateAndTime(with selectedDate: Date?, and selectedTime: Date?) -> Date? {
        guard let selectedDate, let selectedTime else { return nil }
        
        let calendar = Calendar.current
        
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: selectedTime)
        
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        dateComponents.second = timeComponents.second
        
        expirationDate = calendar.date(from: dateComponents)
        
        return expirationDate
    }
}

private extension NewToDoViewController {
    func setupViews() {
        view.backgroundColor = UIConstants.Colors.mainBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(titleTextField)
        infoStackView.addArrangedSubview(lineView)
        infoStackView.addArrangedSubview(descriptionTextField)
        
        contentView.addSubview(expirationDateStackView)
        expirationDateStackView.addArrangedSubview(datePickerSV)
        expirationDateStackView.addArrangedSubview(datePicker)
        expirationDateStackView.addArrangedSubview(timePickerSV)
        expirationDateStackView.addArrangedSubview(timePicker)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor
                .constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            infoStackView.topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: 20),
            infoStackView.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 15),
            infoStackView.trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 44),
            
            expirationDateStackView.topAnchor
                .constraint(equalTo: infoStackView.bottomAnchor, constant: 20),
            expirationDateStackView.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 15),
            expirationDateStackView.trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor, constant: -15),
            expirationDateStackView.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
