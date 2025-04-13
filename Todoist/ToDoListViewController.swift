//
//  ToDoListViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 05.04.2025.
//

import UIKit

final class ToDoListViewController: UIViewController {
    
    private var toDoItems: [ToDoItem] = []
    
    
    // MARK: - UI
    private lazy var toDoList: UITableView = {
        let element = UITableView()
        element.dataSource = self
        element.register(
            ToDoTableViewCell.self,
            forCellReuseIdentifier: TableViewCellIdentifiers.mainToDoTableViewCell
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
        element.addAction(
                UIAction { [weak self] _ in
                    self?.addNewItemTapped()
                },
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
    
    private func addNewItemTapped() {
        let newToDoVC = NewToDoViewController(saveItem: { [weak self] newItem in
            guard let self else { return }
            toDoItems.append(newItem)
            
            DispatchQueue.main.async {
                self.toDoList.reloadData()
            }
        })
        
        configureSheet(with: newToDoVC)

        present(newToDoVC, animated: true)
    }
    
    private func configureSheet(with viewController: UIViewController) {
        if #available(iOS 16.0, *) {
            
            if let sheet = viewController.sheetPresentationController {
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    context.maximumDetentValue * 0.2
                }
                sheet.detents = [customDetent]
                
            } else {
                assertionFailure("Не удалось получить sheetPresentationController")
            }
        } else {

            if let sheet = viewController.sheetPresentationController {
                sheet.detents = [.medium()]
            } else {
                assertionFailure("Не удалось получить sheetPresentationController")
            }
        }
        
    }
}


// MARK: - UITableViewDataSource
extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        toDoItems.count
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
        
        let item = toDoItems[indexPath.row]
        cell.configureCell(
                title: item.title,
                description: item.description,
                date: nil
            )
        
        return cell
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
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10
                           ),
            addItemButton.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10
                           ),
        ])
    }
}
