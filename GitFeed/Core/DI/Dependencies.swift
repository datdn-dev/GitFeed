//
//  Dependencies.swift
//  GitFeed
//
//  Created by Dat on 21/03/2025.
//

import Foundation

protocol Dependency {
    func makeUsersPaging() -> UsersPaging
    func makeUsersViewModel() -> GitUsersViewModel
    func makeDetailViewModel(with user: GitUser) -> GitUserDetailViewModel
}

struct Dependencies: Dependency {
    private let httpClient: HTTPClient
    private let localStorage: LocalStorage
    private let pageSize: Int
    
    init(httpClient: HTTPClient, localStorage: LocalStorage, pageSize: Int = 20) {
        self.httpClient = httpClient
        self.localStorage = localStorage
        self.pageSize = pageSize
    }
    
    var feedRepository: GitFeedRepository {
        return GitFeedRepoImpl(httpClient: httpClient, localStorage: localStorage)
    }
    
    var numberFormatter: NumberFormating {
        return SocialNumberFormater()
    }
    
    func makeUsersPaging() -> UsersPaging {
        return GitUsersPaging(pageSize: pageSize, repository: feedRepository)
    }
    
    @MainActor
    func makeUsersViewModel() -> GitUsersViewModel {
        return GitUsersViewModel(paging: makeUsersPaging())
    }
    
    @MainActor
    func makeDetailViewModel(with user: GitUser) -> GitUserDetailViewModel {
        return GitUserDetailViewModel(username: user.login, numberFormatter: numberFormatter, repository: feedRepository)
    }
}

extension Dependencies {
    static func make() -> Dependencies {
        let httpClient = GitClient()
        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("users.json")
        let localStorage = FileLocalStorage(fileURL: fileURL)
        return Dependencies(httpClient: httpClient, localStorage: localStorage)
    }
}
