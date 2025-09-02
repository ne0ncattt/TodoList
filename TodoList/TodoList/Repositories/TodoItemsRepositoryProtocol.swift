//
//  Untitled.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import Foundation

protocol TodoItemsRepositoryProtocol: AnyObject {
    var itemsDidChange: (([TodoItem]) -> Void)? { get set }
    func fetchAllItems() -> [TodoItem]
    func fetchItem(by id: Int) -> TodoItem?
    func saveItem(_ item: TodoItem, completion: (() -> Void)?)
    func saveItems(_ item: [TodoItem],completion: (() -> Void)?)
    func updateItem(_ item: TodoItem, completion: (() -> Void)?)
    func deleteItem(by id: Int, completion: (() -> Void)?)
    func toggleCompletion(for id: Int)
}
