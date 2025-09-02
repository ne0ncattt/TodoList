//
//  SceneDelegate.swift
//  TodoList
//
//  Created by Renat Galiamov on 31.08.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = createInitialController()
        window?.makeKeyAndVisible()
    }
    
    private func createInitialController() -> UIViewController {
        let navVC = UINavigationController()
        navVC.viewControllers = [TodosViewController()]
        return navVC
    }
    

    
}

