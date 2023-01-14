//
//  NetworkService.swift
//  RecetaPe
//
//  Created by Leonardo  on 12/01/23.
//

import Foundation

// MARK: Share URLSession's API
protocol RequestCancellable {
    func cancel()
}

extension URLSessionTask: RequestCancellable {}

// MARK: NetworkService
/// HTTP request method.
enum HttpMethod {
    case get, post, delete, put
}

/// Service contract.
protocol NetworkService {
    var host: String { get }
    var apiVersion: String { get }
    var service: String { get }
    var method: HttpMethod { get }
    var endpoint: String { get }
    var parameters: [String: Any] { get }
}

/// Concrete service type.
enum ServiceType: NetworkService {
    case getRecipe

    var host: String { "https://demo7993048.mockable.io" }
    var apiVersion: String { "v1" }
    var service: String {
        if case .getRecipe = self { return "recipes" }
        return ""
    }
    var method: HttpMethod { .get }
    
    var endpoint: String { "\(host)/\(apiVersion)/\(service)" }
    
    var parameters: [String : Any] {
        if case .getRecipe = self { return [:] }
        return [:]
    }
}
