//
//  GitFeedRepoImplTests.swift
//  GitFeedTests
//
//  Created by Dat on 21/03/2025.
//

import XCTest
@testable import GitFeed

class GitFeedRepoImplTests: XCTestCase {
    var repository: GitFeedRepoImpl!
    var stubHttpClient: StubHTTPClient!
    var stubLocalStorage: StubLocalStorage!

    override func setUp() {
        super.setUp()
        stubHttpClient = StubHTTPClient()
        stubLocalStorage = StubLocalStorage()
        repository = GitFeedRepoImpl(httpClient: stubHttpClient, localStorage: stubLocalStorage)
    }

    override func tearDown() {
        repository = nil
        stubHttpClient = nil
        stubLocalStorage = nil
        super.tearDown()
    }

    func testFetchUsers_firstPage_localStorageHasData() async throws {
        let localUsers = createUsers(in: 1...5)
        stubLocalStorage.users = localUsers

        let result = try await repository.fetchUsers(request: UserPageRequest(since: 0, pageSize: 5))

        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result, localUsers)
        XCTAssertFalse(stubHttpClient.didRequestUsers)
    }

    func testFetchUsers_firstPage_localStorageEmpty_fetchRemote() async throws {
        let remoteUsers = createUsers(in: 1...5)
        stubLocalStorage.users = []
        stubHttpClient.users = remoteUsers

        let result = try await repository.fetchUsers(request: UserPageRequest(since: 0, pageSize: 5))

        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result, remoteUsers)
        XCTAssertTrue(stubHttpClient.didRequestUsers)
        XCTAssertEqual(stubLocalStorage.savedUsers, remoteUsers)
    }

    func testFetchUsers_nonFirstPage_alwaysFetchRemote() async throws {
        let remoteUsers = createUsers(in: 6...10)
        stubLocalStorage.users = createUsers(in: 1...5)
        stubHttpClient.users = remoteUsers

        let result = try await repository.fetchUsers(request: UserPageRequest(since: 5, pageSize: 5))

        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result, remoteUsers)
        XCTAssertTrue(stubHttpClient.didRequestUsers)
    }

    func testFetchUsers_failToFetchRemote_throwsError() async {
        stubLocalStorage.users = []
        stubHttpClient.error = error

        await XCTAssertThrowsErrorAsync(try await repository.fetchUsers(request: UserPageRequest(since: 0, pageSize: 5)))
    }

    func testFetchUserDetail_success() async throws {
        let expectedDetail = GitUserDetail(id: 1, login: "user1", avatarURL: nil, htmlURL: nil, location: "Earth", followers: 100, following: 50)
        stubHttpClient.userDetail = expectedDetail

        let result = try await repository.fetchUserDetail(username: "user1")

        XCTAssertEqual(result, expectedDetail)
    }

    func testFetchUserDetail_fails_throwsError() async {
        stubHttpClient.error = error

        await XCTAssertThrowsErrorAsync(try await repository.fetchUserDetail(username: "user1"))
    }
}

extension GitFeedRepoImplTests {
    private var error: Error {
        NSError(domain: "Test", code: 500, userInfo: nil)
    }
    
    private func createUsers(in range: ClosedRange<Int>) -> [GitUser] {
        return range.map { id in
            GitUser(id: id, login: "\(id)", avatarURL: URL(string: "\(id)")!, htmlURL: URL(string: "\(id)")!)
        }
    }
}

extension GitUserDetail: Equatable {
    public static func == (lhs: GitUserDetail, rhs: GitUserDetail) -> Bool {
        return lhs.id == rhs.id
    }
}

