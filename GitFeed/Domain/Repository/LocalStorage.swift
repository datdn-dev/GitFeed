//
//  LocalStorage.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

/// Protocol defining local storage operations for users.
protocol LocalStorage {
    /// Saves an array of GitHub users to local storage.
    /// - Parameter users: The list of `GitUser` objects to be saved.
    func saveUsers(_ users: [GitUser]) async
    
    /// Loads GitHub users from local storage.
    /// - Returns: An array of `GitUser` objects retrieved from local storage.
    func loadUsers() async -> [GitUser]
}
