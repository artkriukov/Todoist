//
//  ToDoTableViewCell.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit

final class ToDoTableViewCell: UITableViewCell {
    static let indetifer = "ToDoTableViewCell"
    
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
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var toDoDescrLabel: UILabel = {
        let element = UILabel()
        element.text = "Description"
        element.numberOfLines = 0
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
}

// MARK: - Setup Views & Setup Constraints
private extension ToDoTableViewCell {
    func setupViews() {
        addSubview(toDoMainSV)
        toDoMainSV.addArrangedSubview(toDoTitleLabel)
        toDoMainSV.addArrangedSubview(toDoDescrLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            toDoMainSV.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            toDoMainSV.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: 16),
            toDoMainSV.trailingAnchor.constraint(equalTo: trailingAnchor),
            toDoMainSV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
    }
}
