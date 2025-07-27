//
//  Debouncer.swift
//  Todoist
//
//  Created by Artem Kriukov on 30.06.2025.
//

import Foundation

final class Debouncer {
    private var timer: Timer?
    private let delay: TimeInterval
    
    init(delay: TimeInterval) {
        self.delay = delay
    }
    
    func run(action: @escaping () -> Void) {
        cancelTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            action()
        }
    }
    
    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
}
