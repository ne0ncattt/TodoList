//
//  Untitled.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import CoreData

protocol CoreDataManageable {
    var viewContext: NSManagedObjectContext { get }
    func backgroundContext() -> NSManagedObjectContext
    func saveContext()
    func saveBackgroundContext(_ context: NSManagedObjectContext, completion: ((Result<Void, Error>) -> Void)?)
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
    func getNextAvailableID(for entityName: String, in context: NSManagedObjectContext) -> Int
}
