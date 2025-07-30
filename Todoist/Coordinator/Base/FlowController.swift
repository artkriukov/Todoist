//
//  FlowController.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.07.2025.
//

import Foundation

protocol FlowController {
    // swiftlint:disable:next type_name
    associatedtype T
    var completionHandler: ((T, T) -> Void)? { get set }
    var onBack: (() -> Void)? { get set }
}
