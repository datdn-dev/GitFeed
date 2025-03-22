//
//  GitClientTests.swift
//  GitFeedTests
//
//  Created by Dat on 18/03/2025.
//

import XCTest
@testable import GitFeed

final class GitClientTests: XCTestCase {
    private var apiClient: GitClient!
    private var urlSession: URLSession!
    
    private let normalEndpoint = StubEndpoint(baseURL: URL(string: "https://api.github.com/user")!)
    private let invalidEndpoint = StubEndpoint(baseURL: nil)
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        apiClient = GitClient(session: urlSession)
    }
    
    override func tearDown() {
        StubURLProtocol.reset()
        apiClient = nil
        urlSession = nil
        super.tearDown()
    }
    
    func testRequest_success() async throws {
        let expectedData = "{\"name\": \"John Doe\"}".data(using: .utf8)!
        StubURLProtocol.response = makeResponse(with: expectedData)
        
        let user: StubUser = try await apiClient.request(endpoint: normalEndpoint)
        XCTAssertEqual(user.name, "John Doe")
    }
    
    func testRequest_badURL() async {
        await Task {
            do {
                let _: StubUser = try await apiClient.request(endpoint: invalidEndpoint)
                XCTFail("Expected request to fail, but it succeeded.")
            } catch {
                XCTAssertEqual(error as? APIError, APIError.badURL)
            }
        }.value
    }
    
    func testRequest_badResponse() async {
        StubURLProtocol.response = makeResponse(with: Data(), code: 500)

        await Task {
            do {
                let _: StubUser = try await apiClient.request(endpoint: normalEndpoint)
                XCTFail("Expected request to fail, but it succeeded.")
            } catch {
                XCTAssertEqual(error as? APIError, APIError.badResponse)
            }
        }.value
    }
    
    func testRequest_decodingFailed() async {
        let invalidData = "Invalid JSON".data(using: .utf8)!
        StubURLProtocol.response = makeResponse(with: invalidData)
        
        await Task {
            do {
                let _: StubUser = try await apiClient.request(endpoint: normalEndpoint)
                XCTFail("Expected request to fail, but it succeeded.")
            } catch {
                if case APIError.decodingFailed(_) = error {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("Expected decodingFailed error")
                }
            }
        }.value
    }
}

extension GitClientTests {
    private func makeResponse(with data: Data,
                                     url: String = "https://api.github.com/user",
                                     code: Int = 200,
                                     version: String? = nil,
                                     headerFields: [String: String]? = nil) -> StubAPIResponse {
        let response = HTTPURLResponse(url: URL(string: url)!, statusCode: code, httpVersion: version, headerFields: headerFields)!
        return (data, response)
    }
}
