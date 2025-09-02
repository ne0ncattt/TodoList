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

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.noData, .noData):
            return true
        case (.decodingError, .decodingError):
            return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        case (.unknownError, .unknownError):
            return true
        default:
            return false
        }
    }
}
