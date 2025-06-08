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
        
        fetchResult.enumerateObjects { asset, _, _ in
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            imageManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: options
            ) { image, _ in
                if let img = image {
                    self.localImages.append(img)
                }
            }
        }
        
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
