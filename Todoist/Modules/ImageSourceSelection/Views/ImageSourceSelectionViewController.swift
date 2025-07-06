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

final class ImageSourceSelectionViewController: UIViewController {
    
    private let debouncer = Debouncer(delay: 0.4)
    
    private var mode: PhotoMode
    private var dataSource: ImageDataSourceProtocol?
    private var images = [ImageKey]()
    
    private var selectedImage: UIImage?
    private var page = 1
    private var isLoading = false
    
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
        mode: PhotoMode
    ) {
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
        images = []
        page = 1
        isLoading = false
        
        dataSource = LocalImageDataSource()
        self.segmentedControl.selectedSegmentIndex = 0
        searchBar.isHidden = true
        
        getImages(with: "")
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureRemoteMode() {
        dataSource = RemoteImageDataSource()
        self.segmentedControl.selectedSegmentIndex = 1
        searchBar.isHidden = false
        collectionView.reloadData()
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func getImages(with query: String, isNewSearch: Bool = false) {
        guard !isLoading else { return }
        isLoading = true

        if isNewSearch || mode == .local {
            self.images = []
            collectionView.reloadData()
        }

        dataSource?.getImages(query: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageKeys):
                self.images.append(contentsOf: imageKeys)
            case .failure:
                self.images = []
            }
            self.isLoading = false
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ImageSourceSelectionViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            images.count
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellIdentifiers.photoCollectionViewCell,
            for: indexPath
        ) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        let imageKey = images[indexPath.item]
        cell.configureCell(with: imageKey, dataSource: dataSource)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ImageSourceSelectionViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
        let selectedImageKey = images[indexPath.item]
        
        dataSource?.getImage(for: selectedImageKey) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                switch value {
                case .image(let image):
                    self.onImageReceived?(image)
                case .url(let url):
                    // если нужен url, обработайте соответствующим образом
                    break
                }
            case .failure:
                // обработка ошибки
                break
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 2, !isLoading {
            guard let query = searchBar.text else { return }
            getImages(with: query)
            view.endEditing(true)
        }
    }}

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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer.run { [weak self] in
            guard let self else { return }
            self.getImages(with: searchText, isNewSearch: true)
        }
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
