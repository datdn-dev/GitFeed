//
//  StubUsersPaging.swift
//  GitFeedTests
//
//  Created by Dat on 21/03/2025.
//

import Foundation
@testable import GitFeed

class StubUsersPaging: UsersPaging {
    var avaiableUsers = true
    var error: Error?
    var users: [GitUser] = []
    
    func fetchNextUsers() async throws -> [GitUser] {
        if let error {
            throw error
        }
        return users
    }
}
