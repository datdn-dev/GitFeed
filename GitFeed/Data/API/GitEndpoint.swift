//
//  GitEndpoint.swift
//  GithubFeed
//
//  Created by Dat Doan on 18/3/25.
//

import Foundation

enum GitEndpoint: Endpoint {
    case users(since: Int, perPage: Int)
    case detail(username: String)
    
    
    var baseURL: URL? {
        return URL(string: "https://api.github.com")
    }

    var path: String {
        switch self {
        case .users: return "/users"
        case .detail(let username): return "/users/\(username)"
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: [String : String]? {
        return ["Content-Type" : "application/json;charset=utf-8"]
    }

    var queryItems: [String : String]? {
        switch self {
        case .users(let since, let perPage):
            return ["since": String(since), "per_page": String(perPage)]
        default:
            return nil
        }
    }

    var body: Data? {
        return nil
    }
}
