//
//  SceneDelegate.swift
//  TodoList
//
//  Created by Renat Galiamov on 31.08.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private var appRouter: AppRouterProtocol?
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        appRouter = AppRouter(window: window)
        setInitialUI()
    }
    
    private func setInitialUI() {
        if UserSettingsStorage.shared.isInitialDataLoaded {
            appRouter?.goToTasksList()
        } else {
            appRouter?.goToStartScreen()
        }
        window?.makeKeyAndVisible()
    }
    
}

