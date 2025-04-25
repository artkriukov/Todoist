//
//  ExpirationDateStackView.swift
//  Todoist
//
//  Created by Artem Kriukov on 25.04.2025.
//

import UIKit
#warning("add action for switcher, if switcher isOn show datePicker on NewToDoVC")

final class ExpirationDateStackView: UIView {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let switcher = UISwitch()
    private let hStackView = UIStackView()
    
    init(configuration: Configuration) {
        super.init(frame: .zero)
        
        setup(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(configuration: Configuration) {
        let imageBackgroundView = UIView()
        imageBackgroundView.backgroundColor = .red
        imageBackgroundView.layer.cornerRadius = 8
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = configuration.image
        imageView.backgroundColor = .red
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = configuration.title
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.spacing = 12
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        imageBackgroundView.addSubview(imageView)
        
        [imageBackgroundView, titleLabel, UIView(), switcher].forEach {
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
            imageView.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
}

extension ExpirationDateStackView {
    struct Configuration {
        let image: UIImage?
        let title: String
#warning("add subtitle.")
    }
}
