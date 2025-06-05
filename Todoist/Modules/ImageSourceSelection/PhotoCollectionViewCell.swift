//
//  PhotoCollectionViewCell.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.06.2025.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI
    private lazy var imageView: UIImageView = {
        let element = UIImageView()
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension PhotoCollectionViewCell {
    func setupViews() {
        contentView.addSubview(imageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
