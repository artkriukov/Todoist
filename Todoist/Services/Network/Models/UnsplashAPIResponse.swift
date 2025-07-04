//
//  UnsplashAPIResponse.swift
//  Todoist
//
//  Created by Artem Kriukov on 06.06.2025.
//

import Foundation

struct UnsplashAPIResponse: Codable {
    let total: Int
    let totalPages: Int
    let results: [UnsplashResult]
    
    enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
}
