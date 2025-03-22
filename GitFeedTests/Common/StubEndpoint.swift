//
//  StubEndpoint.swift
//  GitFeedTests
//
//  Created by Dat on 18/03/2025.
//

import Foundation
@testable import GitFeed

struct StubEndpoint: Endpoint {
    var baseURL: URL?
    var path: String
    var method: HTTPMethod
    var headers: [String : String]?
    var queryItems: [String : String]?
    var body: Data?
    
    init(baseURL: URL? = nil, path: String = "", method: HTTPMethod = .GET, headers: [String : String]? = nil, queryItems: [String : String]? = nil, body: Data? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }
    
}
