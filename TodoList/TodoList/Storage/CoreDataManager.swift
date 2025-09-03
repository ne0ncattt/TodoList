//
//  Untitled.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import CoreData

final class CoreDataManager: AnyObject, CoreDataManageable {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoList")
        
        let description = container.persistentStoreDescriptions.first
        description?.shouldAddStoreAsynchronously = true
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data error: \(error)")
                return
            }
            print("Core Data store loaded: \(description)")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
        return container
    }()
    
    // MARK: - CoreDataManageable Conformance
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func saveContext() {
        let context = viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения: \(error)")
            context.rollback()
        }
    }
    
    func saveBackgroundContext(_ context: NSManagedObjectContext, completion: ((Result<Void, Error>) -> Void)? = nil) {
        context.perform {
            do {
                try context.save()
                completion?(.success(()))
            } catch {
                print("Ошибка фонового сохранения: \(error)")
                context.rollback()
                completion?(.failure(error))
            }
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}

extension CoreDataManager {
    func getNextAvailableID(for entityName: String, in context: NSManagedObjectContext) -> Int {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: entityName)
        fetchRequest.resultType = .dictionaryResultType
        
        // Создаем expression для получения максимального ID
        let expression = NSExpression(format: "max:(id)")
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "maxID"
        expressionDescription.expression = expression
        expressionDescription.expressionResultType = .integer32AttributeType
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        
        do {
            let results = try context.fetch(fetchRequest)
            if let maxID = results.first?["maxID"] as? Int32 {
                return Int(maxID) + 1
            }
            return 1 // Если нет записей, начинаем с 1
        } catch {
            print("Error getting next ID: \(error)")
            return 1
        }
    }
}
