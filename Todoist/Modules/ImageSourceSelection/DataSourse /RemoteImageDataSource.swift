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
    private var page = 1
    
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
        unsplashImageService
            .fetchImages(with: query, page: page) { [weak self] images in
            self?.unsplashImages.append(contentsOf: images)
            let imageKeys = images.map { $0.id }
            receiveOnMainThread {
                completion(imageKeys)
                self?.page += 1
            }
        }
    }

    func getImage(
        for key: ImageKey,
        _ completion: @escaping (UIImage, URL?) -> Void
    ) {
        guard let unsplashImages = unsplashImages.first(where: { $0.id == key }),
              let url = URL(string: unsplashImages.urls.regular) else {
            return
        }
        
        unsplashImageService.loadImage(from: url) { image in
            guard let image else { return }
            receiveOnMainThread {
                completion(image, url)
            }
        }
    }

}
