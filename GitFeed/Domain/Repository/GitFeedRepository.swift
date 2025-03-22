//
//  GitFeedRepository.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

/// Protocol defining methods to fetch user data.
protocol GitFeedRepository {
    /// Fetches a list of GitHub users based on pagination request.
    /// - Parameter request: The request containing pagination details.
    /// - Returns: An array of `GitUser` objects.
    /// - Throws: An error if the request fails.
    func fetchUsers(request: UserPageRequest) async throws -> [GitUser]
    
    /// Fetches detailed information of a GitHub user.
    /// - Parameter username: The username of the GitHub user.
    /// - Returns: A `GitUserDetail` object containing user details.
    /// - Throws: An error if the request fails.
    func fetchUserDetail(username: String) async throws -> GitUserDetail
}
