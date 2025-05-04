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
            UIFont.systemFont(ofSize: size, weight: .medium)
        }
    }
    
    static let mainBackground = UIColor.systemGroupedBackground
    static let secondaryBackground = UIColor.secondarySystemGroupedBackground
    static let separatorLine = UIColor.separator
    static let cardBackground = UIColor.tertiarySystemGroupedBackground
    
    static let blueColor = UIColor.systemBlue
}
