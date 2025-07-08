//
//  NavigationCell.swift
//  Todoist
//
//  Created by Artem Kriukov on 07.07.2025.
//

import UIKit

class NavigationCell: UITableViewCell {
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    // MARK: - Publick Methods
    func configureCell(with title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Private Methods 
    private func setupViews() {
        backgroundColor = Asset.Colors.secondaryBackground
        contentView.addSubview(titleLabel)        
        accessoryType = .disclosureIndicator
        selectionStyle = .default
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -32)
        ])
    }
}
