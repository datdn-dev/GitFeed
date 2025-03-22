//
//  GitFeedRepoImpl.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

class GitFeedRepoImpl: GitFeedRepository {
    private let httpClient: HTTPClient
    private let localStorage: LocalStorage
    
    init(httpClient: HTTPClient, localStorage: LocalStorage) {
        self.httpClient = httpClient
        self.localStorage = localStorage
    }
    
    func fetchUsers(request: UserPageRequest) async throws -> [GitUser] {
        if request.isFirstPage {
            let localUsers = await fetchLocalUsers()
            guard !localUsers.isEmpty else { return try await fetchRemoteUsers(request: request) }
            return localUsers
        }
        return try await fetchRemoteUsers(request: request)
    }
    
    func fetchUserDetail(username: String) async throws -> GitUserDetail {
        let endpoint = GitEndpoint.detail(username: username)
        return try await httpClient.request(endpoint: endpoint, decoder: JSONDecoder())
    }
}

extension GitFeedRepoImpl {
    private func fetchLocalUsers() async -> [GitUser] {
        return await localStorage.loadUsers()
    }
    
    private func fetchRemoteUsers(request: UserPageRequest) async throws -> [GitUser] {
        let endpoint = GitEndpoint.users(since: request.since, perPage: request.pageSize)
        let users: [GitUser] = try await httpClient.request(endpoint: endpoint, decoder: JSONDecoder())
        await localStorage.saveUsers(users)
        return users
    }
}
