//
//  DispatchUtils.swift
//  Todoist
//
//  Created by Artem Kriukov on 26.06.2025.
//

import Foundation

func receiveOnMainThread(_ completion: @escaping () -> Void) {
    if Thread.isMainThread {
        completion()
    } else {
        DispatchQueue.main.async {
            completion()
        }
    }
}
