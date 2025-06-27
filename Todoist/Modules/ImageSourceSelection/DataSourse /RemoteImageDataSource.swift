//
//  RemoteImageDataSource.swift
//  Todoist
//
//  Created by Artem Kriukov on 26.06.2025.
//

import UIKit

final class RemoteImageDataSource: ImageDataSourceProtocol {
    private var unsplashImages: [UnsplashResult] = []
    
    var isQuerySearchAvailable = true

    func getImages(
        query: String,
        page: Int,
        completion: ([ImageKey]) -> Void
    ) {

    }

    func getImage(
        for key: ImageKey,
        _ completion: (UIImage) -> Void
    ) {
        
    }

}
