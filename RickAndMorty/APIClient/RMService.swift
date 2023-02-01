//
//  RMService.swift
//  RickAndMorty
//
//  Created by Filip Varda on 25.01.2023..
//

import Foundation

/// Service that can make a API call if provided with RMRequest object
final class RMService {
    static let shared = RMService()
    
    private init() {}

    /// An enum with coresponding errors for simpler error handling and naming
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToFetchData
        case failedToDecodeData
    }

    /// Creating request with provided params
    private func requestFrom(_ rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = rmRequest.httpMethod
        return urlRequest
    }
    
    /// Executing the request.
    /// Parameter T is generic type that has to inherit from Codable.
    public func execute<T: Codable>(_ request: RMRequest,
                                    expected type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlRequest = requestFrom(request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        let task =  URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard error == nil, let data = data else {
                completion(.failure(error ?? RMServiceError.failedToFetchData))
                return
            }
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
