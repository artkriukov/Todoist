//
//  CustomInputField.swift
//  Todoist
//
//  Created by Artem Kriukov on 12.07.2025.
//

import UIKit

final class CustomInputField: UIView {

    private let label = UILabel()
    private let textField = InsetTextField()
    private let toggleButton = UIButton(type: .custom)

    private var isSecure = false

    init(configuration: Configuration) {
        super.init(frame: .zero)
        setup(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(configuration: Configuration) {
        makeLabel(configuration: configuration)
        makeTextField(configuration: configuration)
        setupViews()
    }
}

extension CustomInputField {
    struct Configuration {
        let title: String
        let placeholder: String
        let isSecure: Bool
        let keyboardType: UIKeyboardType
    }
}

private extension CustomInputField {
    func makeLabel(configuration: Configuration) {
        label.text = configuration.title
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    func makeTextField(configuration: Configuration) {
        textField.placeholder = configuration.placeholder
        textField.keyboardType = configuration.keyboardType
        textField.autocapitalizationType = .none
        textField.backgroundColor = Asset.Colors.secondaryBackground
        textField.layer.cornerRadius = 8
        textField.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false

        isSecure = configuration.isSecure
        textField.isSecureTextEntry = isSecure

        if configuration.isSecure {
            setupToggleButton()
            textField.rightView = toggleButton
            textField.rightViewMode = .always
        } else {
            textField.rightView = nil
            textField.rightViewMode = .never
        }
    }

    func setupToggleButton() {
        let image = UIImage(systemName: "eye.slash")
        toggleButton.setImage(image, for: .normal)
        toggleButton.tintColor = Asset.Colors.lightGrayColor
        toggleButton.addAction(
            UIAction { [weak self] _ in
                self?.toggleSecureEntry()
            }, for: .touchUpInside
        )
        toggleButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    }

    func toggleSecureEntry() {
        isSecure.toggle()
        textField.isSecureTextEntry = isSecure
        let image = UIImage(systemName: isSecure ? "eye.slash" : "eye")
        toggleButton.setImage(image, for: .normal)
    }

     func setupViews() {
        addSubview(label)
        addSubview(textField)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),

            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
