//
//  NetworkError.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case encodingError
    case serverError(Int)
    case unknownError
    case invalidResponse
}
