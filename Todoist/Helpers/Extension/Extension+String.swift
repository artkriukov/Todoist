//
//  Extension+String.swift
//  Todoist
//
//  Created by Artem Kriukov on 02.07.2025.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
}
