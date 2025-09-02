//
//  TodoItem.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import Foundation

struct TodoItem: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
    let date: Date
}
