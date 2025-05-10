//
//  UIConstants.swift
//  Todoist
//
//  Created by Artem Kriukov on 25.04.2025.
//

import UIKit

enum UIConstants {
    
    enum CustomFont {
        static func regular(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .regular)
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }
    
    enum Colors {
        static let mainBackground = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: UIColor(hexString: "#F2F2F7")
            case .dark: UIColor(hexString: "#000000")
            @unknown default:
                fatalError("Unhandled userInterfaceStyle case: \(traitCollection.userInterfaceStyle). Update mainBackground color handling.")
            }
        }
        
        static let secondaryBackground = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: UIColor(hexString: "#FFFFFF")
            case .dark: UIColor(hexString: "#1C1C1E")
            @unknown default:
                fatalError("Unhandled userInterfaceStyle case: \(traitCollection.userInterfaceStyle). Update secondaryBackground color handling.")
            }
        }
        
        static let separatorLine = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: UIColor(hexString: "#C6C6C8")
            case .dark: UIColor(hexString: "#38383A")
            @unknown default:
                fatalError("Unhandled userInterfaceStyle case: \(traitCollection.userInterfaceStyle). Update separatorLine color handling.")
            }
        }
        
        static let cardBackground = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: UIColor(hexString: "#F2F2F7")
            case .dark: UIColor(hexString: "#2C2C2E")
            @unknown default:
                fatalError("Unhandled userInterfaceStyle case: \(traitCollection.userInterfaceStyle). Update cardBackground color handling.")
            }
        }
        
        static let blueColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: UIColor(hexString: "#007AFF")
            case .dark: UIColor(hexString: "#007AFF")
            @unknown default:
                fatalError("Unhandled userInterfaceStyle case: \(traitCollection.userInterfaceStyle). Update blueColor color handling.")
            }
        }
    }
}
