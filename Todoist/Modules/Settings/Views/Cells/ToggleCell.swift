//
//  ToggleCell.swift
//  Todoist
//
//  Created by Artem Kriukov on 07.07.2025.
//

import UIKit

final class ToggleCell: UITableViewCell {
    
    var switchChanged: ((Bool) -> Void)?
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var toggleSwitch: UISwitch = {
        let element = UISwitch()
        element.addAction(
            UIAction { [weak self] _ in
                self?.switchValueChanged()
        }, for: .valueChanged)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        toggleSwitch.isOn = false
    }
    
    // MARK: - Publick Methods
    func configureCell(with title: String, isOn: Bool) {
        titleLabel.text = title
        toggleSwitch.isOn = isOn
    }
    
    // MARK: - Private Methods
    private func switchValueChanged() {
        switchChanged?(toggleSwitch.isOn)
    }
    
    private func setupUI() {
        backgroundColor = Asset.Colors.secondaryBackground
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)
        selectionStyle = .none
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
