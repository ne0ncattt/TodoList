//
//  final class TodoApiServiceProtocol.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

protocol TodoApiServiceProtocol {
    func fetchAllTodos(completion: @escaping (Result<TodosApiResponse, NetworkError>) -> Void)
}
