//
//  Extension+Date.swift
//  Todoist
//
//  Created by Artem Kriukov on 29.06.2025.
//

import Foundation

extension Date {
    func formattedShort() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
}
