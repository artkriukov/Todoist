//
//  UnsplashImageService.swift
//  Todoist
//
//  Created by Artem Kriukov on 06.06.2025.
//

import Foundation

final class UnsplashImageService {
    static let shared = UnsplashImageService()
    
    private init() {}
    
    func fetchImages(
        with query: String,
        completion: @escaping ([UnsplashResult]) -> Void
    ) {
        guard let request = makeRequest(with: query) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            do {
                let decodedImage = try JSONDecoder().decode(UnsplashAPIResponse.self, from: data)
                completion(decodedImage.results)
            } catch {
                completion([])
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
