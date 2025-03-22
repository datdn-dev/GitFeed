//
//  GitEndpointTests.swift
//  GitFeedTests
//
//  Created by Dat on 18/03/2025.
//

import XCTest
@testable import GitFeed

class GitEndpointTests: XCTestCase {
    func testUsersEndpoint() {
        let endpoint = GitEndpoint.users(since: 100, perPage: 30)
        
        XCTAssertEqual(endpoint.baseURL, URL(string: "https://api.github.com"))
        XCTAssertEqual(endpoint.path, "/users")
        XCTAssertEqual(endpoint.method, .GET)
        XCTAssertEqual(endpoint.headers, ["Content-Type": "application/json;charset=utf-8"])
        XCTAssertEqual(endpoint.queryItems, ["since": "100", "per_page": "30"])
        XCTAssertNil(endpoint.body)
    }
    
    func testDetailEndpoint() {
        let username = "octocat"
        let endpoint = GitEndpoint.detail(username: username)
        
        XCTAssertEqual(endpoint.baseURL, URL(string: "https://api.github.com"))
        XCTAssertEqual(endpoint.path, "/users/\(username)")
        XCTAssertEqual(endpoint.method, .GET)
        XCTAssertEqual(endpoint.headers, ["Content-Type": "application/json;charset=utf-8"])
        XCTAssertNil(endpoint.queryItems)
        XCTAssertNil(endpoint.body)
    }
}
