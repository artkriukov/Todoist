//
//  ToDoTableViewCell.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit

final class ToDoTableViewCell: UITableViewCell {
    
    private var item: ToDoItem?
    
    var handlerButtonTapped: (() -> Void)?
    
    // MARK: - UI
    
    private lazy var contentSV: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var doneButton: UIButton = {
        let element = UIButton(type: .system)
        element.backgroundColor = Asset.Colors.mainBackground
        element.tintColor = Asset.Colors.lightGrayColor
        element.layer.borderColor = Asset.Colors.separatorLine.cgColor
        element.layer.borderWidth = 1
        element.layer.cornerRadius = 12
        element.addAction(
            UIAction { [weak self] _ in
                self?.didTappedDoneButton()
            }, for: .touchUpInside
        )
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var toDoMainSV: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.distribution = .fillEqually
        element.alignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var mainInfoStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 4
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var selectedImage: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFit
        element.isHidden = true
        element.layer.cornerRadius = 12
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var toDoTitleLabel: UILabel = {
        let element = UILabel()
        element.text = "Title"
        element.font = Asset.CustomFont.medium(size: 17)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var toDoDescrLabel: UILabel = {
        let element = UILabel()
        element.text = "Description"
        element.numberOfLines = 0
        element.font = Asset.CustomFont.regular(size: 14)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var expirationDateLabel: UILabel = {
        let element = UILabel()
        element.font = Asset.CustomFont.regular(size: 13)
        element.textColor = .systemGreen
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Method
    func configureCell(with item: ToDoItem) {
        self.item = item
        if let imageData = item.selectedImage, let image = UIImage(data: imageData) {
            selectedImage.image = image
            selectedImage.isHidden = false
        } else {
            selectedImage.image = nil
            selectedImage.isHidden = true
        }

        toDoTitleLabel.text = item.title
        toDoDescrLabel.text = item.description
        
        let checker = DefaultExpirationChecker()
        
        if let expirationDate = item.expirationDate {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, HH:mm"
            formatter.timeZone = .current
            let timeLabel = formatter.string(from: expirationDate)
            
            switch checker.check(date: expirationDate) {
            case .moreThanHalfHour:
                expirationDateLabel.text = timeLabel
                expirationDateLabel.textColor = .systemGreen
                
            case .lessThanHalfHour:
                expirationDateLabel.text = timeLabel
                expirationDateLabel.textColor = .systemYellow
                
            case .failed:
                expirationDateLabel.text = "Просрочено"
                expirationDateLabel.textColor = .systemRed
            }
        } else {
            expirationDateLabel.textColor = .systemGray
        }
    }
    
    private func didTappedDoneButton() {
        doneButton.setImage(
                UIImage(systemName: "checkmark.circle.fill"),
                for: .normal
            )
        
        handlerButtonTapped?()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        toDoTitleLabel.text = nil
        toDoDescrLabel.text = nil
        expirationDateLabel.text = nil
        selectedImage.image = nil
        doneButton.setImage(nil, for: .normal)
        
        toDoDescrLabel.isHidden = false
        expirationDateLabel.isHidden = false
        selectedImage.isHidden = false
        
    }
}

// MARK: - Setup Views & Setup Constraints
private extension ToDoTableViewCell {
    func setupViews() {
        backgroundColor = Asset.Colors.mainBackground
        
        contentView.addSubview(contentSV)
        contentSV.addArrangedSubview(doneButton)
        
        contentSV.addArrangedSubview(toDoMainSV)
        
        toDoMainSV.addArrangedSubview(mainInfoStackView)
        
        mainInfoStackView.addArrangedSubview(toDoTitleLabel)
        mainInfoStackView.addArrangedSubview(toDoDescrLabel)
        mainInfoStackView.addArrangedSubview(expirationDateLabel)
        
        toDoMainSV.addArrangedSubview(selectedImage)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentSV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentSV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentSV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            selectedImage.widthAnchor.constraint(equalToConstant: 80),
            selectedImage.heightAnchor.constraint(equalToConstant: 60),
            
            doneButton.widthAnchor.constraint(equalToConstant: 24),
            doneButton.heightAnchor.constraint(equalTo: doneButton.widthAnchor)
        ])
    }
}
