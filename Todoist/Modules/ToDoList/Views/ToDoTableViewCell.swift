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
        element.axis = .vertical
        element.alignment = .leading
        element.spacing = 5
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
    
    private lazy var imageIndicatorView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFill
        element.isHidden = true
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
        
        hideOptionalElements()
        
        toDoTitleLabel.text = item.title
        toDoTitleLabel.isHidden = false
        
        if let description = item.description, !description.isEmpty {
            toDoDescrLabel.text = description
            toDoDescrLabel.isHidden = false
        }
        
        if let expirationDate = item.expirationDate {
            let data = ExpirationDateHelper().getExpirationDate(for: expirationDate)
            expirationDateLabel.text = data.text
            expirationDateLabel.textColor = data.uiColor
            expirationDateLabel.isHidden = false
        } else {
            expirationDateLabel.textColor = .systemGray
        }
        
        if item.selectedImage != nil {
            imageIndicatorView.image = UIImage(systemName: "photo.artframe.circle.fill")
            imageIndicatorView.isHidden = false
        }
    }
    
    private func didTappedDoneButton() {
        doneButton.setImage(
                UIImage(systemName: "checkmark.circle.fill"),
                for: .normal
            )
        
        handlerButtonTapped?()

    }
    
    private func hideOptionalElements() {
        toDoDescrLabel.isHidden = true
        expirationDateLabel.isHidden = true
        imageIndicatorView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        toDoTitleLabel.isHidden = true
        toDoDescrLabel.isHidden = true
        expirationDateLabel.isHidden = true
        imageIndicatorView.isHidden = true
        
    }
}

// MARK: - Setup Views & Setup Constraints
private extension ToDoTableViewCell {
    func setupViews() {
        backgroundColor = Asset.Colors.mainBackground
        
        contentView.addSubview(contentSV)
        contentSV.addArrangedSubview(doneButton)
        
        contentSV.addArrangedSubview(toDoMainSV)
        
        toDoMainSV.addArrangedSubview(toDoTitleLabel)
        toDoMainSV.addArrangedSubview(toDoDescrLabel)
        toDoMainSV.addArrangedSubview(expirationDateLabel)
        toDoMainSV.addArrangedSubview(imageIndicatorView)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentSV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentSV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentSV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            imageIndicatorView.widthAnchor.constraint(equalToConstant: 25),
            imageIndicatorView.heightAnchor.constraint(equalToConstant: 25),
            
            doneButton.widthAnchor.constraint(equalToConstant: 24),
            doneButton.heightAnchor.constraint(equalTo: doneButton.widthAnchor)
        ])
    }
}
