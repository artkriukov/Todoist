//
//  LocalImageDataSource.swift
//  Todoist
//
//  Created by Artem Kriukov on 26.06.2025.
//

import Photos
import UIKit

final class LocalImageDataSource: ImageDataSourceProtocol {
    var isQuerySearchAvailable = false

    func getImages(
        query _: String,
        page _: Int,
        completion: @escaping ([ImageKey]) -> Void
    ) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            fetchLocalPhotos(completion: completion)
        case .notDetermined:
            requestPhotoLibraryAccess(completion: completion)
        default:
            completion([])
        }
    }

    func getImage(
        for key: ImageKey,
        _ completion: @escaping (UIImage, URL?) -> Void
    ) {
        
        guard let asset = PHAsset.fetchAssets(
            withLocalIdentifiers: [key],
            options: nil
        ).firstObject else {
            return
        }
        
        let option = PHImageRequestOptions()
        option.deliveryMode = .opportunistic
        option.isNetworkAccessAllowed = true
        
        let targetSize = CGSize(width: 150, height: 150)
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: option
        ) { image, _ in
            guard let image else { return }
            
            receiveOnMainThread {
                completion(image, nil)
            }
            
        }
    }
    
    private func requestPhotoLibraryAccess(
        completion: @escaping ([ImageKey]) -> Void
    ) {
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                self.fetchLocalPhotos(completion: completion)
            } else {
                completion([])
            }
        }
        
    }

    private func fetchLocalPhotos(completion: @escaping ([ImageKey]) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(
            key: "creationDate",
            ascending: false
        )]
        
        let fetchResult = PHAsset.fetchAssets(
            with: .image,
            options: fetchOptions
        )
        
        var identifiers: [ImageKey] = []
        fetchResult.enumerateObjects { asset, _, _ in
            identifiers.append(asset.localIdentifier)
        }
        
        receiveOnMainThread {
            completion(identifiers)
        }
    }
}
