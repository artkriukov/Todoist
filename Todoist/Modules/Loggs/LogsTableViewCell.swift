//
//  LogsTableViewCell.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.05.2025.
//

import UIKit

final class LogsTableViewCell: UITableViewCell {

    // MARK: - UI
    
    private lazy var logLabel: UILabel = {
        let element = UILabel()
        element.numberOfLines = 0
        element.lineBreakMode = .byWordWrapping
        element.font = Asset.CustomFont.regular(size: 16)
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
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logLabel.text = nil
    }
    
    func configure(with text: String) {
        logLabel.text = text
    }
}

private extension LogsTableViewCell {
    
    func setupViews() {
        contentView.addSubview(logLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            logLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            logLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
