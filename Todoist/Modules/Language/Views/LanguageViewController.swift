//
//  LanguageViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 08.07.2025.
//

import UIKit

final class LanguageViewController: UIViewController {
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let element = UITableView()
        element.dataSource = self
        element.register(
            LanguageTableViewCell.self,
            forCellReuseIdentifier: CellIdentifiers.languageTableViewCell
        )
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConsraints()
    }
}

extension LanguageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Language.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellIdentifiers.languageTableViewCell,
            for: indexPath
        ) as? LanguageTableViewCell else {
            return UITableViewCell()
        }
        
        let language = Language.allCases[indexPath.row]
        cell.configure(with: language)
        return cell
    }
}

private extension LanguageViewController {
    func setupViews() {
        view.addSubview(tableView)
    }
    
    func setupConsraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: 10
                ),
            tableView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: 15),
            tableView.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
