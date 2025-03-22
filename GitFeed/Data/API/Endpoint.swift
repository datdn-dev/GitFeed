//
//  Endpoint.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

protocol Endpoint {
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [String: String]? { get }
    var body: Data? { get }
}
