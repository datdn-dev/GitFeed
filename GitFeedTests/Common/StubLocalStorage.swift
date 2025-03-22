//
//  StubLocalStorage.swift
//  GitFeedTests
//
//  Created by Dat on 21/03/2025.
//

import Foundation
@testable import GitFeed

class StubLocalStorage: LocalStorage {
    var users: [GitUser] = []
    var savedUsers: [GitUser] = []

    func saveUsers(_ users: [GitUser]) async {
        savedUsers = users
    }

    func loadUsers() async -> [GitUser] {
        return users
    }
}
