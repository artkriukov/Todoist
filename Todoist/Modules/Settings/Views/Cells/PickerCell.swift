//
//  PickerCell.swift
//  Todoist
//
//  Created by Artem Kriukov on 07.07.2025.
//

import UIKit

final class PickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var didSelectItem: ((String) -> Void)?
    private var isPickerVisible = false
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var valueLabel: UILabel = {
        let element = UILabel()
        
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
        valueLabel.text = nil
    }
    
    // MARK: - Publick Methods
     func configureCell(with title: String, and value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = Asset.Colors.secondaryBackground
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        selectionStyle = .default
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - UIPickerViewDataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { 0 }

}
