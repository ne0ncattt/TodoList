//
//  Untitled.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    private let baseURL: String
    
    init(baseURL: String = "", session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    // Основной метод для всех запросов
    func request<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        body: Encodable? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        
        let urlString = baseURL + endpoint
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Устанавливаем заголовки
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Добавляем тело запроса если есть
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                completion(.failure(.encodingError))
                return
            }
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            
            // Проверяем ошибки
            if let error = error {
                completion(.failure(.unknownError))
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            // Проверяем статус код
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            // Для DELETE запросов может не быть тела ответа
            if method == .delete && data == nil {
                if let emptyResponse = EmptyResponse() as? T {
                    completion(.success(emptyResponse))
                } else {
                    completion(.failure(.noData))
                }
                return
            }
            
            // Проверяем наличие данных
            guard let data = data, !data.isEmpty else {
                completion(.failure(.noData))
                return
            }
            
            // Декодируем JSON
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    // Специфичные методы для удобства
    
    func get<T: Decodable>(
        _ endpoint: String,
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(endpoint, method: .get, headers: headers, body: nil, completion: completion)
    }
    
    func post<T: Decodable, U: Encodable>(
        _ endpoint: String,
        headers: [String: String]? = nil,
        body: U? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(endpoint, method: .post, headers: headers, body: body, completion: completion)
    }
    
    func put<T: Decodable, U: Encodable>(
        _ endpoint: String,
        headers: [String: String]? = nil,
        body: U? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(endpoint, method: .put, headers: headers, body: body, completion: completion)
    }
    
    func delete<T: Decodable>(
        _ endpoint: String,
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(endpoint, method: .delete, headers: headers, body: nil, completion: completion)
    }
}

// Для пустых ответов (например, после DELETE)
struct EmptyResponse: Codable {}
