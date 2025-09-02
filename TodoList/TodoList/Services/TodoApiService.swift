//
//  Untitled.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//
import Foundation

final class TodoApiService: TodoApiServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(baseURL: "https://dummyjson.com")) {
        self.networkService = networkService
    }
    
    func fetchAllTodos(completion: @escaping (Result<TodosApiResponse, NetworkError>) -> Void) {
        networkService.get("/todos",
                           headers: nil,
                           completion: completion)
    }
 
}
