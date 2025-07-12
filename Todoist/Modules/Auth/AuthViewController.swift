//
//  AuthViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 12.07.2025.
//

import UIKit

final class AuthViewController: UIViewController {
    private let mode: AuthMode
    
    // MARK: - UI
    private lazy var infoStackView = FactoryUI.shared.makeStackView()
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.font = Asset.CustomFont.medium(size: 24)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var descrLabel: UILabel = {
        let element = UILabel()
        element.font = Asset.CustomFont.regular(size: 17)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    // MARK: - Init
    init(mode: AuthMode) {
        self.mode = mode
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
        configureViewController(with: mode)
    }
    
    private func configureViewController(with mode: AuthMode) {
        switch mode {
        case .signIn:
            titleLabel.text = "Войти"
        case .signUp:
            titleLabel.text = "Зарегистрироваться"
        }
    }
}

// MARK: - Setup Views & Setup Constraints
private extension AuthViewController {
    func setupViews() {
        view.backgroundColor = Asset.Colors.mainBackground

    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([

        ])
    }
}
