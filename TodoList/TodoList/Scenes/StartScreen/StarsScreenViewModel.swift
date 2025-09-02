//
//  StarsScreenVM.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import Foundation

final class StarsScreenViewModel : StarsScreenVMProtocol {
    
    var didLoadData: ((Result<Void, Error>) -> Void)?
    
    private let apiService : TodoApiServiceProtocol
    private let todosStorage: TodoItemsRepositoryProtocol
    
    var appRouter: AppRouterProtocol?
    
    init(apiService : TodoApiServiceProtocol,
         todosStorage: TodoItemsRepositoryProtocol) {
        self.apiService = apiService
        self.todosStorage = todosStorage
    }
    
    func setAppRouter(appRouter: AppRouterProtocol?) {
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
