//
//  APIError+Extension.swift
//  GitFeedTests
//
//  Created by Dat on 18/03/2025.
//

import Foundation
@testable import GitFeed

extension APIError: Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.badURL, .badURL), (.badResponse, .badResponse):
            return true
        case let (.decodingFailed(lhsError), .decodingFailed(rhsError)):
            return type(of: lhsError) == type(of: rhsError)
        default:
            return false
        }
    }
}
