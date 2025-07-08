//
//  SettingsPresenter.swift
//  Todoist
//
//  Created by Artem Kriukov on 08.07.2025.
//

import Foundation

protocol SettingsProtocol {
    var settings: [SettingsSection] { get }
    func changeTheme(isDark: Bool)
}

struct SettingsPresenter: SettingsProtocol {
    let settings: [SettingsSection] = [
        SettingsSection(
            title: SettingsStrings.general.rawValue.localized(),
            items: [
                .toggle(
                    title: SettingsStrings.darkTheme.rawValue.localized(),
                    isOn: Theme.current == .dark),
                .navigation(
                    title: SettingsStrings.language.rawValue.localized(),
                    destination: { LanguageViewController() }
                )
            ]),
        SettingsSection(
            title: SettingsStrings.forDevelopers.rawValue.localized(),
            items: [
                .navigation(
                    title: SettingsStrings.viewLogs.rawValue.localized(),
                    destination: { LogsViewController() }
                )
            ])
    ]
    
    weak var view: SettingsViewProtocol?

    init(view: SettingsViewProtocol) {
        self.view = view
    }
    
    func changeTheme(isDark: Bool) {
        let theme: Theme = isDark ? .dark : .light
        theme.setActive()
    }

}
