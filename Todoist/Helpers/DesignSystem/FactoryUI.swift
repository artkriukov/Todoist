//
//  FactoryUI.swift
//  Todoist
//
//  Created by Artem Kriukov on 03.05.2025.
//

import UIKit

final class FactoryUI {
    static let shared = FactoryUI()
    private init() {}
    
    func makeStackView(
        axis: NSLayoutConstraint.Axis = .vertical,
        spacing: CGFloat = 10,
        layoutMargins: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0),
        backgroundColor: UIColor = Asset.Colors.secondaryBackground,
        cornerRadius: CGFloat = 10,
        tamic: Bool = false
    ) -> UIStackView {
        
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.backgroundColor = backgroundColor
        stackView.layer.cornerRadius = cornerRadius
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = layoutMargins
        stackView.translatesAutoresizingMaskIntoConstraints = tamic
        return stackView
        
    }
    
    func makeTetxField(placeholder: String, tamic: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = tamic
        return textField
    }
    
    func makeDatePicker(
        mode: UIDatePicker.Mode = .date,
        style: UIDatePickerStyle = .automatic,
        minDate: Date? = nil,
        maxDate: Date? = nil,
        initialDate: Date = Date(),
        isHidden: Bool = true,
        handler: ((Date) -> Void)? = nil
    ) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = mode
        picker.preferredDatePickerStyle = style
        picker.minimumDate = minDate
        picker.maximumDate = maxDate
        picker.date = initialDate
        picker.isHidden = isHidden
        
        if let handler {
            picker.addAction(
                UIAction { [weak picker] _ in
                    guard let picker else { return }
                    handler(picker.date)
                },
                for: .valueChanged
            )
        }
        
        return picker
    }
    
    func makeStyledButton(
        title: String,
        handler: @escaping () -> Void)
    -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = Asset.Colors.secondaryBackground
        button.layer.cornerRadius = 8
        button.tintColor = .gray
        
        button.addAction(
            UIAction { _ in
                handler()
            }, for: .touchUpInside)
        
        return button
    }
    
    func makeChangePhotoAlert(
        onGalleryTap: @escaping () -> Void,
        onUnsplashTap: @escaping () -> Void
    ) -> UIAlertController {
        let actionSheet = UIAlertController(
            title: "Изменить фото",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(
            title: "Выбрать из галереи",
            style: .default,
            handler: { _ in
                onGalleryTap()
            })
        )
        
        actionSheet.addAction(UIAlertAction(
            title: "Загрузить с Unsplash",
            style: .default,
            handler: { _ in
                onUnsplashTap()
            })
        )
        
        actionSheet.addAction(UIAlertAction(
            title: "Отмена",
            style: .cancel
        ))
        
        return actionSheet
    }
}
