//
//  GitUserDetailViewModelTests.swift
//  GitFeedTests
//
//  Created by Dat on 21/03/2025.
//

import XCTest
import Combine
import SwiftUI
@testable import GitFeed

@MainActor
class GitUserDetailViewModelTests: XCTestCase {
    var viewModel: GitUserDetailViewModel!
    var stubRepository: StubGitFeedRepository!
    var stubFormatter: StubNumberFormatter!
    
    private var states: [String: [Bool]] = [:]
    private var bindings: [(Published<Bool>.Publisher, String)] = []
    private var cancelables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        stubRepository = StubGitFeedRepository()
        stubFormatter = StubNumberFormatter()
        viewModel = GitUserDetailViewModel(username: "testuser", numberFormatter: stubFormatter, repository: stubRepository)
        setupBindings()
    }

    override func tearDown() {
        viewModel = nil
        stubRepository = nil
        stubFormatter = nil
        states = [:]
        bindings = []
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
        super.tearDown()
    }

    func testFetchUserDetail_success() async {
        stubRepository.userDetail = testUserDetail

        await viewModel.fetchUserDetail()
        
        let followerViewModel = viewModel.followerViewModel
        let followingViewModel = viewModel.followingViewModel
        
        XCTAssertEqual(viewModel.userDetail?.login, "testuser")
        XCTAssertEqual(viewModel.name, "Testuser")
        XCTAssertEqual(viewModel.location, "Earth")
        XCTAssertEqual(viewModel.avatarURL, URL(string: "https://example.com/avatar.png"))
        XCTAssertEqual(viewModel.blogURL, "https://example.com")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(states["isLoading"], [false, true, false])
        
        XCTAssertEqual(followerViewModel.title, "1K")
        XCTAssertEqual(followerViewModel.subtitle, "Follower")
        XCTAssertEqual(followerViewModel.image, Image(systemName: "person.2.fill"))
        XCTAssertEqual(followerViewModel.background, Color("IndicatorColor"))
        XCTAssertEqual(followingViewModel.title, "50")
        XCTAssertEqual(followingViewModel.subtitle, "Following")
        XCTAssertEqual(followingViewModel.image, Image(systemName: "rosette"))
        XCTAssertEqual(followingViewModel.background, Color("IndicatorColor"))
    }

    func testFetchUserDetail_failure() async {
        stubRepository.error = NSError(domain: "com.userdetailviewmodel.error", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Network Error"])

        await viewModel.fetchUserDetail()
        
        let followerViewModel = viewModel.followerViewModel
        let followingViewModel = viewModel.followingViewModel
        
        XCTAssertNil(viewModel.userDetail)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.name, "--")
        XCTAssertEqual(viewModel.location, "--")
        XCTAssertNil(viewModel.avatarURL)
        XCTAssertEqual(viewModel.blogURL, "--")
        XCTAssertEqual(viewModel.errorMessage, "Oops! Something went wrong. Please refresh or try again later.")
        XCTAssertEqual(states["isLoading"], [false, true, false])
        XCTAssertEqual(followerViewModel.title, "0")
        XCTAssertEqual(followerViewModel.subtitle, "Follower")
        XCTAssertEqual(followerViewModel.image, Image(systemName: "person.2.fill"))
        XCTAssertEqual(followerViewModel.background, Color("IndicatorColor"))
        XCTAssertEqual(followingViewModel.title, "0")
        XCTAssertEqual(followingViewModel.subtitle, "Following")
        XCTAssertEqual(followingViewModel.image, Image(systemName: "rosette"))
        XCTAssertEqual(followingViewModel.background, Color("IndicatorColor"))
    }
    
    func testFetchOnAppear_isLoading() async {
        stubRepository.userDetail = testUserDetail
        viewModel.isLoading = true
        await viewModel.fetchOnAppear()
        
        XCTAssertNil(viewModel.userDetail)
    }
    
    func testFetchOnAppear_notLoading() async {
        stubRepository.userDetail = testUserDetail
        await viewModel.fetchOnAppear()
        
        XCTAssertNotNil(viewModel.userDetail)
    }
}

// MARK: - State Tracking Helpers
extension GitUserDetailViewModelTests {
    private func setupBindings() {
        states = [
            "isLoading": []
        ]

        bindings = [
            (viewModel.$isLoading, "isLoading")
        ]
        
        for (publisher, key) in bindings {
            publisher
                .dropFirst()
                .sink { self.states[key]?.append($0) }
                .store(in: &cancelables)
        }
    }
    
    private var testUserDetail: GitUserDetail {
        GitUserDetail(
            id: 1,
            login: "testuser",
            avatarURL: URL(string: "https://example.com/avatar.png"),
            htmlURL: URL(string: "https://example.com"),
            location: "Earth",
            followers: 1000,
            following: 50)
    }
}

