//
//  GitUserDetail.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

/// Represents detailed information about a user.
struct GitUserDetail: Decodable {
    let id: Int
    let login: String
    let avatarURL: URL?
    let htmlURL: URL?
    let location: String?
    let followers: Int?
    let following: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case location
        case followers
        case following
    }
}
