//
//  Extension+UITextField.swift
//  Todoist
//
//  Created by Artem Kriukov on 25.04.2025.
//

import UIKit

extension UITextField {
    convenience init(placeholder: String) {
        self.init()
        
        self.placeholder = placeholder
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
