//
//  GithubClient.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

enum APIError: Error {
    case badURL
    case badResponse
    case decodingFailed(Error)
}

class GitClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
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
