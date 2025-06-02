//
//  TitledSwitchView.swift
//  Todoist
//
//  Created by Artem Kriukov on 25.04.2025.
//

import UIKit

final class TitledSwitchView: UIView {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let hStackView = UIStackView()
    private let vDateStackView = UIStackView()
    
    public let subtitleLabel = UILabel()
    public let switcher = UISwitch()

    init(configuration: Configuration) {
        super.init(frame: .zero)
        
        setup(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(configuration: Configuration) {
        let imageBackgroundView = UIView()
        imageBackgroundView.backgroundColor = configuration.backgroundColor
        imageBackgroundView.layer.cornerRadius = 8
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = configuration.image
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - vDateStackView
        vDateStackView.axis = .vertical
        vDateStackView.spacing = 4
        
        titleLabel.text = configuration.title
        titleLabel.font = UIConstants.CustomFont.medium(size: 17)
        
        subtitleLabel.text = configuration.subtitle
        subtitleLabel.font = UIConstants.CustomFont.regular(size: 13)
        
        [titleLabel, subtitleLabel].forEach {
            vDateStackView.addArrangedSubview($0)
        }
        
        // MARK: - hStackView
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.spacing = 12
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        switcher.addAction(
            UIAction( handler: { _ in
                configuration.switcherAction()
            }),
            for: .touchUpInside)
        
        imageBackgroundView.addSubview(imageView)
        
        [imageBackgroundView, vDateStackView, UIView(), switcher].forEach {
            hStackView.addArrangedSubview($0)
        }
        
        addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: topAnchor),
            hStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageBackgroundView.widthAnchor.constraint(equalToConstant: 33),
            imageBackgroundView.heightAnchor.constraint(equalToConstant: 30),
            
            imageView.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            imageView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}

extension TitledSwitchView {
    struct Configuration {
        let image: UIImage?
        let title: String
        let subtitle: String?
        let backgroundColor: UIColor
        let switcherAction: () -> Void
    }
}
