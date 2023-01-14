//
//  NetworkManager.swift
//  RecetaPe
//
//  Created by Leonardo  on 11/01/23.
//

import Foundation

enum NetworkError: String, Error {
    case errorHttpRequestBuild        = "Error creating http request."
    case errorParametersEmpty         = "Error parameters are empty."
    case errorCreatingURL             = "Error creating URL."
    case errorAccessingRequestURL     = "Error accessing URLRequest' URL."
    case errorCreatingURLComponents   = "Error creating URLComponents."
    case errorStatusCode              = "Error status code (Not 200...299)."
    case errorJsonDecoding            = "Error JSON decoding."
    case errorTaskNoData              = "Error Task no data."
}

protocol RemoteRequestable {
    func request<T: Decodable>(_ model: T.Type, service: ServiceType, result: @escaping (Result<T?, Error>) -> Void)
    func requestResource(path: String, result: @escaping (Result<Data, Error>) -> Void) -> RequestCancellable?
}

/// In charge of making network requests to API's and retrieving remote resources.
final class NetworkManager: RemoteRequestable {
    // MARK: State
    typealias NetworkResult = (Result<Data, Error>) -> Void
    
    let imagesCache = CacheManager().getImageCache()
    
    static let shared = NetworkManager()
    
    // MARK: Initializers
    private init() {}
    
    // MARK: Methods
    /// Make network request by **service** using **parameters** waiting for a **result** callback.
    /// - Parameter service: The service to use to request a resource from.
    /// - Parameter params: The parameters to encode and append in the endpoint.
    /// - Parameter result: Callback of networks' async. actions.
    /// - Returns: HTTP Task with the option of cancelling the request.
    func request<T: Decodable>(_ model: T.Type, service: ServiceType, result: @escaping (Result<T?, Error>) -> Void) {
        // Session
        let httpSession = URLSession(configuration: .default)
        
        // Request
        guard let url = URL(string: service.endpoint) else {
            result(.failure(NetworkError.errorCreatingURL)); return
        }
        
        var httpRequest = URLRequest(url: url)
        
        // Build query parameters (No body parameters for now, as only get methods will be used)
        do {
            try buildHttpQuery(request: &httpRequest, params: service.parameters)
        } catch {
            result(.failure(error)); return
        }
        
        // Task
        let httpTask: URLSessionTask = httpSession.dataTask(with: httpRequest) {
            [weak self] (data, response, error) in
            guard let self = self else { return }
            // Checking if any error.
            if let error = error {
                result(.failure(error)); return
            }
            
            // Checking status code.
            if !self.handleStatusCode(response: response) {
                result(.failure(NetworkError.errorStatusCode)); return
            }
            
            // Checking there must be data if no errors found before.
            guard let data = data else {
                result(.failure(NetworkError.errorTaskNoData)); return
            }
            
            // Decoding to T type.
            if let json = try? JSONDecoder().decode(T.self, from: data) {
                result(.success(json)); return
            } else {
                result(.failure(NetworkError.errorJsonDecoding)); return
            }
        }
        
        // Start the http task
        httpTask.resume()
    }
    
    func requestResource(path: String, result: @escaping (Result<Data, Error>) -> Void) -> RequestCancellable? {
        // Session
        let httpSession = URLSession(configuration: .default)
        
        // Request
        guard let url = URL(string: path) else { result(.failure(NetworkError.errorCreatingURL)); return nil }
        let httpRequest = URLRequest(url: url)
        
        if let cacheValue = imagesCache.load(from: path), let data = cacheValue.value as? Data {
            result(.success(data))
            return nil
        }
        
        // Task
        let httpTask = httpSession.dataTask(with: httpRequest) {
            [weak self, weak imagesCache] (data, response, error) in
            guard let self = self else { return }
            
            // Checking if any error.
            if let error = error {
                result(.failure(error)); return
            }
            
            // Checking status code.
            if !self.handleStatusCode(response: response) {
                result(.failure(NetworkError.errorStatusCode)); return
            }
            
            // Checking there must be data if no errors found before.
            guard let data = data else {
                result(.failure(NetworkError.errorTaskNoData)); return
            }
            
            imagesCache?.save(key: path, value: data)
            result(.success(data))
        }
        
        httpTask.resume()
        return httpTask
    }
}

private extension NetworkManager {
    /// Takes a request and builds/encodes its query parameters.
    /// - Parameter request: An HTTPRequest.
    /// - Parameter params: Endpoint's parameters to build and endcode to send.
    func buildHttpQuery(request: inout URLRequest, params: [String: Any]) throws {
        guard let url = request.url else {
            throw NetworkError.errorAccessingRequestURL
        }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.errorCreatingURLComponents
        }
        
        // Reset query items
        components.queryItems = []
        
        for (key, value) in params {
            let queryItem = URLQueryItem(name: key,
                                         value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
            components.queryItems?.append(queryItem)
        }
        
        // Update request's url with the builder's
        request.url = components.url
        
        // Add Content-Type header if needed
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
    
    /// If status code is not 200 then return false.
    func handleStatusCode(response: URLResponse?) -> Bool {
        guard let code = (response as? HTTPURLResponse)?.statusCode else { return false }
        
        switch code {
            case 200 ... 299: return true
            default: return false
        }
    }
}
