//
//  Extension+UIDatePicker.swift
//  Todoist
//
//  Created by Artem Kriukov on 26.04.2025.
//

import UIKit

extension UIDatePicker {
    convenience init(datePickerMode: UIDatePicker.Mode,
                     datePickerStyle: UIDatePickerStyle,
                     handler: @escaping (Date) -> Void)
    {
        self.init()
        self.minimumDate = Date()
        self.datePickerMode = datePickerMode
        self.preferredDatePickerStyle = datePickerStyle
        self.isHidden = true
        self.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            handler(self.date)
        }, for: .valueChanged)
    }
}
