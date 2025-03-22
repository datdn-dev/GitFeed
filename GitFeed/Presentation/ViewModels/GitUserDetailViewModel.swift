//
//  GitUserDetailViewModel.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation
import SwiftUI

/// `GitUserDetailViewModel` is responsible for handling the user detail screen's data fetching,
/// formatting, and presentation logic. It interacts with the repository to retrieve user details
/// and formats the data appropriately for display.
@MainActor
class GitUserDetailViewModel: ObservableObject {
    /// Social metric number formatter.
    private let numberFormatter: NumberFormating
    
    /// Repository
    private let repository: GitFeedRepository
    
    /// Username of user to fetch details.
    private let username: String
    
    /// Any error when loading user details.
    private var error: Error?
    
    /// Stores the detailed information of the user.
    @Published var userDetail: GitUserDetail?
    
    /// Indicates whether the user detail is being fetched.
    @Published var isLoading = false
    
    /// Initializes the ViewModel with required dependencies.
    /// - Parameters:
    ///   - username: The username for fetching details.
    ///   - numberFormatter: A utility to format numerical data.
    ///   - repository: The repository responsible for fetching user details.
    init(username: String, numberFormatter: NumberFormating, repository: GitFeedRepository) {
        self.username = username
        self.repository = repository
        self.numberFormatter = numberFormatter
    }
    
    /// Fetches user details from the repository.
    /// It resets the state before making the request.
    func fetchUserDetail() async {
        resetState()
        updateLoadingState(true)
        await excute()
        updateLoadingState(false)
    }
    
    /// Executes the API request to fetch user details.
    private func excute() async {
        do {
            let userDetail = try await repository.fetchUserDetail(username: username)
            updateUserDetail(userDetail)
        } catch {
            updateErrorState(error)
        }
    }
    
    /// Updates the `userDetail` property with new data.
    /// - Parameter userDetail: The fetched `GitUserDetail` instance.
    func updateUserDetail(_ userDetail: GitUserDetail) {
        self.userDetail = userDetail
    }
    
    /// Updates the loading state.
    /// - Parameter state: A boolean indicating whether the ViewModel is loading data.
    func updateLoadingState(_ state: Bool) {
        isLoading = state
    }
    
    /// Updates the error state when a request fails.
    /// - Parameter error: The encountered error.
    func updateErrorState(_ error: Error) {
        self.error = error
    }
    
    /// Determines whether the user details should be reloaded when the view appears.
    private var shouldReloadOnAppear: Bool {
        return !isLoading && userDetail == nil
    }
    
    /// Resets the ViewModel's state before fetching data.
    private func resetState() {
        error = nil
        isLoading = false
    }
}

/// MARK: - Presentation
extension GitUserDetailViewModel {
    /// The background color for social indicators.
    private var indicatorBackgroundColor: Color {
        return .indicatorBackgroundColor
    }
    
    /// Default placeholder text for missing data.
    private var dashText: String {
        return "--"
    }
    
    /// ViewModel for displaying follower count.
    var followerViewModel: SocialIndicatorModelType {
        let noFollowersText = numberFormatter.format(userDetail?.followers ?? 0)
        return SocialIndicatorViewModel(image: .follower,
                                        background: indicatorBackgroundColor,
                                        title: noFollowersText,
                                        subtitle: .follower)
    }
    
    /// ViewModel for displaying following count.
    var followingViewModel: SocialIndicatorModelType {
        let noFollowingText = numberFormatter.format(userDetail?.following ?? 0)
        return SocialIndicatorViewModel(image: .following,
                                        background: indicatorBackgroundColor,
                                        title: noFollowingText,
                                        subtitle: .following)
    }
    
    /// Returns the user's blog URL as a string.
    var blogURL: String {
        return userDetail?.htmlURL?.description ?? dashText
    }
    
    /// Returns the user's avatar URL if available.
    var avatarURL: URL? {
        return userDetail?.avatarURL
    }
    
    /// Returns the user's capitalized username or placeholder text.
    var name: String {
        return userDetail?.login.capitalized ?? dashText
    }
    
    /// Returns the user's location or placeholder text.
    var location: String {
        return userDetail?.location ?? dashText
    }
}

// MARK: - LoadableViewModel
extension GitUserDetailViewModel: LoadableViewModel {
    /// Returns an error message if fetching user details fails.
    var errorMessage: String? {
        guard error != nil else { return nil }
        return .fetchingErrorMessage
    }
    
    /// Fetches user details when the view appears if necessary.
    func fetchOnAppear() async {
        guard shouldReloadOnAppear else { return }
        await fetchUserDetail()
    }
}
