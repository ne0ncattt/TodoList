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
        let navVC = UINavigationController()
        navVC.viewControllers = [TodosViewController()]
        window?.rootViewController = navVC
    }
    
    func goToStartScreen() {
        let todoApiService = TodoApiService()
        let todosStorage = TodoItemsRepository()
        let viewModel = StarsScreenViewModel(apiService: todoApiService,
                                             todosStorage: todosStorage)
        let controller = StartScreenViewController(viewModel: viewModel)
        let router = TodosRouter(viewController: controller)
        viewModel.setAppRouter(appRouter: self)
        window?.rootViewController = controller
    }
    

}
