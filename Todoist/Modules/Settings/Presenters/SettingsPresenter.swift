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
        SettingsSection(title: "Общие", items: [
            .toggle(title: "Черная тема", isOn: Theme.current == .dark),
            .navigation(title: "Изменить язык", destination: { LogsViewController() })
        ]),
        SettingsSection(
            title: "Разработчикам",
            items: [
                .navigation(
                    title: "Посмотреть логи",
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
        view?.didChange()
    }

}
