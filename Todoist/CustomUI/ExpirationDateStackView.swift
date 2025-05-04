//
//  ExpirationDateStackView.swift
//  Todoist
//
//  Created by Artem Kriukov on 25.04.2025.
//

import UIKit

final class ExpirationDateStackView: UIView {
    
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
        let imageBackgroundView = createImageBackgroundView(color: configuration.backgroundColor)
        
        setupImageView(image: configuration.image, in: imageBackgroundView)
        
        let dateStack = createVerticalDateStack(title: configuration.title, subtitle: configuration.subtitle)
        
        setupSwitcher(action: configuration.switcherAction)
        
        setupStackViews(imageBackgroundView: imageBackgroundView, dateStack: dateStack)
        
        setupConstraints(imageBackgroundView: imageBackgroundView)
    }
}

extension ExpirationDateStackView {
    struct Configuration {
        let image: UIImage?
        let title: String
        let subtitle: String?
        let backgroundColor: UIColor
        let switcherAction: () -> Void
    }
}

extension ExpirationDateStackView {
    
    private func setupStackViews(
        imageBackgroundView: UIView,
        dateStack: UIStackView
    ) {
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.spacing = 12
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [imageBackgroundView, dateStack, UIView(), switcher].forEach {
            hStackView.addArrangedSubview($0)
        }
        
        addSubview(hStackView)
        
    }
    
    private func createImageBackgroundView(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func setupImageView(image: UIImage?, in container: UIView) {
        imageView.image = image
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
    }
    
    private func createVerticalDateStack(title: String, subtitle: String?) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        [titleLabel, subtitleLabel].forEach {
            stack.addArrangedSubview($0)
        }
        
        return stack
    }
    
    private func setupSwitcher(action: @escaping () -> Void) {
        switcher.addAction(
            UIAction(handler: { _ in action() }),
            for: .touchUpInside
        )
    }
    
    private func setupConstraints(imageBackgroundView: UIView) {
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
