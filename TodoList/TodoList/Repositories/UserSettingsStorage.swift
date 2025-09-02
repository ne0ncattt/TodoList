//
//  UserSettingsStorage.swift
//  TodoList
//
//  Created by Renat Galiamov on 02.09.2025.
//

import Foundation

final class UserSettingsStorage {
    
    static let shared = UserSettingsStorage()
    
    private init() { }
    
    private let userDefaults = UserDefaults()
    
    private enum Keys {
        static let isInitialDataLoaded = "isInitialDataLoaded"
    }
    
    var isInitialDataLoaded: Bool {
        get {
            userDefaults.bool(forKey: Keys.isInitialDataLoaded)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.isInitialDataLoaded)
        }
    }
}
