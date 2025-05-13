//
//  LogsTableViewCell.swift
//  Todoist
//
//  Created by Artem Kriukov on 13.05.2025.
//

import UIKit

final class LogsTableViewCell: UITableViewCell {

    // MARK: - UI
    
    private lazy var logLabel: UILabel = {
        let element = UILabel()
        element.numberOfLines = 0
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
