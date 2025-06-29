//
//  RemoteImageDataSource.swift
//  Todoist
//
//  Created by Artem Kriukov on 26.06.2025.
//

import UIKit

final class RemoteImageDataSource: ImageDataSourceProtocol {
    private let unsplashImageService: UnsplashImageServiceProtocol
    private var unsplashImages: [UnsplashResult] = []
    
    var isQuerySearchAvailable = true
    
    init(
        unsplashImageService: UnsplashImageServiceProtocol = UnsplashImageService.shared
    ) {
        self.unsplashImageService = unsplashImageService
    }

    func getImages(
        query: String,
        page: Int,
        completion: @escaping ([ImageKey]) -> Void
    ) {
        unsplashImageService.fetchImages(with: query) { [weak self] images in
            self?.unsplashImages = images
            let imageKeys = images.map { $0.id }
            receiveOnMainThread {
                completion(imageKeys)
            }
        }
    }

    func getImage(
        for key: ImageKey,
        _ completion: @escaping (UIImage) -> Void
    ) {
        guard let unsplashImages = unsplashImages.first(where: { $0.id == key }),
              let url = URL(string: unsplashImages.urls.regular) else {
            return
        }
        
        unsplashImageService.loadImage(from: url) { image in
            guard let image else { return }
            receiveOnMainThread {
                completion(image)
            }
        }
    }

}
