//
//  ImageDataSource.swift
//  Todoist
//
//  Created by Artem Kriukov on 26.06.2025.
//

import UIKit

typealias ImageKey = String

protocol ImageDataSourceProtocol: AnyObject {
    var isQuerySearchAvailable: Bool { get }
    
    func getImages(
        query: String,
        page: Int,
        completion: @escaping ([ImageKey]) -> Void
    )
    
    func getImage(
        for key: ImageKey,
        _ completion: @escaping (UIImage) -> Void
    )
}
