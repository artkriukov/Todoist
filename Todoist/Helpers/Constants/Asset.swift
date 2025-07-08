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
        
        static let mainBackground = UIColor.color(
            light: UIColor(hexString: "F2F2F7"),
            dark: UIColor(hexString: "000000")
        )

        static let secondaryBackground = UIColor.color(
            light: UIColor(hexString: "FFFFFF"),
            dark: UIColor(hexString: "1C1C1E")
        )
        
        static let separatorLine = UIColor.color(
            light: UIColor(hexString: "C6C6C8"),
            dark: UIColor(hexString: "38383A")
        )
        
        static let cardBackground = UIColor.color(
            light: UIColor(hexString: "F2F2F7"),
            dark: UIColor(hexString: "2C2C2E")
        )
        
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
