//
//  AuthButton.swift
//  Todoist
//
//  Created by Artem Kriukov on 12.07.2025.
//

import UIKit

final class AuthButton: UIControl {
    
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    init(configuration: Configuration) {
        super.init(frame: .zero)
        
        setup(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.contains(point)
    }
    
    private func setup(configuration: Configuration) {
        makeStackView()
        setupViews()
        makeImage(with: configuration)
        makeTitle(with: configuration)
        
        if let bg = configuration.backgroundColor {
            self.backgroundColor = bg
        }
        
        addAction(
            UIAction( handler: { _ in
                configuration.action()
            }),
            for: .touchUpInside)
    }
    
    private func makeStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 18
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
    }
    
    private func makeImage(with config: Configuration) {
        imageView.image = config.image
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isUserInteractionEnabled = false
    }
    
    private func makeTitle(with config: Configuration) {
        titleLabel.text = config.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isUserInteractionEnabled = false
    }
    
    private func setupViews() {
        self.layer.cornerRadius = 8
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.heightAnchor.constraint(equalToConstant: 44),
            
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
}

extension AuthButton {
    struct Configuration {
        let title: String
        let image: UIImage?
        let backgroundColor: UIColor?
        let action: () -> Void
    }
}
