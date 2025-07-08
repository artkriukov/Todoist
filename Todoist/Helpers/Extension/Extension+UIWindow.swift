//
//  Extension+UIWindow.swift
//  Todoist
//
//  Created by Artem Kriukov on 08.07.2025.
//

import UIKit

extension UIWindow {
    func initTheme() {
        overrideUserInterfaceStyle = Theme.current.userInterfaceStyle
    }
}
