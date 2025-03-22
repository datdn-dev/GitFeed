//
//  StubDependencies.swift
//  GitFeedTests
//
//  Created by Dat on 21/03/2025.
//

import Foundation
@testable import GitFeed

class StubDependencies: Dependency {
    var funcTrace = [String]()
    
    func makeUsersPaging() -> UsersPaging {
        funcTrace.append("makeUsersPaging")
        return StubUsersPaging()
    }
    
    @MainActor func makeUsersViewModel() -> GitUsersViewModel {
        funcTrace.append("makeUsersViewModel")
        return GitUsersViewModel(paging: makeUsersPaging())
    }
    
    @MainActor func makeDetailViewModel(with user: GitUser) -> GitUserDetailViewModel {
        funcTrace.append("makeDetailViewModel")
        return GitUserDetailViewModel(username: user.login, numberFormatter: StubNumberFormatter(), repository: StubGitFeedRepository())
    }
}
