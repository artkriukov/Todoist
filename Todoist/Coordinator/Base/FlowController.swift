//
//  FlowController.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.07.2025.
//

import Foundation

// Когда модуль заканчивает свою работу, ему по завершению, нужно будет передать какие то данные по этому протоколу

protocol FlowController {
    associatedtype T
    var completionHandler: ((T, T) -> Void)? { get set }
    var onBack: (() -> Void)? { get set }
}
