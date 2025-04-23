//
//  ExpirationChecker.swift
//  Todoist
//
//  Created by Artem Kriukov on 20.04.2025.
//

import Foundation

protocol ExpirationChecker {
    func check(date: Date) -> ExpirationStatus
}
