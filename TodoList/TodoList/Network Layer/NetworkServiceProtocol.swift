//
//  Untitled.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Encodable?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    
    func get<T: Decodable>(
        _ endpoint: String,
        headers: [String: String]?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    
    func post<T: Decodable, U: Encodable>(
        _ endpoint: String,
        headers: [String: String]?,
        body: U?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    
    func put<T: Decodable, U: Encodable>(
        _ endpoint: String,
        headers: [String: String]?,
        body: U?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    
    func delete<T: Decodable>(
        _ endpoint: String,
        headers: [String: String]?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}
