//
//  ToDoTableViewCell.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit

final class ToDoTableViewCell: UITableViewCell {
    
    private var item: ToDoItem?
    
    // MARK: - UI
    private lazy var toDoMainSV: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 8
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    private lazy var toDoTitleLabel: UILabel = {
        let element = UILabel()
        element.text = "Title"
        element.font = .systemFont(ofSize: 17, weight: .medium)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var toDoDescrLabel: UILabel = {
        let element = UILabel()
        element.text = "Description"
        element.numberOfLines = 0
        element.font = .systemFont(ofSize: 14, weight: .regular)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var expirationDateLabel: UILabel = {
        let element = UILabel()
        element.text = "Expiration date"
        element.font = .systemFont(ofSize: 13, weight: .regular)
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
        toDoTitleLabel.text = item.title
        toDoDescrLabel.text = item.description
        
        let checker = DefaultExpirationChecker()
        
        if let expirationDate = item.expirationDate {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, HH:mm"
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
    
    override func prepareForReuse() {
        toDoTitleLabel.text = nil
        toDoDescrLabel.text = nil
        expirationDateLabel.text = nil
    }
}

// MARK: - Setup Views & Setup Constraints
private extension ToDoTableViewCell {
    func setupViews() {
        addSubview(toDoMainSV)
        toDoMainSV.addArrangedSubview(toDoTitleLabel)
        toDoMainSV.addArrangedSubview(toDoDescrLabel)
        toDoMainSV.addArrangedSubview(expirationDateLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            toDoMainSV.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            toDoMainSV.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: 16),
            toDoMainSV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            toDoMainSV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
    }
}
