//
//  SettingsViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 06.07.2025.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupViews()
        setupConstraints()
        
        loadDataFromUserDefoults()
    }
    
    private func loadDataFromUserDefoults() {
        
    }
}

private extension SettingsViewController {
    func setupViews() {
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
