//
//  SettingsItem.swift
//  Todoist
//
//  Created by Artem Kriukov on 07.07.2025.
//

import UIKit

enum SettingsItem {
    case toggle(title: String, isOn: Bool)
    case picker(title: String, selectedValue: String)
    case navigation(title: String, destination: () -> UIViewController)
}
