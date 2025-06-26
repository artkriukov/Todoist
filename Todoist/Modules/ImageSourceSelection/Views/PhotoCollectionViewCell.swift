//
//  PhotoCollectionViewCell.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.06.2025.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    private var propertyAnimator: UIViewPropertyAnimator?
    
    override var isSelected: Bool {
        didSet {
            updateSelectionUI()
        }
    }
    
    // MARK: - UI
    private lazy var imageView: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 8
        element.contentMode = .scaleAspectFill
        element.clipsToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var checkmarckContainerView: UIView = {
        let element = UIView()
        element.layer.cornerRadius = 12
        element.layer.borderWidth = 1
        element.isHidden = true
        element.backgroundColor = Asset.Colors.blueColor
        element.layer.borderColor = Asset.Colors.whiteColor.cgColor
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var checkmarckImageView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(systemName: "checkmark")
        element.isHidden = true
        element.tintColor = Asset.Colors.whiteColor
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
    
    // MARK: - Public Methods
    func configureCell(with image: UIImage) {
        imageView.image = image
    }
    
    func configureCell(with imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        
        UnsplashImageService.shared.loadImage(from: url) { [weak self] image in
            self?.imageView.image = image
        }
    }
    
    private func updateSelectionUI() {
        propertyAnimator?.stopAnimation(true)
        
        propertyAnimator = UIViewPropertyAnimator(
            duration: 0.2,
            curve: .easeInOut
        ) {
            self.imageView.layer.opacity = self.isSelected ? 0.6 : 1
            self.checkmarckContainerView.isHidden = !self.isSelected
            self.checkmarckImageView.isHidden = !self.isSelected
        }
        
        propertyAnimator?.startAnimation()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
//        checkmarckImageView.image = nil
//        checkmarckContainerView.backgroundColor = nil
//        checkmarckContainerView.layer.borderColor = nil
//        checkmarckContainerView.layer.borderWidth = 0
    }
}

private extension PhotoCollectionViewCell {
    func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(checkmarckContainerView)
        checkmarckContainerView.addSubview(checkmarckImageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            checkmarckContainerView.widthAnchor.constraint(equalToConstant: 24),
            checkmarckContainerView.heightAnchor.constraint(equalToConstant: 24),
            checkmarckContainerView.trailingAnchor
                .constraint(equalTo: trailingAnchor, constant: -8),
            checkmarckContainerView.bottomAnchor
                .constraint(equalTo: bottomAnchor, constant: -8),
            
            checkmarckImageView.widthAnchor.constraint(equalToConstant: 15),
            checkmarckImageView.heightAnchor.constraint(equalToConstant: 15),
            checkmarckImageView.centerXAnchor.constraint(equalTo: checkmarckContainerView.centerXAnchor),
            checkmarckImageView.centerYAnchor.constraint(equalTo: checkmarckContainerView.centerYAnchor)

        ])
    }
}
