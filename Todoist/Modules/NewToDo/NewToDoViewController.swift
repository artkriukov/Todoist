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
    private var expirationDate: Date?
    private var selectedImage: UIImage?
    private let toDoService: ToDoService
    
    var saveItem: ((ToDoItem) -> Void)?
    var onImageReceived: ((UIImage) -> Void)?
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
        placeholder: ToDoStrings.title.rawValue.localized()
    )
    
    private lazy var descriptionTextField = FactoryUI.shared.makeTetxField(
        placeholder: ToDoStrings.note.rawValue.localized()
    )
    
    private lazy var lineView: UIView = {
        let element = UIView()
        element.backgroundColor = Asset.Colors.separatorLine
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var expirationDateStackView = FactoryUI.shared.makeStackView(
        spacing: 15,
        layoutMargins: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    )
    
    private lazy var datePickerSV: TitledSwitchView = {
        let config = TitledSwitchView.Configuration(
            image: UIImage(systemName: "calendar"),
            title: ToDoStrings.date.rawValue.localized(),
            subtitle: nil,
            backgroundColor: .red,
            switcherAction: { [weak self] in
                self?.dataSwitcherValueChanged()
            })
        
        let element = TitledSwitchView(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        
        return element
    }()
    
    private lazy var datePicker = FactoryUI.shared.makeDatePicker(
        style: .inline,
        handler: { [weak self] date in
            self?.pickerValueChanged(date, pickerType: .date)
        }
    )
    
    private lazy var timePickerSV: TitledSwitchView = {
        let config = TitledSwitchView.Configuration(
            image: UIImage(systemName: "clock"),
            title: ToDoStrings.time.rawValue.localized(),
            subtitle: nil,
            backgroundColor: .systemBlue,
            switcherAction: { [weak self] in
                self?.timeSwitcherValueChanged()
            })
        
        let element = TitledSwitchView(configuration: config)
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
    
    private lazy var toDoImageView: TitledSwitchView = {
        let config = TitledSwitchView.Configuration(
            image: UIImage(systemName: "photo"),
            title: "Изображение",
            subtitle: nil,
            backgroundColor: .systemYellow,
            switcherAction: { [weak self] in
                self?.toDoImageSwitcherValueChanged()
            })
        
        let element = TitledSwitchView(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var toDoImageButton: UIButton = {
        let element = FactoryUI.shared.makeStyledButton(
            title: "Загрузить изображение",
            alignment: .center
        ) {
                self.toDoImageButtonTapped()
            }
        element.isHidden = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var toDoSelectedImageView: UIImageView = {
        let element = UIImageView()
        element.tintColor = Asset.Colors.imagePlaceholderTint
        element.layer.cornerRadius = 12
        element.clipsToBounds = true
        element.isHidden = true
        element.contentMode = .scaleAspectFill
        element.image = Asset.Images.defaultBackgroundImage
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Init
    init(
        saveItem: ((ToDoItem) -> Void)? = nil,
        onImageReceived: ((UIImage) -> Void)? = nil,
        toDoService: ToDoService = ToDoService()
    ) {
        self.saveItem = saveItem
        self.onImageReceived = onImageReceived
        self.toDoService = toDoService
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
        
        onImageReceived = { [weak self] image in
            self?.toDoSelectedImageView.image = image
        }

    }
    
    // MARK: - Private Methods
    private func addNewItemTapped() {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        let descr = descriptionTextField.text
        let date = combineDateAndTime(with: selectedDate, and: selectedTime)
        let dataImage = selectedImage?.pngData()
        
        let newItem = ToDoItem(
            title: title,
            description: descr,
            expirationDate: date,
            selectedImage: dataImage
        )
        
        toDoService.createToDo(toDo: newItem) { [weak self] isAdd in
            guard let self else { return }
            if isAdd {
                self.saveItem?(newItem)
                self.dismiss(animated: true)
            }
        }
    }
    
    private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func configureNavigationBar() {
        title = ToDoStrings.newReminders.rawValue.localized()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: GlobalStrings.cancel.rawValue.localized(),
            primaryAction: UIAction { [weak self] _ in
                self?.cancelButtonTapped()
            }
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: GlobalStrings.add.rawValue.localized(),
            primaryAction: UIAction { [weak self] _ in
                self?.addNewItemTapped()
            }
        )
    }
    
    private func dataSwitcherValueChanged() {
        handleToggleChange(isOn: datePickerSV.switcher.isOn, relatedView: datePicker)
    }
    
    private func timeSwitcherValueChanged() {
        handleToggleChange(isOn: timePickerSV.switcher.isOn, relatedView: timePicker)
    }
    
    private func toDoImageSwitcherValueChanged() {
        handleToggleChange(
            isOn: toDoImageView.switcher.isOn,
            relatedView: toDoImageButton,
            relatedImage: toDoSelectedImageView
        )
    }
    
    private func handleToggleChange(isOn: Bool, relatedView: UIView, relatedImage: UIImageView? = nil) {
        UIView.animate(withDuration: 0.5) {
            relatedView.isHidden = !isOn
            relatedView.layer.opacity = isOn ? 1 : 0
            relatedImage?.isHidden = !isOn
            relatedImage?.layer.opacity = isOn ? 1 : 0
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
            receiveOnMainThread {
                self.datePickerSV.subtitleLabel.text = dateString
            }

        case .time:
            selectedTime = date
            formatter.dateFormat = "HH:mm"
            let timeString = formatter.string(from: date)
            receiveOnMainThread {
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
    
    private func toDoImageButtonTapped() {
        let imageSourceVC = ImageSourceSelectionViewController(mode: .local)
        imageSourceVC.onImageReceived = { [weak self] image in
            self?.toDoSelectedImageView.image = image
            self?.selectedImage = image
        }
        navigationController?.pushViewController(imageSourceVC, animated: true)
    }
}

private extension NewToDoViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(titleTextField)
        infoStackView.addArrangedSubview(lineView)
        infoStackView.addArrangedSubview(descriptionTextField)
        
        contentView.addSubview(expirationDateStackView)
        
        [datePickerSV, datePicker, timePickerSV, timePicker, toDoImageView, toDoImageButton, toDoSelectedImageView].forEach {
            expirationDateStackView.addArrangedSubview($0)
        }
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
                .constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            toDoImageButton.heightAnchor.constraint(equalToConstant: 44),
            
            toDoSelectedImageView.leadingAnchor
                .constraint(equalTo: expirationDateStackView.leadingAnchor, constant: 15),
            toDoSelectedImageView.trailingAnchor
                .constraint(equalTo: expirationDateStackView.trailingAnchor, constant: -15),
            toDoSelectedImageView.heightAnchor.constraint(equalToConstant: 230)
        ])
    }
}
