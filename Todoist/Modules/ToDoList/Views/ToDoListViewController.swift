//
//  ToDoListViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit
#warning("ксли задач нет надпись задач нет в центре")
final class ToDoListViewController: UIViewController {
    
    private let itemsProvider: ToDoItemsProvider
    private var observer: Any?
    
    // MARK: - UI
    private lazy var toDoList: UITableView = {
        let element = UITableView()
        element.dataSource = self
        element.delegate = self
        element.register(
            ToDoTableViewCell.self,
            forCellReuseIdentifier: TableViewCellIdentifiers.mainToDoTableViewCell
        )
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var addItemButton: RoundedActionButton = {
        let config = RoundedActionButton.Configuration(
            image: UIImage(systemName: "plus"),
            backgroundColor: UIConstants.blueColor,
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
        itemsProvider: ToDoItemsProvider = DefaultToDoItemsProvider()
    ) {
        self.itemsProvider = itemsProvider
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
        
        observer = NotificationCenter.default
            .addObserver(
                forName: UIApplication.didBecomeActiveNotification,
                object: nil,
                queue: .main,
                using: handleNotification
            )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    private func handleNotification(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.toDoList.reloadData()
        }
    }
    
    private func addNewItemTapped() {
        let newToDoVC = NewToDoViewController(saveItem: { [weak self] newItem in
            guard let self else { return }
            try? itemsProvider.save(with: newItem)
            
            DispatchQueue.main.async {
                self.toDoList.reloadData()
            }
        })
        
        let navController = UINavigationController(rootViewController: newToDoVC)

        present(navController, animated: true)
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
            withIdentifier: TableViewCellIdentifiers.mainToDoTableViewCell,
            for: indexPath
        ) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let item = itemsProvider.getAllToDoItems()[indexPath.row]
        cell.configureCell(with: item)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Setup Views & Setup Constraints
private extension ToDoListViewController {
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(toDoList)
        view.addSubview(addItemButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            toDoList.topAnchor
                .constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            toDoList.leadingAnchor
                .constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor),
            toDoList.trailingAnchor
                .constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor),
            toDoList.bottomAnchor
                .constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
            
            addItemButton.widthAnchor.constraint(equalToConstant: 50),
            addItemButton.heightAnchor.constraint(equalToConstant: 50),
            addItemButton.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20
                           ),
            addItemButton.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20
                           ),
        ])
    }
}
