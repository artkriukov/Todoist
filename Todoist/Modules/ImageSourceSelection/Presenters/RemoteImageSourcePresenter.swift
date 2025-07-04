//
//  RemoteImageSourcePresenter.swift
//  Todoist
//
//  Created by Artem Kriukov on 08.06.2025.
//

import Foundation

protocol RemoteImageSourceProtocol: AnyObject {
    var view: RemoteImageSourceViewProtocol? { get set }
    func fetchRemoteImages(with query: String)
    func numberOfImages() -> Int
    func getUnsplashImages() -> [UnsplashResult]
}

final class RemoteImageSourcePresenter: RemoteImageSourceProtocol {
    weak var view: RemoteImageSourceViewProtocol?
    
    private var unsplashImages: [UnsplashResult] = []
    
    func fetchRemoteImages(with query: String) {
        unsplashImages = []
        view?.displayFetchedImages([])
        
        UnsplashImageService.shared.fetchImages(with: query) { [weak self] results in
            DispatchQueue.main.async {
                self?.unsplashImages = results
                self?.view?.displayFetchedImages(results)
            }
        }
    }
    
    func numberOfImages() -> Int {
        unsplashImages.count
    }
    
    func getUnsplashImages() -> [UnsplashResult] {
        unsplashImages
    }
}
