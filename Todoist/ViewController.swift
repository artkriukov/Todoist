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
        ToDoItem(title: "Позвонить куда нибудь", description: nil),
        ToDoItem(title: "Купить молоко", description: "2 литра"),
        ToDoItem(title: "Позвонить куда нибудь", description: nil),
        ToDoItem(title: "Купить молоко", description: "2 литра"),
        ToDoItem(title: "Позвонить куда нибудь", description: nil),
        ToDoItem(title: "Купить молоко", description: "2 литра"),
        ToDoItem(title: "Позвонить куда нибудь", description: nil),
        ToDoItem(title: "Купить молоко", description: "2 литра"),
        ToDoItem(title: "Позвонить куда нибудь", description: nil),
        ToDoItem(title: "Купить молоко", description: "2 литра"),
        ToDoItem(title: "Позвонить куда нибудь", description: nil),
        ToDoItem(title: "Купить молоко", description: "2 литра"),
        ToDoItem(title: "Позвонить куда нибудь", description: nil),
        ToDoItem(title: "Купить молоко", description: "2 литра"),
        ToDoItem(title: "Позвонить куда нибудь", description: nil),
        ToDoItem(title: "Купить молоко", description: "2 литра"),
        ToDoItem(title: "Позвонить куда нибудь", description: nil),
        ToDoItem(title: "Купить молоко", description: "2 литра"),
        ToDoItem(title: "Позвонить куда нибудь", description: nil),
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
    
    private lazy var addItemButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(UIImage(systemName: "plus"), for: .normal)
        element.backgroundColor = .systemRed
        element.layer.cornerRadius = 25
        element.tintColor = .white
        element
            .addTarget(
                self,
                action: #selector(addNewItemTapped),
                for: .touchUpInside
            )
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }
    
    @objc private func addNewItemTapped() {
        let newToDoVC = NewToDoViewController()
        newToDoVC.modalPresentationStyle = .popover
        present(newToDoVC, animated: true)
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
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10
                           ),
            addItemButton.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10
                           ),
        ])
    }
}
