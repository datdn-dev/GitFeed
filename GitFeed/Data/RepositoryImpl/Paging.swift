//
//  Paging.swift
//  GitFeed
//
//  Created by Dat on 20/03/2025.
//

import Foundation

/// A protocol defining pagination for fetching GitHub users.
protocol UsersPaging {
    /// Indicates whether more users are available for fetching.
    var avaiableUsers: Bool { get }
    
    /// Fetches the next page of users asynchronously.
    ///
    /// - Returns: An array of `GitUser` objects.
    /// - Throws: An error if fetching users fails.
    func fetchNextUsers() async throws -> [GitUser]
}

/// A concrete implementation of `UsersPaging` that handles paginated fetching of GitHub users.
final class GitUsersPaging: UsersPaging {
    /// The repository used for fetching GitHub users.
    private let repository: GitFeedRepository
    
    /// The number of users to fetch per page.
    private let pageSize: Int
    
    /// The index used to track pagination progress.
    private var fetchingIndex = 0
    
    /// Indicates whether more users are available for fetching.
    var avaiableUsers: Bool
    
    /// Initializes a new instance of `GitUsersPaging`.
    ///
    /// - Parameters:
    ///   - pageSize: The number of users to fetch per page.
    ///   - repository: The repository responsible for fetching GitHub users.
    init(pageSize: Int, repository: GitFeedRepository) {
        self.repository = repository
        self.avaiableUsers = true
        self.pageSize = pageSize
    }
    
    /// Fetches the next batch of GitHub users asynchronously.
    ///
    /// - Returns: An array of `GitUser` objects.
    /// - Throws: An error if fetching users fails.
    func fetchNextUsers() async throws -> [GitUser] {
        let request = UserPageRequest(since: fetchingIndex, pageSize: pageSize)
        let users = try await repository.fetchUsers(request: request)
        advanceIndex(from: users)
        checkHasMoreUsers(from: users)
        return users
    }
    
    /// Advances the fetching index based on the last retrieved user.
    ///
    /// - Parameter users: The list of fetched users.
    private func advanceIndex(from users: [GitUser]) {
        guard !users.isEmpty else { return }
        guard let lastIndex = users.last?.id else { return }
        fetchingIndex = lastIndex + 1
    }
    
    /// Checks if more users are available to fetch and updates `avaiableUsers` accordingly.
    ///
    /// - Parameter users: The list of fetched users.
    private func checkHasMoreUsers(from users: [GitUser]) {
        avaiableUsers = users.count >= pageSize
    }
}
