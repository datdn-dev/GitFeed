//
//  String+Extensions.swift
//  GitFeed
//
//  Created by Dat on 22/03/2025.
//

import Foundation

extension String {
    /// Error message displayed when fetching data fails.
    static let fetchingErrorMessage = String(localized: "fetching_error_message")
    
    /// Label for the number of followers.
    static let follower = String(localized: "follower")
    
    /// Label for the number of following users.
    static let following = String(localized: "following")
    
    /// Label for the retry action button.
    static let retry = String(localized: "retry")
    
    /// Navigation title for the users list screen.
    static let usersNavTitle = String(localized: "users_list_nav_title")
    
    /// Navigation title for the user detail screen.
    static let userDetailNavTitle = String(localized: "user_detail_nav_title")
    
    /// Label for the user’s blog section.
    static let blog = String(localized: "blog")
}
