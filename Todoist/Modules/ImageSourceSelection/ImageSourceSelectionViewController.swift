//
//  ImageSourceSelectionViewController.swift
//  Todoist
//
//  Created by Artem Kriukov on 02.06.2025.
//

import UIKit

final class ImageSourceSelectionViewController: UIViewController {
    
    private var currentVC: UIViewController?
    
    // MARK: - UI
    private lazy var segmentedControl: UISegmentedControl = {
        let element = UISegmentedControl(items: ["Загрузить с устройства", "Загрузить из сети"])
        element.addAction(
            UIAction { _ in
                self.segmentChanged(self.segmentedControl)
            }, for: .valueChanged)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var containerView: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        displayVC(for: 0)
    }
    
    // MARK: - Private Methods
    private func segmentChanged(_ sender: UISegmentedControl) {
        displayVC(for: sender.selectedSegmentIndex)
    }
    
    private func displayVC(for index: Int) {
        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()
        
        let newVC: UIViewController
        
        switch index {
        case 0:
            newVC = DatePickerViewController()
        case 1:
            newVC = UnsplashImageViewController()
        default: return
        }
        
        addChild(newVC)
        newVC.view.frame = containerView.bounds
        containerView.addSubview(newVC.view)
        newVC.didMove(toParent: self)
        currentVC = newVC
    }
}

extension ImageSourceSelectionViewController {
    func setupViews() {
        view.backgroundColor = UIConstants.Colors.mainBackground
        view.addSubview(segmentedControl)
        view.addSubview(containerView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            segmentedControl.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            containerView.topAnchor
                .constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            containerView.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            containerView.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            containerView.bottomAnchor
                .constraint(equalTo: view.bottomAnchor)
        ])
    }
}
