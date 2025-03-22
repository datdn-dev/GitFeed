//
//  GithubClient.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

/// Defines possible API errors that can occur during network requests.
enum APIError: Error {
    /// Indicates that the provided URL is invalid.
    case badURL
    
    /// Represents an invalid or unexpected HTTP response.
    case badResponse
    
    /// Occurs when decoding the response data fails.
    case decodingFailed(Error)
}

/// A concrete implementation of `HTTPClient` for handling network requests to GitHub's API.
class GitClient: HTTPClient {
    /// The URL session used for making network requests.
    private let session: URLSession
    
    /// Initializes a new `GitClient` instance.
    ///
    /// - Parameter session: The `URLSession` instance to use. Defaults to `.shared`.
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Sends an HTTP request to the specified endpoint and decodes the response.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint to request.
    ///   - decoder: The `JSONDecoder` used for decoding the response. Defaults to a new `JSONDecoder` instance.
    /// - Returns: A decoded object of type `T`.
    /// - Throws: An `APIError` if the request fails or decoding is unsuccessful.
    func request<T: Decodable>(endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        guard let urlRequest = makeURLRequest(from: endpoint) else {
            throw APIError.badURL
        }
        
        let (data, response) = try await self.session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, (200 ..< 400).contains(httpResponse.statusCode) else {
            throw APIError.badResponse
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
    
    /// Constructs a `URLRequest` from the given `Endpoint`.
    ///
    /// - Parameter endpoint: The endpoint to create a request for.
    /// - Returns: A configured `URLRequest`, or `nil` if the URL is invalid.
    private func makeURLRequest(from endpoint: Endpoint) -> URLRequest? {
        guard var url = endpoint.baseURL else { return nil }
        url = url.appending(path: endpoint.path)
        
        // Add query items
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        var queryItems = components?.queryItems ?? []
        for (key, value) in endpoint.queryItems ?? [:] {
            queryItems += [URLQueryItem(name: key, value: value)]
        }
        components?.queryItems = queryItems
        
        var urlRequest = URLRequest(url: components?.url ?? url)
        
        // Add HTTP method
        urlRequest.httpMethod = endpoint.method.rawValue
        
        // Add body
        urlRequest.httpBody = endpoint.body
        
        // Add header
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        for (key, value) in endpoint.headers ?? [:] {
            headers[key] = value
        }
        urlRequest.allHTTPHeaderFields = headers
        
        return urlRequest
    }
}
