//
//  StubGitFeedRepository.swift
//  GitFeedTests
//
//  Created by Dat on 19/03/2025.
//

import Foundation
@testable import GitFeed

class StubGitFeedRepository: GitFeedRepository {
    var users: [GitUser] = []
    var userDetail: GitUserDetail?
    var error: Error?
    var request: UserPageRequest?
    
    func fetchUserDetail(username: String) async throws -> GitUserDetail {
        if let error = error {
            throw error
        }
        return userDetail!
    }

    func fetchUsers(request: UserPageRequest) async throws -> [GitUser] {
        if let error {
            throw error
        }
        self.request = request
        return users
    }
}
