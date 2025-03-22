//
//  AppCoordinatorTests.swift
//  GitFeedTests
//
//  Created by Dat on 21/03/2025.
//

import XCTest
import SwiftUI
@testable import GitFeed

@MainActor
final class AppCoordinatorTests: XCTestCase {
    private var coordinator: AppCoordinator!
    private var stubDependencies: StubDependencies!
    
    override func setUp() {
        super.setUp()
        stubDependencies = StubDependencies()
        coordinator = AppCoordinator(dependencies: stubDependencies)
    }
    
    override func tearDown() {
        coordinator = nil
        stubDependencies = nil
        super.tearDown()
    }

    func testPushScreen() {
        coordinator.push(.list)
        XCTAssertEqual(coordinator.navPath.count, 1)

        coordinator.push(.userDetail(stubUser))
        XCTAssertEqual(coordinator.navPath.count, 2)
    }

    func testPopScreen() {
        coordinator.push(.list)
        coordinator.push(.userDetail(stubUser))
        XCTAssertEqual(coordinator.navPath.count, 2)

        coordinator.pop()
        XCTAssertEqual(coordinator.navPath.count, 1)
    }

    func testPopToRoot() {
        coordinator.push(.list)
        coordinator.push(.userDetail(stubUser))
        XCTAssertEqual(coordinator.navPath.count, 2)

        coordinator.popToRoot()
        XCTAssertEqual(coordinator.navPath.count, 0)
    }

    func testBuildListView() {
        _ = coordinator.build(.list)
        XCTAssertEqual(stubDependencies.funcTrace, ["makeUsersViewModel", "makeUsersPaging"])
    }

    func testBuildUserDetailView() {
        _ = coordinator.build(.userDetail(stubUser))
        XCTAssertEqual(stubDependencies.funcTrace, ["makeDetailViewModel"])
    }
}

extension AppCoordinatorTests {
    private var stubUser: GitUser {
        return createRandomUsers(in: 1...1)[0]
    }
}
