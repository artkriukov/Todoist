//
//  UnsplashImageService.swift
//  Todoist
//
//  Created by Artem Kriukov on 06.06.2025.
//

import Foundation

enum UnsplashServiceError: Error {
    case couldNotMakeRequest
}

final class UnsplashImageService {
    static let shared = UnsplashImageService()
    
    let logger: Logger
    
    private init(logger: Logger = DependencyContainer.shared.logger) {
        self.logger = logger
    }
    
    func fetchImages(
        with query: String,
        completion: @escaping ([UnsplashResult]) -> Void
    ) {
        guard let request = makeRequest(with: query) else {
            self.logger
                .log(
                    "[UnsplashImageService.fetchImages]: \(UnsplashServiceError.couldNotMakeRequest)"
                )
            return
        }
        
        URLSession.shared.dataTask(with: request) {data, _, error in
            guard let data = data,
                  error == nil else {
                
                self.logger
                    .log(
                        "[UnsplashImageService.fetchImages]: \(UnsplashServiceError.couldNotMakeRequest)"
                    )
                return
            }
            
            do {
                let decodedImage = try JSONDecoder().decode(UnsplashAPIResponse.self, from: data)
                completion(decodedImage.results)
                self.logger.log("[UnsplashImageService.fetchImages]: Данные успешно декодированы")
            } catch {
                
                self.logger.log("[UnsplashImageService.fetchImages]: Не удалось декодировать данные: [\(error)]")
                
            }
        }.resume()
    }
    
    private func makeRequest(with query: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: UnsplashConstants.unsplashURLString)
        else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: "\(query)"),
            URLQueryItem(name: "client_id", value: UnsplashConstants.accessKey)
        ]
        
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}
