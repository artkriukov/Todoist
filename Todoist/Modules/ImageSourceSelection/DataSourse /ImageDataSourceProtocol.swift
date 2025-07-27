//
//  ImageDataSource.swift
//  Todoist
//
//  Created by Artem Kriukov on 26.06.2025.
//

import UIKit

typealias ImageKey = String

typealias GetImagesResult = Result<[ImageKey], ImageDataSourceError>
typealias GetImageResult = Result<ImageDataSourceResult, ImageDataSourceError>

enum ImageDataSourceError: Error {
    case noImagesFound
}

enum ImageDataSourceResult {
    case image(UIImage)
    case url(URL)
}

protocol ImageDataSourceProtocol: AnyObject {
    var isQuerySearchAvailable: Bool { get }
    
    func getImages(
        query: String,
        completion: @escaping (GetImagesResult) -> Void
    )
    
    func getImage(
        for key: ImageKey,
        _ completion: @escaping (GetImageResult) -> Void
    )
}
