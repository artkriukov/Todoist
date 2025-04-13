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
        imageView.image = configuration.image
//        addAction(configuration.action, for: .touchUpInside)
    }
}

extension RoundedActionButton {
    struct Configuration {
        let title: String?
        let image: UIImage?
        let action: () -> Void
    }
}
