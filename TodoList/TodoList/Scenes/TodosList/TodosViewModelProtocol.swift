//
//  TodosViewModel.swift
//  TodoList
//
//  Created by Renat Galiamov on 02.09.2025.
//

protocol TodosViewModelProtocol: AnyObject {
    var didLoadNewModel : (() -> Void)? { get set }
    var itemsToDisplay: [TodoItem] { get }
    var filterQuery: String { get set }
    func toggleTodoItemCompleteion(at index: Int)
    func deleteItem(at index: Int)
    func createItem()
    func editItem(at index: Int)
    func loadModel()
}


