//
//  Extension+UIStackView.swift
//  Todoist
//
//  Created by Artem Kriukov on 26.04.2025.
//

import UIKit

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat, layoutMargins: UIEdgeInsets){
        self.init()

        self.axis = axis
        self.backgroundColor = UIConstants.secondaryBackground
        self.layer.cornerRadius = 10
        self.spacing = spacing
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = layoutMargins
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
