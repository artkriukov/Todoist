//
//  ImageSourceSelectionViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 02.06.2025.
//

import Photos
import UIKit

enum PhotoMode {
    case local, remote
}

final class ImageSourceSelectionViewController: UIViewController {
    
    // swiftlint:disable:next discouraged_optional_collection
    private var unsplashImages: [UnsplashResult]?
    private var localImages: [UIImage] = []
    private var currentVC: UIViewController?
    private var mode: PhotoMode
    
    private lazy var containerViewTopConstraint: NSLayoutConstraint = {
        containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16)
    }()
    // MARK: - UI
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
        element.delegate = self
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Init
    
    init(mode: PhotoMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
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
        requestPhotoLibraryAccess()
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
    
    private func fetchImages(with query: String) {
        UnsplashImageService.shared.fetchImages(with: query) { [weak self] results in
            DispatchQueue.main.async {
                self?.unsplashImages = results
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func configureLocalMode() {
        self.segmentedControl.selectedSegmentIndex = 0
        searchBar.isHidden = true
        containerViewTopConstraint.constant = 16
        collectionView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureRemoteMode() {
        self.segmentedControl.selectedSegmentIndex = 1
        searchBar.isHidden = false
        containerViewTopConstraint.constant = 15 + searchBar.frame.height + 16
        unsplashImages = nil
        collectionView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                self.fetchLocalPhotos()
            }
        }
    }
    
    func fetchLocalPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        let imageManager = PHCachingImageManager()
        let targetSize = CGSize(width: 150, height: 150)
        
        fetchResult.enumerateObjects { asset, _, _ in
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
                if let img = image {
                    self.localImages.append(img)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ImageSourceSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch mode {
        case .local:
            localImages.count
        case .remote:
            unsplashImages?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellIdentifiers.photoCollectionViewCell,
            for: indexPath
        ) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        switch mode {
            
        case .local:
            let image = localImages[indexPath.item]
            cell.configureCell(with: image)
        case .remote:
            
            if unsplashImages?.count == 0 {
                return cell
            } else {
                if let images = unsplashImages {
                    let unsplashImage = images[indexPath.item].urls.regular
                    cell.configureCell(with: unsplashImage)
                }
            }
        }
        
        return cell
    }
}

extension ImageSourceSelectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}

extension ImageSourceSelectionViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        view.addSubview(segmentedControl)
        view.addSubview(searchBar)
        
        view.addSubview(containerView)
        containerView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        containerViewTopConstraint = containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            segmentedControl.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            searchBar.topAnchor
                .constraint(equalTo: segmentedControl.bottomAnchor, constant: 15),
            searchBar.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            searchBar.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            containerViewTopConstraint,
            containerView.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            containerView.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.topAnchor
                .constraint(equalTo: containerView.topAnchor),
            collectionView.leadingAnchor
                .constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor
                .constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor
                .constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}

extension ImageSourceSelectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        fetchImages(with: query)
        view.endEditing(true)
    }
}

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
