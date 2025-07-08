//
//  Theme.swift
//  Todoist
//
//  Created by Artem Kriukov on 08.07.2025.
//

import UIKit

enum Theme: Int, CaseIterable {
    case light = 0
    case dark
}

extension Theme {
    private static let appThemeKey = "app_theme"
    
    func save() {
        UserDefaults.standard.set(rawValue, forKey: Theme.appThemeKey)
    }
    
    static var current: Theme {
        let value = UserDefaults.standard.integer(forKey: appThemeKey)
        return Theme(rawValue: value) ?? .light
    }
}

extension Theme {
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    func setActive() {
        save()
        
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            windowScene.windows.forEach { $0.overrideUserInterfaceStyle = userInterfaceStyle }
        }
    }
}
