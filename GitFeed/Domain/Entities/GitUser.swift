//
//  GitUser.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

/// Represents a user with essential details.
struct GitUser: Codable, Identifiable {
    let id: Int
    let login: String
    let avatarURL: URL
    let htmlURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
}

extension GitUser: Equatable, Hashable { }
