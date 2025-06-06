//
//  APIResponse.swift
//  Todoist
//
//  Created by Artem Kriukov on 06.06.2025.
//

import Foundation

struct APIResponse: Codable {
    let total: Int
    let totalPages: Int
    let results: [UnsplashResult]
    
    enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
}
