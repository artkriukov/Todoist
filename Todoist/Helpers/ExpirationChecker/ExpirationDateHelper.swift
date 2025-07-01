//
//  ExpirationDateHelper.swift
//  Todoist
//
//  Created by Artem Kriukov on 01.07.2025.
//

import SwiftUI
import UIKit

struct ExpirationDateHelper {
    // swiftlint:disable:next large_tuple
    func getExpirationDate(for date: Date?) -> (
        text: String,
        uiColor: UIColor,
        color: Color
    ) {
        
        guard let date else {
            return ("", .systemGray, .red)
        }
        
        let checker = DefaultExpirationChecker()
        let timeLabel = date.formattedShort()
        
        switch checker.check(date: date) {
        case .moreThanHalfHour:
            return (timeLabel, .systemGreen, .green)
        case .lessThanHalfHour:
            return (timeLabel, .systemYellow, .yellow)
        case .failed:
            return ("Просрочено", .systemRed, .red)
        }
    }
}
