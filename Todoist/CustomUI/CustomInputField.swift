//
//  CustomInputField.swift
//  Todoist
//
//  Created by Artem Kriukov on 12.07.2025.
//

import UIKit

final class CustomInputField: UIView {

    private let stackView = UIStackView()
    private let label = UILabel()
    private let textField = InsetTextField()
    private let warningLabel = UILabel()
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
        makeWarningLabel()
        makeStackView()
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

    func makeWarningLabel() {
        warningLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        warningLabel.textColor = .systemRed
        warningLabel.numberOfLines = 0
        warningLabel.isHidden = true
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func makeStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(stackView)

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(warningLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// MARK: - Public API для работы с warningLabel

extension CustomInputField {
    func showWarning(_ message: String) {
        warningLabel.text = message
        warningLabel.isHidden = false
    }

    func hideWarning() {
        warningLabel.text = nil
        warningLabel.isHidden = true
    }
}
