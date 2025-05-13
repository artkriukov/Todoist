//
//  LogsViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.05.2025.
//

import UIKit

final class LogsViewController: UIViewController {
    
    private lazy var loggsTableView: UITableView = {
        let element = UITableView()
        element.backgroundColor = UIConstants.Colors.mainBackground
        element.register(
            LogsTableViewCell.self,
            forCellReuseIdentifier: TableViewCellIdentifiers.loggsTableViewCell
            )
        element.dataSource = self
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        title = "Логи системы"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Назад",
            primaryAction: UIAction { [weak self] _ in
                self?.cancelButtonTapped()
            }
        )
    }
    
    private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

extension LogsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCellIdentifiers.loggsTableViewCell,
            for: indexPath
        ) as? LogsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = "Hello, World!"
        cell.selectionStyle = .none
        return cell
    }

}

private extension LogsViewController {
    func setupViews() {
        view.backgroundColor = UIConstants.Colors.mainBackground
        view.addSubview(loggsTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            loggsTableView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            loggsTableView.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loggsTableView.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loggsTableView.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
}
