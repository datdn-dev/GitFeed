//
//  FileLocalStorageTests.swift
//  GitFeedTests
//
//  Created by Dat on 22/03/2025.
//

import XCTest
@testable import GitFeed

final class FileLocalStorageTests: XCTestCase {
    var fileURL: URL!
    var storage: FileLocalStorage!

    override func setUp() {
        super.setUp()
        
        let tempDirectory = FileManager.default.temporaryDirectory
        fileURL = tempDirectory.appendingPathComponent("test_users.json")
        storage = FileLocalStorage(fileURL: fileURL)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: fileURL)
        storage = nil
        super.tearDown()
    }

    func testSaveAndLoadUsers() async throws {
        let users = createRandomUsers(in: 1...2)

        await storage.saveUsers(users)

        let loadedUsers = await storage.loadUsers()
        XCTAssertEqual(loadedUsers, users)
    }

    func testLoadUsers_whenFileDoesNotExist_shouldReturnEmptyArray() async throws {
        let users = await storage.loadUsers()
        XCTAssertTrue(users.isEmpty)
    }

    func testOverwriteUsersFile() async throws {
        let firstUsers = createRandomUsers(in: 1...1)
        await storage.saveUsers(firstUsers)

        let secondUsers = createRandomUsers(in: 2...3)
        await storage.saveUsers(secondUsers)

        let loadedUsers = await storage.loadUsers()
        XCTAssertEqual(loadedUsers, secondUsers)
    }

    func testDeleteUsersFile() async throws {
        let users = createRandomUsers(in: 1...1)
        await storage.saveUsers(users)

        try? FileManager.default.removeItem(at: fileURL)

        let loadedUsers = await storage.loadUsers()
        XCTAssertTrue(loadedUsers.isEmpty)
    }
}

