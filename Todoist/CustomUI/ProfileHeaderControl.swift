//
//  ProfileHeaderControl.swift
//  Todoist
//
//  Created by Artem Kriukov on 06.07.2025.
//

import UIKit

final class ProfileHeaderControl: UIControl {

    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let tasksLabel = UILabel()
    private let chevronImageView = UIImageView()
    private var action: (() -> Void)?

    init(configuration: Configuration) {
        super.init(frame: .zero)
        setup(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(image: UIImage?, name: String?, tasks: String?) {
        imageView.image = image
        nameLabel.text = name
        tasksLabel.text = tasks
    }

    private func setup(configuration: Configuration) {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(tasksLabel)
        addSubview(chevronImageView)

        imageView.image = configuration.image
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = 27
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.text = configuration.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        tasksLabel.text = configuration.tasks
        tasksLabel.font = UIFont.systemFont(ofSize: 15)
        tasksLabel.textColor = .gray
        tasksLabel.translatesAutoresizingMaskIntoConstraints = false

        chevronImageView.image = Asset.Images.chevron
        chevronImageView.tintColor = .systemGray3
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 8
        clipsToBounds = true

        isAccessibilityElement = true
        accessibilityLabel = "Профиль пользователя"
        accessibilityTraits = .button

        self.action = configuration.action

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 55),
            imageView.heightAnchor.constraint(equalToConstant: 55),

            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 18),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18),

            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -8),

            tasksLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            tasksLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            tasksLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -8),
            tasksLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])

        addAction(
            UIAction { [weak self] _ in
                self?.action?()
            },
            for: .touchUpInside
        )
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.6 : 1.0
        }
    }
}

extension ProfileHeaderControl {
    struct Configuration {
        let image: UIImage?
        let name: String?
        let tasks: String?
        let action: () -> Void
    }
}
