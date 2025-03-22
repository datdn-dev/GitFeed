//
//  Paging.swift
//  GitFeed
//
//  Created by Dat on 20/03/2025.
//

import Foundation

protocol UsersPaging {
    var avaiableUsers: Bool { get }
    func fetchNextUsers() async throws -> [GitUser]
}

final class GitUsersPaging: UsersPaging {
    private let repository: GitFeedRepository
    private let pageSize: Int
    private var fetchingIndex = 0
    var avaiableUsers: Bool
    
    init(pageSize: Int, repository: GitFeedRepository) {
        self.repository = repository
        self.avaiableUsers = true
        self.pageSize = pageSize
    }
    
    func fetchNextUsers() async throws -> [GitUser] {
        let request = UserPageRequest(since: fetchingIndex, pageSize: pageSize)
        let users = try await repository.fetchUsers(request: request)
        advanceIndex(from: users)
        checkHasMoreUsers(from: users)
        return users
    }
    
    private func advanceIndex(from users: [GitUser]) {
        guard !users.isEmpty else { return }
        guard let lastIndex = users.last?.id else { return }
        fetchingIndex = lastIndex + 1
    }
    
    private func checkHasMoreUsers(from users: [GitUser]) {
        avaiableUsers = users.count >= pageSize
    }
}
