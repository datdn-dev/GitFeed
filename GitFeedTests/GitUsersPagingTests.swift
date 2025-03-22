//
//  GitUsersPagingTests.swift
//  GitFeedTests
//
//  Created by Dat on 21/03/2025.
//

import XCTest
@testable import GitFeed

final class GitUsersPagingTests: XCTestCase {
    private var paging: GitUsersPaging!
    private var stubRepository: StubGitFeedRepository!
    
    override func setUp() {
        super.setUp()
        stubRepository = StubGitFeedRepository()
        paging = GitUsersPaging(pageSize: 2, repository: stubRepository)
    }
    
    override func tearDown() {
        paging = nil
        stubRepository = nil
        super.tearDown()
    }

    func testFetchNextUsers_success() async throws {
        stubRepository.users = createRandomUsers(in: 1...2)

        let users = try await paging.fetchNextUsers()
        
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users.first?.id, 1)
        XCTAssertEqual(users.last?.id, 2)
        XCTAssertTrue(paging.avaiableUsers)
    }
    
    func testFetchNextUsers_and_fetchNextUsers_success() async throws {
        stubRepository.users = createRandomUsers(in: 1...2)
        _ = try await paging.fetchNextUsers()
        
        stubRepository.users = createRandomUsers(in: 3...3)
        let users = try await paging.fetchNextUsers()
        
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.last?.id, 3)
        XCTAssertFalse(paging.avaiableUsers)
        XCTAssertEqual(stubRepository.request?.since, 3)
        XCTAssertEqual(stubRepository.request?.pageSize, 2)
    }
    
    func testFetchNextUsers_emptyResult() async throws {
        stubRepository.users = []

        let users = try await paging.fetchNextUsers()

        XCTAssertTrue(users.isEmpty)
        XCTAssertFalse(paging.avaiableUsers)
    }
    
    func testFetchNextUsers_failure() async {
        stubRepository.error = NSError(domain: "com.gitfeed.error", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        
        await XCTAssertThrowsErrorAsync(try await paging.fetchNextUsers())
    }
}
