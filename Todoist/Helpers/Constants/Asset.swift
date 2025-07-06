//
//  Asset.swift
//  Todoist
//
//  Created by Artem Kriukov on 25.04.2025.
//

import UIKit

enum Asset {
    
    enum CustomFont {
        static func regular(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .regular)
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .regular)
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .bold)
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
        
        static let blueColor = UIColor(hexString: "#007AFF")
        static let whiteColor = UIColor(hexString: "#FFFFFF")
        static let lightGrayColor = UIColor(hexString: "#D1D1D6")
        static let imagePlaceholderBackground = UIColor(hexString: "#E5E5EA")
        static let imagePlaceholderTint = UIColor(hexString: "#AEAEB2")
    }
    
    enum Images {
        static let defaultUserImage = UIImage(systemName: "person.circle.fill")
        static let defaultBackgroundImage = UIImage(systemName: "photo")
        static let circle = UIImage(systemName: "circle")
        static let chevron = UIImage(systemName: "chevron.forward")
        static let settings = UIImage(systemName: "gearshape.fill")
        static let edit = UIImage(systemName: "pencil")
    }
}
