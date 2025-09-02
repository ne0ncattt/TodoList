//
//  Untitled.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import CoreData

final class TodoItemsRepository: TodoItemsRepositoryProtocol {
    
    // MARK: - Properties
    
    private let coreDataManager: CoreDataManageable
    
    var itemsDidChange: (([TodoItem]) -> Void)?
    
    // MARK: - Initialization
    
    init(coreDataManager: CoreDataManageable = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
        setupObservers()
    }
    
    // MARK: - Public Methods
    
    func fetchAllItems() -> [TodoItem] {
        let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        do {
            let entities = try coreDataManager.viewContext.fetch(request)
            return entities.map { $0.toTodoItem() }
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
    
    func fetchItem(by id: Int) -> TodoItem? {
        let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            let entities = try coreDataManager.viewContext.fetch(request)
            return entities.first?.toTodoItem()
        } catch {
            print("Error fetching item: \(error)")
            return nil
        }
    }
    
    func saveItem(_ item: TodoItem, completion: (() -> Void)?) {
        coreDataManager.performBackgroundTask { context in
            let _ = TodoItemEntity(context: context, todoItem: item)
            self.saveContext(context) {
                self.notifyItemsChanged()
                completion?()
            }
        }
    }
    
    func saveItems(_ items: [TodoItem], completion: (() -> Void)?) {
        coreDataManager.performBackgroundTask { context in
            self.deleteAllItems(in: context)
            
            for item in items {
                _ = TodoItemEntity(context: context, todoItem: item)
            }
            
            self.saveContext(context) {
                self.notifyItemsChanged()
                completion?()
            }
        }
    }
    
    func updateItem(_ item: TodoItem, completion: (() -> Void)?) {
        coreDataManager.performBackgroundTask { context in
            let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", item.id)
            
            do {
                if let entity = try context.fetch(request).first {
                    entity.itemDescripion = item.decription
                    entity.isCompleted = item.isCompleted
                    entity.userId = Int64(item.userId)
                    
                    self.saveContext(context) {
                        self.notifyItemsChanged()
                        completion?()
                    }
                }
            } catch {
                print("Error updating item: \(error)")
            }
        }
    }
    
    func deleteItem(by id: Int, completion: (() -> Void)?) {
        coreDataManager.performBackgroundTask { context in
            let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                let entities = try context.fetch(request)
                for entity in entities {
                    context.delete(entity)
                }
                
                self.saveContext(context) {
                    self.notifyItemsChanged()
                    completion?()
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
    
    func deleteAllItems() {
        coreDataManager.performBackgroundTask { context in
            self.deleteAllItems(in: context)
            self.saveContext(context) {
                self.notifyItemsChanged()
            }
        }
    }
    
    func toggleCompletion(for id: Int) {
        coreDataManager.performBackgroundTask { context in
            let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                if let entity = try context.fetch(request).first {
                    entity.isCompleted.toggle()
                    
                    self.saveContext(context) {
                        self.notifyItemsChanged()
                    }
                }
            } catch {
                print("Error toggling completion: \(error)")
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextDidChange(_:)),
            name: .NSManagedObjectContextDidSave,
            object: nil
        )
    }
    
    @objc private func contextDidChange(_ notification: Notification) {
        // Обновляем данные при изменениях из других контекстов
        coreDataManager.viewContext.perform {
            self.coreDataManager.viewContext.mergeChanges(fromContextDidSave: notification)
            self.notifyItemsChanged()
        }
    }
    
    private func deleteAllItems(in context: NSManagedObjectContext) {
        let request: NSFetchRequest<NSFetchRequestResult> = TodoItemEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error deleting all items: \(error)")
        }
    }
    
    private func saveContext(_ context: NSManagedObjectContext, completion: @escaping () -> Void) {
        coreDataManager.saveBackgroundContext(context) { result in
            switch result {
            case .success:
                completion()
            case .failure(let error):
                print("Error saving context: \(error)")
            }
        }
    }
    
    private func notifyItemsChanged() {
        let items = fetchAllItems()
        itemsDidChange?(items)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
