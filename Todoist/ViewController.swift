//
//  ViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit

final class ViewController: UIViewController {
    
    private var toDoItems = [ToDoItem]()
    
    // MARK: - UI
    private lazy var toDoList: UITableView = {
        let element = UITableView()
        element.dataSource = self
        element.register(
            ToDoTableViewCell.self,
            forCellReuseIdentifier: ToDoTableViewCell.indetifer
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
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ToDoTableViewCell.indetifer,
            for: indexPath
        )
        
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
