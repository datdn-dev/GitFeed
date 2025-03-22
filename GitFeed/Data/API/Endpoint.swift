//
//  Endpoint.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

/// An enumeration representing HTTP methods for network requests.
enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

/// A protocol defining the structure of an API endpoint.
protocol Endpoint {
    /// The base URL of the API.
    var baseURL: URL? { get }
    
    /// The specific path for the endpoint.
    var path: String { get }
    
    /// The HTTP method used for the request.
    var method: HTTPMethod { get }
    
    /// The headers to be included in the request.
    var headers: [String: String]? { get }
    
    /// The query parameters to be added to the URL.
    var queryItems: [String: String]? { get }
    
    /// The request body data.
    var body: Data? { get }
}
