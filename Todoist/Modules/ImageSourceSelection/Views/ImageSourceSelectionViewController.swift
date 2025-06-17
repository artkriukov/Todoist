//
//  ImageSourceSelectionViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 02.06.2025.
//

import UIKit

enum PhotoMode {
    case local, remote
}

protocol LocalImageSourceViewProtocol: AnyObject {
    func displayFetchedImages(_ images: [UIImage])
}

protocol RemoteImageSourceViewProtocol: AnyObject {
    func displayFetchedImages(_ images: [UnsplashResult])
}

final class ImageSourceSelectionViewController: UIViewController {
    
    private var mode: PhotoMode
    private let remoteImageSourcePresenter: RemoteImageSourceProtocol?
    private let localImageSourcePresenter: LocalImageSourceProtocol?
    private var selectedImage: UIImage?
    
    var onImageReceived: ((UIImage) -> Void)?
    // MARK: - UI
    
    private lazy var stackView: UIStackView = {
        let element = UIStackView()
        element.spacing = 10
        element.axis = .vertical
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let element = UISegmentedControl(items: ["Загрузить с устройства", "Загрузить из сети"])
        element.addAction(
            UIAction { _ in
                self.segmentChanged(self.segmentedControl)
            }, for: .valueChanged)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var containerView: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 125, height: 75)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let element = UICollectionView(frame: .zero, collectionViewLayout: layout)
        element.backgroundColor = Asset.Colors.mainBackground
        element.showsVerticalScrollIndicator = false
        element.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: CellIdentifiers.photoCollectionViewCell
        )
        element.dataSource = self
        element.delegate = self
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var searchBar: UISearchBar = {
        let element = UISearchBar()
        element.placeholder = "Найти картинку"
        element.searchBarStyle = .minimal
        element.clipsToBounds = true
        element.delegate = self
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Init
    
    init(
        mode: PhotoMode,
        remoteImageSourcePresenter: RemoteImageSourcePresenter = RemoteImageSourcePresenter(),
        localImageSourcePresenter: LocalImageSourceProtocol = LocalImageSourcePresenter()
    ) {
        self.mode = mode
        self.remoteImageSourcePresenter = remoteImageSourcePresenter
        self.localImageSourcePresenter = localImageSourcePresenter
        super.init(nibName: nil, bundle: nil)
        self.remoteImageSourcePresenter?.view = self
        self.localImageSourcePresenter?.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        switchMode(to: mode)
        localImageSourcePresenter?.requestPhotoLibraryAccess()
    }
    
    // MARK: - Private Methods
    private func segmentChanged(_ sender: UISegmentedControl) {
        let selectedMode: PhotoMode = sender.selectedSegmentIndex == 0 ? .local : .remote
        switchMode(to: selectedMode)
    }
    
    private func switchMode(to newMode: PhotoMode) {
        self.mode = newMode
        
        switch newMode {
        case .local:
            configureLocalMode()
        case .remote:
            configureRemoteMode()
        }
    }
    
    private func configureLocalMode() {
        self.segmentedControl.selectedSegmentIndex = 0
        searchBar.isHidden = true
        collectionView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureRemoteMode() {
        self.segmentedControl.selectedSegmentIndex = 1
        searchBar.isHidden = false
        
        collectionView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ImageSourceSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch mode {
        case .local:
            localImageSourcePresenter?.numberOfImages() ?? 0
        case .remote:
            remoteImageSourcePresenter?.numberOfImages() ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellIdentifiers.photoCollectionViewCell,
            for: indexPath
        ) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        switch mode {
            
        case .local:
            let localImages = localImageSourcePresenter?.getLocalImages()[indexPath.item]
            
            guard let image = localImages else {
                return UICollectionViewCell()
            }
            
            cell.configureCell(with: image)
        case .remote:
            
            if remoteImageSourcePresenter?.numberOfImages() == 0 {
                return cell
            } else {
                if let images = remoteImageSourcePresenter?.getUnsplashImages() {
                    let unsplashImage = images[indexPath.item].urls.regular
                    cell.configureCell(with: unsplashImage)
                }
            }
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ImageSourceSelectionViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
        switch mode {
            
        case .local:
            
            let localImages = localImageSourcePresenter?.getLocalImages()
            selectedImage = localImages?[indexPath.item]
            
            
            if let selectedImage = selectedImage {
                onImageReceived?(selectedImage)
            }
            
        case .remote: break
        }
        
    }
}

// MARK: - RemoteImageSourceViewProtocol & LocalImageSourceViewProtocol
extension ImageSourceSelectionViewController: RemoteImageSourceViewProtocol, LocalImageSourceViewProtocol {
    func displayFetchedImages(_ images: [UIImage]) {
        collectionView.reloadData()
    }
    
    func displayFetchedImages(_ images: [UnsplashResult]) {
        collectionView.reloadData()
    }
}

// MARK: - Setup Views & Setup Constraints
extension ImageSourceSelectionViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(segmentedControl)
        stackView.addArrangedSubview(searchBar)
        
        stackView.addArrangedSubview(containerView)
        containerView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            stackView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15 ),
            stackView.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            stackView.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            segmentedControl.heightAnchor.constraint(equalToConstant: 34),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            containerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}

// MARK: - UISearchBarDelegate
extension ImageSourceSelectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        remoteImageSourcePresenter?.fetchRemoteImages(with: query)
        view.endEditing(true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImageSourceSelectionViewController: UICollectionViewDelegateFlowLayout {
    // swiftlint:disable:next line_length
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsInRow: CGFloat = 3
        let spacing: CGFloat = 10
        let sectionInsets = (
            collectionViewLayout as? UICollectionViewFlowLayout
        )?.sectionInset ?? .zero
        
        let totalSpacing = sectionInsets.left + sectionInsets.right + spacing * (
            itemsInRow - 1
        )
        let availableWidth = collectionView.bounds.width - totalSpacing
        let  itemWidth = floor(availableWidth / itemsInRow)
        
        return CGSize(width: itemWidth, height: itemWidth)
        
    }
}
