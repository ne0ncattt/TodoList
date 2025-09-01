//
//  AppDelegate.swift
//  TodoList
//
//  Created by Renat Galiamov on 31.08.2025.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupCommomAppearance()
        return true
    }
    
    private func setupCommomAppearance() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .todosScreenBackground
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.darkThemeWhite]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkThemeWhite]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
    }
    
}

