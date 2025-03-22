//
//  GitFeedRepoImpl.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

/// A concrete implementation of `GitFeedRepository` that fetches GitHub users and user details.
/// This class integrates both remote API fetching via `HTTPClient` and local caching via `LocalStorage`.
class GitFeedRepoImpl: GitFeedRepository {
    /// The HTTP client used for network requests.
    private let httpClient: HTTPClient
    
    /// The local storage used for caching user data.
    private let localStorage: LocalStorage
    
    /// Initializes a new instance of `GitFeedRepoImpl`.
    ///
    /// - Parameters:
    ///   - httpClient: The HTTP client for making API requests.
    ///   - localStorage: The local storage for caching fetched users.
    init(httpClient: HTTPClient, localStorage: LocalStorage) {
        self.httpClient = httpClient
        self.localStorage = localStorage
    }
    
    /// Fetches a list of GitHub users, either from local storage or from the remote API.
    ///
    /// - Parameter request: The pagination request containing the `since` parameter and page size.
    /// - Returns: An array of `GitUser` objects.
    /// - Throws: An error if fetching from the remote API fails.
    func fetchUsers(request: UserPageRequest) async throws -> [GitUser] {
        if request.isFirstPage {
            let localUsers = await fetchLocalUsers()
            guard !localUsers.isEmpty else { return try await fetchRemoteUsers(request: request) }
            return localUsers
        }
        return try await fetchRemoteUsers(request: request)
    }
    
    /// Fetches detailed information about a specific GitHub user.
    ///
    /// - Parameter username: The GitHub username of the user to fetch details for.
    /// - Returns: A `GitUserDetail` object containing detailed user information.
    /// - Throws: An error if the network request fails.
    func fetchUserDetail(username: String) async throws -> GitUserDetail {
        let endpoint = GitEndpoint.detail(username: username)
        return try await httpClient.request(endpoint: endpoint, decoder: JSONDecoder())
    }
}

extension GitFeedRepoImpl {
    /// Loads users from local storage asynchronously.
    ///
    /// - Returns: An array of `GitUser` objects stored locally.
    private func fetchLocalUsers() async -> [GitUser] {
        return await localStorage.loadUsers()
    }
    
    /// Fetches users from the GitHub API and stores them in local storage.
    ///
    /// - Parameter request: The pagination request for fetching users.
    /// - Returns: An array of `GitUser` objects retrieved from the API.
    /// - Throws: An error if the API request fails.
    private func fetchRemoteUsers(request: UserPageRequest) async throws -> [GitUser] {
        let endpoint = GitEndpoint.users(since: request.since, perPage: request.pageSize)
        let users: [GitUser] = try await httpClient.request(endpoint: endpoint, decoder: JSONDecoder())
        await localStorage.saveUsers(users)
        return users
    }
}
