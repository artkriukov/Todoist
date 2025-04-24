//
//  DefaultExpirationChecker.swift
//  Todoist
//
//  Created by Artem Kriukov on 20.04.2025.
//

import Foundation

struct DefaultExpirationChecker: ExpirationChecker {
    private let dateProvider: () -> Date
    
    init(dateProvider: @autoclosure @escaping () -> Date = Date.now) {
        self.dateProvider = dateProvider
    }
    
    func check(date: Date) -> ExpirationStatus {
        let currentDate = dateProvider()
        let timeInterval = currentDate.distance(to: date)
        
        if timeInterval < 0 {
            return .failed
        } else if timeInterval <= 1800 { // 30 minute
            return .lessThanHalfHour
        } else {
            return .moreThanHalfHour
        }
    }

    
}
