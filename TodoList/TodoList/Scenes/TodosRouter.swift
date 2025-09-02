//
//  AppRouter.swift
//  TodoList
//
//  Created by Renat Galiamov on 02.09.2025.
//

import UIKit

protocol TodosRouterProtocol {
    func goToTaskEditingScreen(with item: TodoItem)
    func goToTaskCreationScreen(with item: TodoItem)
}

final class TodosRouter: TodosRouterProtocol {
    
    private let viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func goToTaskEditingScreen(with item: TodoItem) {
        
    }
    
    func goToTaskCreationScreen(with item: TodoItem) {
        
    }
    
}
