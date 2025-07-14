//
//  AuthPresenter.swift
//  Todoist
//
//  Created by Artem Kriukov on 14.07.2025.
//

import Foundation

protocol AuthPresenterProtocol {
    
}

struct AuthPresenter: AuthPresenterProtocol {
    
    weak var view: AuthViewProtocol?

    init(view: AuthViewProtocol) {
        self.view = view
    }
    
}
