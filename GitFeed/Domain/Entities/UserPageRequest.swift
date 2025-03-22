//
//  UserPageRequest.swift
//  GitFeed
//
//  Created by Dat on 21/03/2025.
//

import Foundation

struct UserPageRequest {
    let since: Int
    let pageSize: Int
}

extension UserPageRequest {
    var isFirstPage: Bool {
        return since == 0
    }
}
