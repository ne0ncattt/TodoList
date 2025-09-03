//
//  TodoCreationViewModelTests.swift
//  TodoList
//
//  Created by Renat Galiamov on 03.09.2025.
//

import XCTest
@testable import TodoList

// MARK: - Mocks для тестов

extension TodoItem {
    static let mock = TodoItem(id: 0, decription: "", isCompleted: false, userId: 0)
}

class MockTodoItemsRepository: TodoItemsRepositoryProtocol {


    var saveItemCalled = false
    var updateItemCalled = false
    var savedItem: TodoItem?
    var updatedItem: TodoItem?
    var saveCompletion: (() -> Void)?
    var updateCompletion: (() -> Void)?
    
    func saveItem(_ item: TodoList.TodoItem, completion: (() -> Void)?) {
        saveItemCalled = true
        savedItem = item
        saveCompletion = completion
    }
    
    func updateItem(_ item: TodoList.TodoItem, completion: (() -> Void)?) {
        updateItemCalled = true
        updatedItem = item
        updateCompletion = completion
    }
    
    func loadItems(completion: @escaping ([TodoList.TodoItem]) -> Void) {}
    
    func deleteItem(_ id: Int, completion: @escaping () -> Void) {}
    
    var itemsDidChange: (([TodoList.TodoItem]) -> Void)?
    
    func fetchAllItems() -> [TodoList.TodoItem] { [TodoList.TodoItem.mock] }
    
    func fetchItem(by id: Int) -> TodoList.TodoItem? { TodoList.TodoItem.mock }
    
    func saveItems(_ item: [TodoList.TodoItem], completion: (() -> Void)?) { }
    
    func deleteItem(by id: Int, completion: (() -> Void)?) {}
    
    func toggleCompletion(for id: Int) { }
}

class MockTodosRouter: TodosRouterProtocol {
    func createTodoItem() { }
    
    func editTodoItem(_ todoToEdit: TodoList.TodoItem) { }
}

// MARK: - Тесты

final class TodoCreationViewModelTests: XCTestCase {
    
    private var viewModel: TodoCreationViewModel!
    private var mockRepository: MockTodoItemsRepository!
    private var mockRouter: MockTodosRouter!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockTodoItemsRepository()
        mockRouter = MockTodosRouter()
        viewModel = TodoCreationViewModel(
            todosStorage: mockRepository,
            todosRouter: mockRouter
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        mockRouter = nil
        super.tearDown()
    }
    
    // MARK: - Create Item Tests
    
    func testCreateItem_CallsRepositorySave() {
        // Given
        let todoItem = TodoItem(
            id: 1,
            decription: "Test description",
            isCompleted: false,
            userId: 123,
            title: "Test Title",
            date: Date()
        )
        
        var didFinishCalled = false
        viewModel.didFinishRoutine = { didFinishCalled = true }
        
        // When
        viewModel.createItem(todoItem)
        
        // Then
        XCTAssertTrue(mockRepository.saveItemCalled)
        XCTAssertEqual(mockRepository.savedItem?.id, todoItem.id)
        XCTAssertEqual(mockRepository.savedItem?.decription, todoItem.decription)
        XCTAssertEqual(mockRepository.savedItem?.title, todoItem.title)
        XCTAssertFalse(didFinishCalled) // Completion еще не вызван
        
        // When completion is called
        mockRepository.saveCompletion?()
        
        // Then
        XCTAssertTrue(didFinishCalled)
    }
    
    func testCreateItem_WithNilDidFinishRoutine_DoesNotCrash() {
        // Given
        let todoItem = TodoItem(
            id: 2,
            decription: "Another test",
            isCompleted: true,
            userId: 456
        )
        viewModel.didFinishRoutine = nil
        
        // When & Then - не должно быть краша
        viewModel.createItem(todoItem)
        mockRepository.saveCompletion?()
        
        XCTAssertTrue(mockRepository.saveItemCalled)
    }
    
    func testCreateItem_WithWeakSelf_DoesNotRetainStrongly() {
        // Given
        var viewModel: TodoCreationViewModel? = TodoCreationViewModel(
            todosStorage: mockRepository,
            todosRouter: mockRouter
        )
        
        weak var weakViewModel = viewModel
        let todoItem = TodoItem(
            id: 3,
            decription: "Weak test",
            isCompleted: false,
            userId: 789
        )
        
        // When
        viewModel?.createItem(todoItem)
        viewModel = nil // Освобождаем ссылку
        
        // Then - completion не должен вызвать краш даже после освобождения
        mockRepository.saveCompletion?()
        
        XCTAssertNil(weakViewModel)
    }
    
    // MARK: - Update Item Tests
    
    func testUpdateItem_CallsRepositoryUpdate() {
        // Given
        let todoItem = TodoItem(
            id: 4,
            decription: "Updated description",
            isCompleted: true,
            userId: 100,
            title: "Updated Title",
            date: Date()
        )
        
        var didFinishCalled = false
        viewModel.didFinishRoutine = { didFinishCalled = true }
        
        // When
        viewModel.updateItem(todoItem)
        
        // Then
        XCTAssertTrue(mockRepository.updateItemCalled)
        XCTAssertEqual(mockRepository.updatedItem?.id, todoItem.id)
        XCTAssertEqual(mockRepository.updatedItem?.decription, todoItem.decription)
        XCTAssertEqual(mockRepository.updatedItem?.isCompleted, todoItem.isCompleted)
        XCTAssertFalse(didFinishCalled) // Completion еще не вызван
        
        // When completion is called
        mockRepository.updateCompletion?()
        
        // Then
        XCTAssertTrue(didFinishCalled)
    }
    
    func testUpdateItem_WithNilDidFinishRoutine_DoesNotCrash() {
        // Given
        let todoItem = TodoItem(
            id: 5,
            decription: "Nil completion test",
            isCompleted: false,
            userId: 200
        )
        viewModel.didFinishRoutine = nil
        
        // When & Then - не должно быть краша
        viewModel.updateItem(todoItem)
        mockRepository.updateCompletion?()
        
        XCTAssertTrue(mockRepository.updateItemCalled)
    }

}
