//
//  AppRouter.swift
//  TodoList
//
//  Created by Renat Galiamov on 02.09.2025.
//

import UIKit

protocol TodosRouterProtocol {
    func createTodoItem()
    func editTodoItem(_ todoToEdit: TodoItem)
}

final class TodosRouter: TodosRouterProtocol {
    
    private let viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func goToTaskEditingScreen(with item: TodoItem) {
        
    }
    
    func createTodoItem() {
        openEditingScreen()
    }
    
    func editTodoItem(_ todoToEdit: TodoItem) {
        openEditingScreen(mode: .editing, item: todoToEdit)
    }
    
    func openEditingScreen(mode: TodoCreationController.Mode = .creation, item: TodoItem? = nil) {
        let todosStorage = TodoItemsRepository()
        let viewModel = TodoCreationViewModel(todosStorage: todosStorage, todosRouter: self)
        let controller = TodoCreationController(viewModel: viewModel,
                                                mode: mode,
                                                itemToEdit: item)
        viewModel.didFinishRoutine = { [weak self] in
            DispatchQueue.main.async {
                self?.viewController?.navigationController?.popViewController(animated: true)
            }
        }
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
}
