//
//  LocalImageSourcePresenter.swift
//  Todoist
//
//  Created by Artem Kriukov on 08.06.2025.
//

import Photos
import UIKit

protocol LocalImageSourceProtocol: AnyObject {
    var view: LocalImageSourceViewProtocol? { get set }
    func requestPhotoLibraryAccess()
    func fetchLocalPhotos()
    func numberOfImages() -> Int
    func getLocalImages() -> [UIImage]
}

final class LocalImageSourcePresenter: LocalImageSourceProtocol {

    weak var view: LocalImageSourceViewProtocol?

    private var localImages: [UIImage] = []
    
    func requestPhotoLibraryAccess() {
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
        
        // swiftlint:disable:next syntactic_sugar
        var images = Array<UIImage?>(repeating: nil, count: fetchResult.count)
        
        fetchResult.enumerateObjects { asset, index, _ in
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            imageManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: options
            ) { image, _ in
                images[index] = image
            }
        }
        
        self.localImages = images.compactMap { $0 }
        
        DispatchQueue.main.async {
            self.view?.displayFetchedImages(self.localImages)
        }
    }
    
    func numberOfImages() -> Int {
        localImages.count
    }

    func getLocalImages() -> [UIImage] {
        localImages
    }
}
