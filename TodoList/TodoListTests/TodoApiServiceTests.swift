//
//  TodoListTests.swift
//  TodoListTests
//
//  Created by Renat Galiamov on 31.08.2025.
//

import XCTest
@testable import TodoList

class MockNetworkService: NetworkServiceProtocol {
    var requestCalled = false
    var getCalled = false
    var postCalled = false
    var putCalled = false
    var deleteCalled = false
    
    var lastEndpoint: String?
    var lastMethod: HTTPMethod?
    var lastHeaders: [String: String]?
    var lastBody: Encodable?
    
    var shouldReturnSuccess = true
    var mockSuccessResponse: Any?
    var mockError: NetworkError?
    
    func request<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Encodable?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        requestCalled = true
        lastEndpoint = endpoint
        lastMethod = method
        lastHeaders = headers
        lastBody = body
        
        if shouldReturnSuccess, let response = mockSuccessResponse as? T {
            completion(.success(response))
        } else if let error = mockError {
            completion(.failure(error))
        } else {
            completion(.failure(.unknownError))
        }
    }
    
    func get<T: Decodable>(
        _ endpoint: String,
        headers: [String: String]?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        getCalled = true
        lastEndpoint = endpoint
        lastHeaders = headers
        
        if shouldReturnSuccess, let response = mockSuccessResponse as? T {
            completion(.success(response))
        } else if let error = mockError {
            completion(.failure(error))
        } else {
            completion(.failure(.unknownError))
        }
    }
    
    func post<T: Decodable, U: Encodable>(
        _ endpoint: String,
        headers: [String: String]?,
        body: U?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        postCalled = true
        lastEndpoint = endpoint
        lastHeaders = headers
        lastBody = body
        
        if shouldReturnSuccess, let response = mockSuccessResponse as? T {
            completion(.success(response))
        } else if let error = mockError {
            completion(.failure(error))
        } else {
            completion(.failure(.unknownError))
        }
    }
    
    func put<T: Decodable, U: Encodable>(
        _ endpoint: String,
        headers: [String: String]?,
        body: U?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        putCalled = true
        lastEndpoint = endpoint
        lastHeaders = headers
        lastBody = body
        
        if shouldReturnSuccess, let response = mockSuccessResponse as? T {
            completion(.success(response))
        } else if let error = mockError {
            completion(.failure(error))
        } else {
            completion(.failure(.unknownError))
        }
    }
    
    func delete<T: Decodable>(
        _ endpoint: String,
        headers: [String: String]?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        deleteCalled = true
        lastEndpoint = endpoint
        lastHeaders = headers
        
        if shouldReturnSuccess, let response = mockSuccessResponse as? T {
            completion(.success(response))
        } else if let error = mockError {
            completion(.failure(error))
        } else {
            completion(.failure(.unknownError))
        }
    }
}

// MARK: - Test Data

extension TodosApiResponse {
    static func mock() -> TodosApiResponse {
        let todo = TodoItem(id: 1, decription: "Test todo", isCompleted: false, userId: 1, date: Date())
        return TodosApiResponse(todos: [todo])
    }
}

// MARK: - Tests

class TodoApiServiceTests: XCTestCase {
    
    var sut: TodoApiService!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = TodoApiService(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitWithCustomNetworkService() {
        // Given
        let customNetworkService = MockNetworkService()
        
        // When
        let service = TodoApiService(networkService: customNetworkService)
        
        // Then
        XCTAssertNotNil(service)
    }
    
    func testInitWithDefaultNetworkService() {
        // When
        let service = TodoApiService()
        
        // Then
        XCTAssertNotNil(service)
    }
    
    // MARK: - fetchAllTodos Tests
    
    func testFetchAllTodosCallsGetOnNetworkService() {
        // Given
        mockNetworkService.shouldReturnSuccess = true
        mockNetworkService.mockSuccessResponse = TodosApiResponse.mock()
        
        let expectation = self.expectation(description: "Fetch todos completion")
        
        // When
        sut.fetchAllTodos { result in
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(mockNetworkService.getCalled)
        XCTAssertEqual(mockNetworkService.lastEndpoint, "/todos")
        XCTAssertNil(mockNetworkService.lastHeaders)
    }
    
    func testFetchAllTodosSuccess() {
        // Given
        let expectedResponse = TodosApiResponse.mock()
        mockNetworkService.shouldReturnSuccess = true
        mockNetworkService.mockSuccessResponse = expectedResponse
        
        let expectation = self.expectation(description: "Fetch todos success")
        var result: Result<TodosApiResponse, NetworkError>?
        
        // When
        sut.fetchAllTodos { res in
            result = res
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        
        switch result {
        case .success(let response):
            XCTAssertEqual(response.todos.count, expectedResponse.todos.count)
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        case .none:
            XCTFail("Result should not be nil")
        }
    }
    
    func testFetchAllTodosFailure() {
        // Given
        mockNetworkService.shouldReturnSuccess = false
        mockNetworkService.mockError = .serverError(500)
        
        let expectation = self.expectation(description: "Fetch todos failure")
        var result: Result<TodosApiResponse, NetworkError>?
        
        // When
        sut.fetchAllTodos { res in
            result = res
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, .serverError(500))
        case .none:
            XCTFail("Result should not be nil")
        }
    }
    
    func testFetchAllTodosWithDifferentErrorTypes() {
        // Test different error types
        let errorTypes: [NetworkError] = [
            .invalidURL,
            .noData,
            .decodingError,
            .serverError(404),
            .unknownError
        ]
        
        for errorType in errorTypes {
            // Given
            mockNetworkService.shouldReturnSuccess = false
            mockNetworkService.mockError = errorType
            
            let expectation = self.expectation(description: "Fetch todos with error: \(errorType)")
            var result: Result<TodosApiResponse, NetworkError>?
            
            // When
            sut.fetchAllTodos { res in
                result = res
                expectation.fulfill()
            }
            
            // Then
            waitForExpectations(timeout: 1.0)
            
            switch result {
            case .success:
                XCTFail("Expected failure but got success for error: \(errorType)")
            case .failure(let error):
                XCTAssertEqual(error, errorType)
            case .none:
                XCTFail("Result should not be nil")
            }
        }
    }
    
    func testFetchAllTodosWithEmptyResponse() {
        // Given
        let emptyResponse = TodosApiResponse(todos: [])
        mockNetworkService.shouldReturnSuccess = true
        mockNetworkService.mockSuccessResponse = emptyResponse
        
        let expectation = self.expectation(description: "Fetch empty todos")
        var result: Result<TodosApiResponse, NetworkError>?
        
        // When
        sut.fetchAllTodos { res in
            result = res
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        
        switch result {
        case .success(let response):
            XCTAssertTrue(response.todos.isEmpty)
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        case .none:
            XCTFail("Result should not be nil")
        }
    }
    
}
