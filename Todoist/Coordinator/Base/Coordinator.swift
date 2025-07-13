//
//  Coordinator.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.07.2025.
//

import UIKit

typealias CoordinatorHandler = () -> Void

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set}
    var completionHandler: CoordinatorHandler? { get set }
    
    func start()
}
