//
//  GitEndpoint.swift
//  GithubFeed
//
//  Created by Dat Doan on 18/3/25.
//

import Foundation

/// An enumeration defining API endpoints for GitHub user data.
enum GitEndpoint: Endpoint {
    /// Fetches a paginated list of GitHub users.
    /// - Parameters:
    ///   - since: The user ID to start fetching from.
    ///   - perPage: The number of users to fetch per request.
    case users(since: Int, perPage: Int)
    
    /// Fetches details of a specific GitHub user.
    /// - Parameter username: The GitHub username.
    case detail(username: String)
    
    /// The base URL for the GitHub API.
    var baseURL: URL? {
        return URL(string: "https://api.github.com")
    }

    /// The specific path for the API request.
    var path: String {
        switch self {
        case .users: return "/users"
        case .detail(let username): return "/users/\(username)"
        }
    }

    /// The HTTP method used for the request.
    var method: HTTPMethod {
        return .GET
    }

    /// The headers to include in the API request.
    var headers: [String : String]? {
        return ["Content-Type" : "application/json;charset=utf-8"]
    }

    /// The query parameters to append to the URL.
    var queryItems: [String : String]? {
        switch self {
        case .users(let since, let perPage):
            return ["since": String(since), "per_page": String(perPage)]
        default:
            return nil
        }
    }

    /// The request body data, if applicable.
    var body: Data? {
        return nil
    }
}
