//
//  ImageLoader.swift
//  Todoist
//
//  Created by Artem Kriukov on 08.06.2025.
//

import UIKit

protocol ImageLoadingProtocol {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

class ImageLoader: ImageLoadingProtocol {
    static let shared = ImageLoader()
    private init() {}
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
