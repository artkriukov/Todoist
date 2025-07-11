//
//  UnsplashImageService.swift
//  Todoist
//
//  Created by Artem Kriukov on 06.06.2025.
//

import UIKit

enum UnsplashServiceError: Error {
    case couldNotMakeRequest
}

protocol UnsplashImageServiceProtocol {
    func fetchImages(
        with query: String,
        page: Int,
        completion: @escaping ([UnsplashResult]) -> Void
    )
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

final class UnsplashImageService: UnsplashImageServiceProtocol {
    static let shared = UnsplashImageService()
    
    private let logger: Logger
    private let perPage = 24
    private var currentTask: URLSessionDataTask?
    
    private init(logger: Logger = DependencyContainer.shared.logger) {
        self.logger = logger
    }
    
    func fetchImages(
        with query: String,
        page: Int,
        completion: @escaping ([UnsplashResult]) -> Void
    ) {
        currentTask = nil
        
        guard let request = makeRequest(with: query, page: page) else {
            self.logger
                .log(
                    "[UnsplashImageService.fetchImages]: \(UnsplashServiceError.couldNotMakeRequest)"
                )
            return
        }
        
        currentTask = URLSession.shared.dataTask(with: request) {data, _, error in
            guard let data = data,
                  error == nil else {
                
                self.logger.log(
                        "[UnsplashImageService.fetchImages]: \(UnsplashServiceError.couldNotMakeRequest)"
                    )
                return
            }
            
            do {
                let decodedImage = try JSONDecoder().decode(UnsplashAPIResponse.self, from: data)
                completion(decodedImage.results)
                
            } catch {
                
                self.logger.log("[UnsplashImageService.fetchImages]: Не удалось декодировать данные: [\(error)]")
                
            }
        }
        
        currentTask?.resume()
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            receiveOnMainThread {
                completion(image)
            }

        }.resume()
    }
    
    private func makeRequest(with query: String, page: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(string: UnsplashConstants.unsplashURLString)
        else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: "\(query)"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "client_id", value: UnsplashConstants.accessKey)
        ]
        
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}
