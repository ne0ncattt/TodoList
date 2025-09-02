//
//  StarsScreenVM.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import Foundation

final class StartScreenViewModel : StartScreenViewModelProtocol {
    
    var didLoadData: ((Result<Void, Error>) -> Void)?
    
    private let apiService : TodoApiServiceProtocol
    private let todosStorage: TodoItemsRepositoryProtocol
    private let appRouter: AppRouterProtocol?
    
    init(apiService : TodoApiServiceProtocol,
         todosStorage: TodoItemsRepositoryProtocol,
         appRouter: AppRouterProtocol) {
        self.apiService = apiService
        self.todosStorage = todosStorage
        self.appRouter = appRouter
    }
    
    func loadData() {
        apiService.fetchAllTodos { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.todosStorage.saveItems(response.todos, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        UserSettingsStorage.shared.isInitialDataLoaded = true
                        self.appRouter?.goToTasksList()
                    })
                })
            case .failure(let error):
                DispatchQueue.main.async {
                    self.didLoadData?(.failure(error))
                }
            }
        }
    }
}
