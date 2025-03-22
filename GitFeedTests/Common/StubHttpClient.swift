//
//  StubHttpClient.swift
//  GitFeedTests
//
//  Created by Dat on 21/03/2025.
//

import Foundation
@testable import GitFeed

class StubHTTPClient: HTTPClient {
    var users: [GitUser] = []
    var userDetail: GitUserDetail?
    var error: Error?
    var didRequestUsers = false

    func request<T: Decodable>(endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        if let error = error { throw error }
        
        if let endpoint = endpoint as? GitEndpoint {
            if case .users = endpoint {
                didRequestUsers = true
                return users as! T
            } else {
                return userDetail as! T
            }
        }
        throw NSError(domain: "MockHTTPClient", code: 999, userInfo: nil)
    }
}
