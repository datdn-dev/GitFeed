//
//  GitUsersViewModelTests.swift
//  GitFeedTests
//
//  Created by Dat on 19/03/2025.
//

import XCTest
import Combine
@testable import GitFeed

@MainActor
class GitUsersViewModelTests: XCTestCase {
    var viewModel: GitUsersViewModel!
    var stubPaging: StubUsersPaging!
    
    private var states: [String: [Bool]] = [:]
    private var bindings: [(Published<Bool>.Publisher, String)] = []
    private var cancelable = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        stubPaging = StubUsersPaging()
        viewModel = GitUsersViewModel(paging: stubPaging)
        setStates()
        setBindings()
    }

    override func tearDown() {
        viewModel = nil
        stubPaging = nil
        states = [:]
        bindings = []
        cancelable.forEach { $0.cancel() }
        cancelable.removeAll()
        super.tearDown()
    }

    func testFetchUsers_success() async {
        stubPaging.users = createRandomUsers(in: 1...1)
        setStates()
        await viewModel.fetchUsers()
        
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertEqual(viewModel.users.first, stubPaging.users.last)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isLoadMore)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(states["isLoading"], [false, true, false])
        XCTAssertEqual(states["isLoadMore"], [false])
        XCTAssertEqual(states["showError"], [false])
    }

    func testFetchUsers_failure() async {
        stubPaging.error = error
        
        await viewModel.fetchUsers()
        
        XCTAssertEqual(viewModel.users.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isLoadMore)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorTitle, "This is a error message")
        XCTAssertEqual(states["isLoading"], [false, true, false])
        XCTAssertEqual(states["isLoadMore"], [false])
        XCTAssertEqual(states["showError"], [false, true])
    }
    
    func testFetchMoreUsers_notAvailableNextPage() async {
        let users = createRandomUsers(in: 1...1)
        stubPaging.users = users
        viewModel.users = users
        stubPaging.avaiableUsers = false
        setStates()
        
        await viewModel.fetchMoreUsers(from: users.last!)
        
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isLoadMore)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(states["isLoading"], [])
        XCTAssertEqual(states["isLoadMore"], [])
        XCTAssertEqual(states["showError"], [])
    }
    
    func testFetchMoreUsers_whenNotLastUser() async {
        let users = createRandomUsers(in: 1...2)
        stubPaging.users = users
        viewModel.users = users
        setStates()
        
        await viewModel.fetchMoreUsers(from: users.first!)
        
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isLoadMore)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(states["isLoading"], [])
        XCTAssertEqual(states["isLoadMore"], [])
        XCTAssertEqual(states["showError"], [])
    }
    
    func testFetchMoreUsers_whenIsLoadingMore() async {
        let users = createRandomUsers(in: 1...1)
        stubPaging.users = users
        viewModel.users = users
        viewModel.isLoadMore = true
        setStates()
        
        await viewModel.fetchMoreUsers(from: users.last!)
        
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.isLoadMore)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(states["isLoading"], [])
        XCTAssertEqual(states["isLoadMore"], [])
        XCTAssertEqual(states["showError"], [])
    }
    
    func testFetchMoreUsers_success() async {
        let currentUsers = createRandomUsers(in: 1...1)
        viewModel.users = currentUsers
        stubPaging.users = createRandomUsers(in: 2...2)
        setStates()
        
        await viewModel.fetchMoreUsers(from: currentUsers.last!)
        
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isLoadMore)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(states["isLoading"], [])
        XCTAssertEqual(states["isLoadMore"], [true, false])
        XCTAssertEqual(states["showError"], [])
    }
    
    func testFetchMoreUsers_fail() async {
        let currentUsers = createRandomUsers(in: 1...1)
        viewModel.users = currentUsers
        stubPaging.error = error
        setStates()
        
        await viewModel.fetchMoreUsers(from: currentUsers.last!)
        
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isLoadMore)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorTitle, "This is a error message")
        XCTAssertEqual(states["isLoading"], [])
        XCTAssertEqual(states["isLoadMore"], [true, false])
        XCTAssertEqual(states["showError"], [true])
    }
}

func createRandomUsers(in range: ClosedRange<Int>) -> [GitUser] {
    range.map { id in
        GitUser(id: id, login: "\(id)", avatarURL: URL(string: "\(id)")!, htmlURL: URL(string: "\(id)")!)
    }
}

extension GitUsersViewModelTests {
    private var error: NSError {
        NSError(
            domain: "com.userviewmodel.error",
            code: 1001,
            userInfo: [NSLocalizedDescriptionKey: "This is a error message"]
        )
    }
    
    private func setStates() {
        states = [
            "isLoading": [],
            "isLoadMore": [],
            "showError": []
        ]
    }
    
    private func setBindings() {
        bindings = [
            (viewModel.$isLoading, "isLoading"),
            (viewModel.$isLoadMore, "isLoadMore"),
            (viewModel.$showError, "showError"),
        ]
        
        for (publisher, key) in bindings {
            publisher.dropFirst()
                .sink { self.states[key]?.append($0) }
                .store(in: &cancelable)
        }
    }
}
