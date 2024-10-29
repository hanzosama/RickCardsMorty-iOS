//
//  RequestDispatcher.swift
//  RickCardsMorty
//
//  Created by HanzoMac on 13/09/21.
//
import Foundation
import Combine

public enum RequestError: String, Error {
    case missingURL = "URL is nil"
    case badInputData = "Bad input data"
    case serverError = "Server Error"
    case unknown = "Unknown Error"
}

public protocol Dispatcher {
    
    init(environment: NetworkingEnvironment)
    
    func execute<T: Decodable>(request: Request, responseObject: T.Type) async throws -> T
    
}

public class RequestDispatcher: Dispatcher {
    private var cancellables: Set<AnyCancellable> = []
    private var environment: NetworkingEnvironment
    private var session: URLSession
    
    public required init(environment: NetworkingEnvironment) {
        self.environment = environment
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    public func execute<T: Decodable>(
        request: Request,
        responseObject: T.Type
    ) async throws -> T {
        do {
            let urlRequest = try self.prepare(for: request)
            let publisher = session.dataTaskPublisher(for: urlRequest)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                        throw RequestError.unknown
                    }
                    
                    return data
                    
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error in
                    if let error = error as? RequestError {
                        return error
                    } else {
                        return RequestError.serverError
                    }
                }
                .eraseToAnyPublisher()
            
            return try await withCheckedThrowingContinuation { continuation in
                publisher.sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                } receiveValue: { data in
                    continuation.resume(returning: data)
                }
                .store(in: &cancellables)
            }
        } catch {
            if let error = error as? RequestError {
                throw error
            } else {
                throw RequestError.unknown
            }
        }
        
    }
    
    private func prepare(for request: Request) throws -> URLRequest {
        let completeUrl = environment.host + environment.baseURL + request.path
        guard let url = URL(string: completeUrl) else {
            throw RequestError.missingURL
        }
        
        var urlRequest = URLRequest(url: url)
        
        switch request.parameters {
        case .body(let params):
            // JSON as Body
            if let params = params as? [String: String] {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } else {
                throw RequestError.badInputData
            }
            
        case .url(let params):
            if params.isEmpty {
                break
            }
            // URL Quey String
            guard var components = URLComponents(string: completeUrl) else {
                throw RequestError.badInputData
            }
            
            if let params = params as? [String: String] {
                let queryParams = params.map({ (element) -> URLQueryItem in
                    return URLQueryItem(name: element.key, value: element.value)
                })
                components.queryItems = queryParams
                urlRequest.url = components.url
            } else {
                let queryParams = params.map({ (element) -> URLQueryItem in
                    let value = String(describing: element.value)
                    return URLQueryItem(name: element.key, value: value)
                })
                components.queryItems = queryParams
                urlRequest.url = components.url
            }
        }
        
        environment.headers.forEach { urlRequest.addValue(($0.value as? String) ?? "", forHTTPHeaderField: $0.key) }
        request.headers?.forEach { urlRequest.addValue(($0.value as? String) ?? "", forHTTPHeaderField: $0.key)}
        
        urlRequest.httpMethod = request.method.rawValue
        
        return urlRequest
    }
}
