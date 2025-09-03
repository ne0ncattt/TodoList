//
//  TodoList.swift
//  TodoList
//
//  Created by Renat Galiamov on 03.09.2025.
//


import XCTest
@testable import TodoList

final class MockTodoCreationViewModel: TodoCreationViewModelProtocol {
    var createdItem: TodoItem?
    var updatedItem: TodoItem?
    var createItemCalled = false
    var updateItemCalled = false
    
    func createItem(_ item: TodoItem) {
        createItemCalled = true
        createdItem = item
    }
    
    func updateItem(_ item: TodoItem) {
        updateItemCalled = true
        updatedItem = item
    }
}

// MARK: - Test Class
final class TodoCreationControllerTests: XCTestCase {
    
    private var mockViewModel: MockTodoCreationViewModel!
    private var controller: TodoCreationController!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockTodoCreationViewModel()
        controller = TodoCreationController(viewModel: mockViewModel)
        
        _ = controller.view
    }
    
    override func tearDown() {
        mockViewModel = nil
        controller = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitializationWithCreationMode() {
        // Given
        let viewModel = MockTodoCreationViewModel()
        
        // When
        let controller = TodoCreationController(viewModel: viewModel, mode: .creation)
        
        // Then
        XCTAssertEqual(controller.mode, .creation)
        XCTAssertNil(controller.itemToEdit)
    }
    
    func testInitializationWithEditingMode() {
        // Given
        let viewModel = MockTodoCreationViewModel()
        let testItem = TodoItem(id: 1, decription: "Test", isCompleted: false, userId: 1, title: "Test", date: Date())
        
        // When
        let controller = TodoCreationController(viewModel: viewModel, mode: .editing, itemToEdit: testItem)
        
        // Then
        XCTAssertEqual(controller.mode, .editing)
        XCTAssertNotNil(controller.itemToEdit)
        XCTAssertEqual(controller.itemToEdit?.id, testItem.id)
    }
    
    // MARK: - View Lifecycle Tests
    
    func testViewDidLoadInCreationMode() {
        // Given
        controller.mode = .creation
        
        // When
        controller.viewDidLoad()
        
        // Then
        XCTAssertEqual(controller.testableTitleTextField.text, "")
        XCTAssertEqual(controller.testableDescriptionTextView.text, "")
    }
    
    func testViewDidLoadInEditingMode() {
        // Given
        let testItem = TodoItem(id: 1, decription: "Test Description", isCompleted: false, userId: 1, title: "Test Title", date: Date())
        controller.mode = .editing
        controller.itemToEdit = testItem
        
        // When
        controller.viewDidLoad()
        
        // Then
        XCTAssertEqual(controller.testableTitleTextField.text, "Test Title")
        XCTAssertEqual(controller.testableDescriptionTextView.text, "Test Description")
    }
    
    // MARK: - Validation Tests
    
    func testValidateInputWithEmptyFields() {
        // Given
        controller.testableTitleTextField.text = ""
        controller.testableDescriptionTextView.text = ""
        
        // When
        controller.testableValidateInput()
        
        // Then
        XCTAssertNil(controller.navigationItem.rightBarButtonItem)
    }
    
    func testValidateInputWithOnlyTitle() {
        // Given
        controller.testableTitleTextField.text = "Test Title"
        controller.testableDescriptionTextView.text = ""
        
        // When
        controller.testableValidateInput()
        
        // Then
        XCTAssertNil(controller.navigationItem.rightBarButtonItem)
    }
    
    func testValidateInputWithOnlyDescription() {
        // Given
        controller.testableTitleTextField.text = ""
        controller.testableDescriptionTextView.text = "Test Description"
        
        // When
        controller.testableValidateInput()
        
        // Then
        XCTAssertNil(controller.navigationItem.rightBarButtonItem)
    }
    
    func testValidateInputWithBothFieldsFilled() {
        // Given
        controller.testableTitleTextField.text = "Test Title"
        controller.testableDescriptionTextView.text = "Test Description"
        
        // When
        controller.testableValidateInput()
        
        // Then
        XCTAssertNotNil(controller.navigationItem.rightBarButtonItem)
        XCTAssertEqual(controller.navigationItem.rightBarButtonItem?.title, "Готово")
    }
    
    // MARK: - Button Action Tests
    
    func testAddButtonPressedInCreationMode() {
        // Given
        controller.mode = .creation
        controller.testableTitleTextField.text = "New Title"
        controller.testableDescriptionTextView.text = "New Description"
        
        // When
        controller.testableAddButtonPressed()
        
        // Then
        XCTAssertTrue(mockViewModel.createItemCalled)
        XCTAssertFalse(mockViewModel.updateItemCalled)
        XCTAssertNotNil(mockViewModel.createdItem)
        XCTAssertEqual(mockViewModel.createdItem?.title, "New Title")
        XCTAssertEqual(mockViewModel.createdItem?.decription, "New Description")
        XCTAssertEqual(mockViewModel.createdItem?.isCompleted, false)
    }
    
    func testAddButtonPressedInEditingMode() {
        // Given
        let originalItem = TodoItem(id: 123, decription: "Original", isCompleted: true, userId: 456, title: "Original", date: Date())
        controller.mode = .editing
        controller.itemToEdit = originalItem
        controller.testableTitleTextField.text = "Updated Title"
        controller.testableDescriptionTextView.text = "Updated Description"
        
        // When
        controller.testableAddButtonPressed()
        
        // Then
        XCTAssertFalse(mockViewModel.createItemCalled)
        XCTAssertTrue(mockViewModel.updateItemCalled)
        XCTAssertNotNil(mockViewModel.updatedItem)
        XCTAssertEqual(mockViewModel.updatedItem?.id, 123)
        XCTAssertEqual(mockViewModel.updatedItem?.title, "Updated Title")
        XCTAssertEqual(mockViewModel.updatedItem?.decription, "Updated Description")
        XCTAssertEqual(mockViewModel.updatedItem?.isCompleted, true)
        XCTAssertEqual(mockViewModel.updatedItem?.userId, 456)
    }
    
    func testAddButtonPressedInEditingModeWithoutItemToEdit() {
        // Given
        controller.mode = .editing
        controller.itemToEdit = nil
        controller.testableTitleTextField.text = "Test Title"
        controller.testableDescriptionTextView.text = "Test Description"
        
        // When
        controller.testableAddButtonPressed()
        
        // Then
        XCTAssertFalse(mockViewModel.createItemCalled)
        XCTAssertFalse(mockViewModel.updateItemCalled)
    }

}
