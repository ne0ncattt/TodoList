//
//  Untitled 2.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import CoreData

extension TodoItemEntity {
    convenience init(context: NSManagedObjectContext, todoItem: TodoItem) {
        self.init(context: context)
        self.id = Int64(todoItem.id)
        self.todo = todoItem.todo
        self.completed = todoItem.completed
        self.userId = Int64(todoItem.userId)
        self.date = todoItem.date
    }
    
    func toTodoItem() -> TodoItem {
        return TodoItem(
            id: Int(id),
            todo: todo ?? "",
            completed: completed,
            userId: Int(userId),
            date: Date()
        )
    }
}
