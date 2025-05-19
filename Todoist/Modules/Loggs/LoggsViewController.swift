//
//  LogsViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.05.2025.
//

import UIKit


final class LogsViewController: UIViewController {
    
    private let logger: Logger
    private var logs: [String] = []
    
    // MARK: - UI
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
    
    // MARK: - UI
    
    init(logger: Logger = DependencyContainer.shared.logger) {
        self.logger = logger
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        configureNavigationBar()
        
        loadLogs()
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
    
    private func loadLogs() {
        if let fileLogger = DependencyContainer.shared.logger as? FileLogger {
            logs = fileLogger.getLogs()
        } else if let combinedLogger = DependencyContainer.shared.logger as? CombinedLogger {
            for logger in combinedLogger.loggers {
                if let fileLogger = logger as? FileLogger {
                    logs = fileLogger.getLogs()
                    break
                }
            }
        }
    }
}

extension LogsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCellIdentifiers.loggsTableViewCell,
            for: indexPath
        ) as? LogsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: logs[indexPath.row])
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
