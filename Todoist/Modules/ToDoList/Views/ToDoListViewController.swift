//
//  ToDoListViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import FirebaseAnalytics
import SwiftUI
import UIKit

final class ToDoListViewController: UIViewController {
    
    private let itemsProvider: ToDoItemsProvider
    private let toDoService: ToDoService
    private var observer: Any?
    private let logger: Logger
    // MARK: - UI
    
    private lazy var emptyLabel: UILabel = {
        let element = UILabel()
        element.text = "Задач нет"
        element.textColor = .lightGray
        element.isHidden = true
        element.font = Asset.CustomFont.medium(size: 27)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var toDoList: UITableView = {
        let element = UITableView()
        element.dataSource = self
        element.delegate = self
        element.register(
            ToDoTableViewCell.self,
            forCellReuseIdentifier: CellIdentifiers.mainToDoTableViewCell
        )
        element.rowHeight = UITableView.automaticDimension
        element.estimatedRowHeight = 100
        element.backgroundColor = Asset.Colors.mainBackground
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var addItemButton: RoundedActionButton = {
        let config = RoundedActionButton.Configuration(
            image: UIImage(systemName: "plus"),
            backgroundColor: Asset.Colors.blueColor,
            action: { [weak self] in
                self?.addNewItemTapped()
            })
        let element = RoundedActionButton(configuration: config)
        element.layer.cornerRadius = 25
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Init
    
    init(
        itemsProvider: ToDoItemsProvider = DefaultToDoItemsProvider(),
        toDoService: ToDoService = ToDoService(),
        logger: Logger = DependencyContainer.shared.logger
    ) {
        self.itemsProvider = itemsProvider
        self.toDoService = toDoService
        self.logger = logger
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        logger.log("ToDoListViewController loaded")
        
        setupViews()
        setupConstraints()
        checkTasks()
        
        observer = NotificationCenter.default
            .addObserver(
                forName: UIApplication.didBecomeActiveNotification,
                object: nil,
                queue: .main,
                using: handleNotification
            )
        
        Analytics.logEvent("screen_opened", parameters: [
            "screen_name": "todo_list"
        ])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    private func handleNotification(_ notification: Notification) {
        receiveOnMainThread { [weak self] in
            self?.toDoList.reloadData()
        }
    }
    
    private func addNewItemTapped() {
        let newToDoVC = NewToDoViewController(saveItem: { [weak self] newItem in
            guard let self else { return }
            try? itemsProvider.save(with: newItem)
            self.checkTasks()
            
            receiveOnMainThread {
                self.toDoList.reloadData()
            }
            
            Analytics.logEvent("task_created", parameters: [
                "source": "todo_list"
            ])
        })
        
        let navController = UINavigationController(rootViewController: newToDoVC)
        
        present(navController, animated: true)
    }
    
    private func checkTasks() {
        emptyLabel.isHidden = !itemsProvider.getAllToDoItems().isEmpty
    }
}

// MARK: - UITableViewDataSource
extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        itemsProvider.getAllToDoItems().count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellIdentifiers.mainToDoTableViewCell,
            for: indexPath
        ) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.handlerButtonTapped = { [weak self] in
            guard let self = self else { return }
            guard let currentIndexPath = tableView.indexPath(for: cell) else { return }
            
            self.itemsProvider.removeItem(at: currentIndexPath.row)
            
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [currentIndexPath], with: .automatic)
            }, completion: { _ in
                self.checkTasks()
            })
        }
        
        let item = itemsProvider.getAllToDoItems()[indexPath.row]
        cell.configureCell(with: item)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ToDoListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedToDo = itemsProvider.getAllToDoItems()[indexPath.row]
        let detailView = DetailToDoView(toDo: selectedToDo)
        let hostingVC = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingVC, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: GlobalStrings.delete.rawValue.localized()
        ) { _, _, completionHandler in
            
            self.itemsProvider.removeItem(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.checkTasks()
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - Setup Views & Setup Constraints
private extension ToDoListViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground
        
        view.addSubview(toDoList)
        view.addSubview(emptyLabel)
        view.addSubview(addItemButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                
                emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                toDoList.topAnchor
                    .constraint(
                        equalTo: view.safeAreaLayoutGuide.topAnchor,
                        constant: 15
                    ),
                toDoList.leadingAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                toDoList.trailingAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                toDoList.bottomAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                
                addItemButton.widthAnchor.constraint(equalToConstant: 50),
                addItemButton.heightAnchor.constraint(equalToConstant: 50),
                addItemButton.trailingAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                addItemButton.bottomAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ]
        )
    }
}
