//
//  TodoItem.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import Foundation

struct TodoItem: Codable {
    
    let id: Int
    let decription: String
    let isCompleted: Bool
    let userId: Int
    var date: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case decription = "todo"
        case isCompleted = "completed"
        case userId
    }
}
