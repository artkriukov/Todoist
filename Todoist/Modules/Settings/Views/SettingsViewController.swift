//
//  SettingsViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 06.07.2025.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {
    func didChange()
}

final class SettingsViewController: UIViewController {

    var presenter: SettingsPresenter?
    
    // MARK: - UI
    
    private lazy var settingsTableView: UITableView = {
        let element = UITableView()
        element.backgroundColor = Asset.Colors.mainBackground
        element.layer.cornerRadius = 12
        element.dataSource = self
        element.delegate = self
        element.register(
            ToggleCell.self,
            forCellReuseIdentifier: CellIdentifiers.toggleTableViewCell
        )
        element.register(
            PickerCell.self,
            forCellReuseIdentifier: CellIdentifiers.pickerTableViewCell
        )
        element.register(
            NavigationCell.self,
            forCellReuseIdentifier: CellIdentifiers.navigationTableViewCell
        )
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupViews()
        setupConstraints()
        presenter = SettingsPresenter(view: self)
    }
    
    // MARK: - Private Methods

}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.settings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.settings[section].items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = presenter?.settings[indexPath.section].items[indexPath.row]
        
        switch item {
        case .toggle(title: let title, isOn: let isOn):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.toggleTableViewCell,
                for: indexPath
            ) as? ToggleCell else {
                return UITableViewCell()
            }
            
            cell.configureCell(with: title, isOn: isOn)
            cell.switchChanged = { [weak self] isOn in
                self?.presenter?.changeTheme(isDark: isOn)
            }
            return cell
            
        case .picker(title: let title, selectedValue: let selectedValue):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.pickerTableViewCell,
                for: indexPath
            ) as? PickerCell else {
                return UITableViewCell()
            }
            
            cell.configureCell(with: title, and: selectedValue)
            return cell
            
        case .navigation(title: let title, destination: _):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.navigationTableViewCell,
                for: indexPath
            ) as? NavigationCell else {
                return UITableViewCell()
            }
            
            cell.configureCell(with: title)
            return cell
        case .none:
            return UITableViewCell()
        }
    }

}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        presenter?.settings[section].title
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = presenter?.settings[indexPath.section].items[indexPath.row]
        
        switch item {
        case .toggle(title: _, isOn: let isOn):
            break
        case .picker(title: let title, selectedValue: let selectedValue):
            break
        case .navigation(title: _, destination: let destination):
            let vc = destination()
            navigationController?.pushViewController(vc, animated: true)
        case .none:
            break
        }
    }
}

// MARK: - Setup Views & Setup Constraints
private extension SettingsViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        view.addSubview(settingsTableView)
        navigationItem.title = ProfileStrings.settings.rawValue.localized()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            settingsTableView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15),
            settingsTableView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -15),
            settingsTableView.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
}

extension SettingsViewController: SettingsViewProtocol {
    func didChange() {
        
    }
}
