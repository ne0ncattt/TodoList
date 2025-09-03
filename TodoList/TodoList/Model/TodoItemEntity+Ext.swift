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
        self.id = Int32(todoItem.id)
        self.itemDescripion = todoItem.decription
        self.isCompleted = todoItem.isCompleted
        self.userId = Int32(todoItem.userId)
        self.date = todoItem.date
        self.title = todoItem.title
    }
    
    func toTodoItem() -> TodoItem {
        return TodoItem(
            id: Int(id),
            decription: itemDescripion ?? "",
            isCompleted: isCompleted,
            userId: Int(userId),
            title: title,
            date: date
        )
    }
}
