//
//  AppRouter.swift
//  TodoList
//
//  Created by Renat Galiamov on 02.09.2025.
//


import UIKit

protocol AppRouterProtocol {
    func goToTasksList()
    func goToStartScreen()
}

final class AppRouter: AppRouterProtocol {

    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func goToTasksList() {
        let todosStorage = TodoItemsRepository()
        let viewModel = TodosViewModel(todosStorage: todosStorage)
        let controller = TodosViewController(viewModel: viewModel)
        let router = TodosRouter(viewController: controller)
        viewModel.setRouter(router)
        let navVC = UINavigationController()
        navVC.viewControllers = [controller]
        window?.rootViewController = navVC
    }
    
    func goToStartScreen() {
        let todoApiService = TodoApiService()
        let todosStorage = TodoItemsRepository()
        let viewModel = StartScreenViewModel(apiService: todoApiService,
                                             todosStorage: todosStorage,
                                             appRouter: self)
        let controller = StartScreenViewController(viewModel: viewModel)
        window?.rootViewController = controller
    }
    

}
