//
//  Screen.swift
//  GitFeed
//
//  Created by Dat on 21/03/2025.
//

import Foundation

/// Represents different screens in the GitFeed app.
enum Screen: Hashable {
    /// The screen displaying the list of users.
    case list
    
    /// The screen displaying details of a specific user.
    /// - Parameter user: The `GitUser` object containing user details.
    case userDetail(GitUser)
}
