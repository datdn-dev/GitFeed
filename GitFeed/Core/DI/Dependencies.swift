//
//  Dependencies.swift
//  GitFeed
//
//  Created by Dat on 21/03/2025.
//

import Foundation

protocol Dependency {
    /// Creates an instance of `UsersPaging` for handling paginated user data.
    func makeUsersPaging() -> UsersPaging
    
    /// Creates an instance of `GitUsersViewModel` for managing the users list view.
    func makeUsersViewModel() -> GitUsersViewModel
    
    /// Creates an instance of `GitUserDetailViewModel` for managing user detail view.
    /// - Parameter user: The `GitUser` object containing user information.
    /// - Returns: A new instance of `GitUserDetailViewModel`.
    func makeDetailViewModel(with user: GitUser) -> GitUserDetailViewModel
}

struct Dependencies: Dependency {
    private let httpClient: HTTPClient
    private let localStorage: LocalStorage
    private let pageSize: Int
    
    /// Initializes the `Dependencies` container.
    /// - Parameters:
    ///   - httpClient: An instance of `HTTPClient` for handling network requests.
    ///   - localStorage: An instance of `LocalStorage` for caching data locally.
    ///   - pageSize: The number of users per page (default is 20).
    init(httpClient: HTTPClient, localStorage: LocalStorage, pageSize: Int = 20) {
        self.httpClient = httpClient
        self.localStorage = localStorage
        self.pageSize = pageSize
    }
    
    /// Provides a `GitFeedRepository` instance.
    var feedRepository: GitFeedRepository {
        return GitFeedRepoImpl(httpClient: httpClient, localStorage: localStorage)
    }
    
    /// Provides a number formatter for social metrics
    var numberFormatter: NumberFormating {
        return SocialNumberFormater()
    }
    
    /// Creates a `UsersPaging` instance for managing paginated user fetching.
    /// - Returns: A new instance of `UsersPaging`.
    func makeUsersPaging() -> UsersPaging {
        return GitUsersPaging(pageSize: pageSize, repository: feedRepository)
    }
    
    /// Creates a `GitUsersViewModel` instance for managing user list UI state.
    /// - Returns: A new instance of `GitUsersViewModel`.
    @MainActor
    func makeUsersViewModel() -> GitUsersViewModel {
        return GitUsersViewModel(paging: makeUsersPaging())
    }
    
    /// Creates a `GitUserDetailViewModel` instance for handling user details.
    /// - Parameter user: The `GitUser` object to fetch details for.
    /// - Returns: A new instance of `GitUserDetailViewModel`.
    @MainActor
    func makeDetailViewModel(with user: GitUser) -> GitUserDetailViewModel {
        return GitUserDetailViewModel(username: user.login, numberFormatter: numberFormatter, repository: feedRepository)
    }
}

extension Dependencies {
    /// Creates a default `Dependencies` instance using `GitClient` and `FileLocalStorage`.
    /// - Returns: A new instance of `Dependencies` configured with default implementations.
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
