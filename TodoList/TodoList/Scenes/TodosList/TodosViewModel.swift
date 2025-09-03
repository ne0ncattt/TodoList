//
//  TodosViewModel.swift
//  TodoList
//
//  Created by Renat Galiamov on 02.09.2025.
//

import Foundation

final class TodosViewModel : TodosViewModelProtocol {

    private let todosStorage: TodoItemsRepositoryProtocol
    
    var didLoadNewModel : (() -> Void)?
    var todosRouter: TodosRouterProtocol?
    
    var itemsToDisplay: [TodoItem] = []  {
        didSet {
            didLoadNewModel?()
        }
    }
    
    var filterQuery = "" {
        didSet {
            loadModel()
        }
    }
    
    init(todosStorage: TodoItemsRepositoryProtocol) {
        self.todosStorage = todosStorage
        todosStorage.itemsDidChange = { [weak self] _ in
            self?.loadModel()
        }
    }
    
    func setRouter(_ todosRouter: TodosRouterProtocol) {
        self.todosRouter = todosRouter
    }
    
    func loadModel() {
        let allTodos = todosStorage.fetchAllItems()
        itemsToDisplay = filterQuery.isEmpty
        ? allTodos
        : allTodos.filter { item in
            if let title = item.title {
                return title
                    .lowercased()
                    .contains(filterQuery.lowercased()) ||
                item
                    .decription
                    .lowercased()
                    .contains(filterQuery.lowercased())
            } else {
               return item.decription
                    .lowercased()
                    .contains(filterQuery.lowercased())
            }
        }
    }
    
    func toggleTodoItemCompleteion(at index: Int) {
        let itemToToggle = itemsToDisplay[index]
        todosStorage.toggleCompletion(for: itemToToggle.id)
    }
    
    func deleteItem(at index: Int) {
        let itemToDelete = itemsToDisplay[index]
        todosStorage.deleteItem(by: itemToDelete.id, completion: nil)
    }
    
    func createItem() {
        todosRouter?.createTodoItem()
    }
    
    func editItem(at index: Int) {
        let itemToEdit = itemsToDisplay[index]
        todosRouter?.editTodoItem(itemToEdit)
    }
    
}

