//
//  InfoHeaderView.swift
//  Todoist
//
//  Created by Artem Kriukov on 12.07.2025.
//

import UIKit

final class InfoHeaderView: UIView {

    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let descrLabel = UILabel()

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var descriptionText: String? {
        get { descrLabel.text }
        set { descrLabel.text = newValue }
    }

    // MARK: - Init

    init(configuration: Configuration) {
        super.init(frame: .zero)
        setup(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(configuration: Configuration) {
        makeTitleLabel(configuration: configuration)
        makeDescrLabel(configuration: configuration)
        makeStackView()
        setupViews()
    }
}

extension InfoHeaderView {
    struct Configuration {
        let title: String
        let description: String
    }
}

private extension InfoHeaderView {
    private func makeTitleLabel(configuration: Configuration) {
        titleLabel.text = configuration.title
        titleLabel.font = Asset.CustomFont.medium(size: 24)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func makeDescrLabel(configuration: Configuration) {
        descrLabel.text = configuration.description
        descrLabel.font = Asset.CustomFont.regular(size: 17)
        descrLabel.textColor = .secondaryLabel
        descrLabel.numberOfLines = 0
        descrLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func makeStackView() {
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descrLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
