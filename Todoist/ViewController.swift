//
//  ViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit

final class ViewController: UIViewController {
    
    private var toDoItems: [ToDoItem] = [
        ToDoItem(title: "Купить молоко", description: "2 литра"),
        ToDoItem(title: "Позвонить куда нибудь", description: nil)
    ]
    
    // MARK: - UI
    private lazy var toDoList: UITableView = {
        let element = UITableView()
        element.dataSource = self
        element.register(
            ToDoTableViewCell.self,
            forCellReuseIdentifier: ToDoTableViewCell.identifier
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
        
        toDoItems.append(ToDoItem(title: "Hello", description: "World"))
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        toDoItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:ToDoTableViewCell.identifier,
            for: indexPath
        ) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let item = toDoItems[indexPath.row]
        cell.configureCell(title: item.title, description: item.description)
        
        return cell
    }
}

// MARK: - Setup Views & Setup Constraints
private extension ViewController {
    func setupViews() {
        view.addSubview(toDoList)
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
        ])
    }
}
