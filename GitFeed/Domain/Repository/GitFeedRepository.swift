//
//  GitFeedRepository.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

protocol GitFeedRepository {
    func fetchUsers(request: UserPageRequest) async throws -> [GitUser]
    func fetchUserDetail(username: String) async throws -> GitUserDetail
}
