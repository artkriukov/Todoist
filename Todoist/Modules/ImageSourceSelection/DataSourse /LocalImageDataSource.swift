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
        completion: @escaping (GetImagesResult) -> Void
    ) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            fetchLocalPhotos(completion: completion)
        case .notDetermined:
            requestPhotoLibraryAccess(completion: completion)
        default:
            completion(.failure(.noImagesFound))
        }
    }

    func getImage(
        for key: ImageKey,
        _ completion: @escaping (GetImageResult) -> Void
    ) {
        let assets = PHAsset.fetchAssets(
            withLocalIdentifiers: [key],
            options: nil
        )
        guard let asset = assets.firstObject else {
            completion(.failure(.noImagesFound))
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
            receiveOnMainThread {
                if let image = image {
                    completion(.success(.image(image)))
                } else {
                    completion(.failure(.noImagesFound))
                }
            }
        }
    }

    private func requestPhotoLibraryAccess(
        completion: @escaping (GetImagesResult) -> Void
    ) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                self.fetchLocalPhotos(completion: completion)
            } else {
                completion(.failure(.noImagesFound))
            }
        }
    }

    private func fetchLocalPhotos(
        completion: @escaping (GetImagesResult) -> Void
    ) {
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
            if identifiers.isEmpty {
                completion(.failure(.noImagesFound))
            } else {
                completion(.success(identifiers))
            }
        }
    }
}
