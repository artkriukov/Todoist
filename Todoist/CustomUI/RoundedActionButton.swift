//
//  RoundedActionButton.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.04.2025.
//

import UIKit

final class RoundedActionButton: UIControl {
    
    private let imageView = UIImageView()
    
    init(configuration: Configuration) {
        super.init(frame: .zero)
        
        setup(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(configuration: Configuration) {
        addSubview(imageView)
        
        self.backgroundColor = configuration.backgroundColor
        imageView.image = configuration.image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = configuration.backgroundColor
        clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
#warning("Подумать как задавать размер кнопки в инициализаторе класса, и тут закруглять ее")

        addAction(
            UIAction( handler: { _ in
                configuration.action()
            }),
            for: .touchUpInside)
    }
}

extension RoundedActionButton {
    struct Configuration {
        let image: UIImage?
        let backgroundColor: UIColor?
        let action: () -> Void
    }
}
