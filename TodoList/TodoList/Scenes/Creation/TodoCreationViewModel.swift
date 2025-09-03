//
//  Untitled.swift
//  TodoList
//
//  Created by Renat Galiamov on 03.09.2025.
//

import UIKit

final class TodoCreationViewModel : TodoCreationViewModelProtocol {

    var didFinishRoutine: (() -> Void)?
    
    private let todosStorage: TodoItemsRepositoryProtocol
    var todosRouter: TodosRouterProtocol?
    
    init(todosStorage: TodoItemsRepositoryProtocol,
         todosRouter: TodosRouterProtocol) {
        self.todosStorage = todosStorage
        self.todosRouter = todosRouter
    }
    
    func createItem(_ item: TodoItem) {
        todosStorage.saveItem(item) { [weak self] in
            self?.didFinishRoutine?()
        }
    }
    
    func updateItem(_ item: TodoItem) {
        todosStorage.updateItem(item) { [weak self] in
            self?.didFinishRoutine?()
        }
    }
}
