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
    private var lastQuery: String = ""

    var isQuerySearchAvailable = true

    init(
        unsplashImageService: UnsplashImageServiceProtocol = UnsplashImageService.shared
    ) {
        self.unsplashImageService = unsplashImageService
    }

    func getImages(
        query: String,
        completion: @escaping (GetImagesResult) -> Void
    ) {
        if lastQuery != query {
            page = 1
            unsplashImages = []
            lastQuery = query
        }

        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            DispatchQueue.main.async {
                completion(.success([]))
            }
            return
        }
        unsplashImageService.fetchImages(with: query, page: page) { [weak self] images in
            guard let self = self else { return }
            if images.isEmpty {
                DispatchQueue.main.async {
                    completion(.failure(.noImagesFound))
                }
                return
            }
            self.unsplashImages.append(contentsOf: images)
            let imageKeys = images.map { $0.id }
            DispatchQueue.main.async {
                completion(.success(imageKeys))
                self.page += 1
            }
        }
    }
    
    func getImage(
        for key: ImageKey,
        _ completion: @escaping (GetImageResult) -> Void
    ) {
        guard let unsplashImage = unsplashImages.first(where: { $0.id == key }),
              let url = URL(string: unsplashImage.urls.regular) else {
            completion(.failure(.noImagesFound))
            return
        }
        unsplashImageService.loadImage(from: url) { image in
            DispatchQueue.main.async {
                if let image = image {
                    completion(.success(.image(image)))
                } else {
                    completion(.success(.url(url)))
                }
            }
        }
    }
}
