//
//  UserPageRequest.swift
//  GitFeed
//
//  Created by Dat on 21/03/2025.
//

import Foundation

/// Represents a request for paginated GitHub user data.
struct UserPageRequest {
    let since: Int
    let pageSize: Int
    
    /// Indicates if this request is for the first page.
    var isFirstPage: Bool {
        return since == 0
    }
}
