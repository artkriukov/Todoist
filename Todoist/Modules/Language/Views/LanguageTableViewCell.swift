//
//  LanguageTableViewCell.swift
//  Todoist
//
//  Created by Artem Kriukov on 08.07.2025.
//

import UIKit

final class LanguageTableViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with language: Language) {
        titleLabel.text = language.rawValue
    }
}

private extension LanguageTableViewCell {
    func setupViews() {
        contentView.addSubview(titleLabel)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
