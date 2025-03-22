//
//  GitUserDetailViewModel.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation
import SwiftUI

@MainActor
class GitUserDetailViewModel: ObservableObject {
    private let numberFormatter: NumberFormating
    private let repository: GitFeedRepository
    private let username: String
    private var error: Error?
    
    @Published var userDetail: GitUserDetail?
    @Published var isLoading = false
    
    init(username: String, numberFormatter: NumberFormating, repository: GitFeedRepository) {
        self.username = username
        self.repository = repository
        self.numberFormatter = numberFormatter
    }
    
    func fetchUserDetail() async {
        resetState()
        updateLoadingState(true)
        await excute()
        updateLoadingState(false)
    }
    
    private func excute() async {
        do {
            let userDetail = try await repository.fetchUserDetail(username: username)
            updateUserDetail(userDetail)
        } catch {
            updateErrorState(error)
        }
    }
    
    func updateUserDetail(_ userDetail: GitUserDetail) {
        self.userDetail = userDetail
    }
    
    func updateLoadingState(_ state: Bool) {
        isLoading = state
    }
    
    func updateErrorState(_ error: Error) {
        self.error = error
    }
    
    private var shouldReloadOnAppear: Bool {
        return !isLoading && userDetail == nil
    }
    
    private func resetState() {
        error = nil
        isLoading = false
    }
}

/// MARK: - Presentation
extension GitUserDetailViewModel {
    private var indicatorBackgroundColor: Color {
        return .indicatorBackgroundColor
    }
    
    private var dashText: String {
        return "--"
    }
    
    var followerViewModel: SocialIndicatorModelType {
        let noFollowersText = numberFormatter.format(userDetail?.followers ?? 0)
        return SocialIndicatorViewModel(image: .follower,
                                        background: indicatorBackgroundColor,
                                        title: noFollowersText,
                                        subtitle: .follower)
    }
    
    var followingViewModel: SocialIndicatorModelType {
        let noFollowingText = numberFormatter.format(userDetail?.following ?? 0)
        return SocialIndicatorViewModel(image: .following,
                                        background: indicatorBackgroundColor,
                                        title: noFollowingText,
                                        subtitle: .following)
    }
    
    var blogURL: String {
        return userDetail?.htmlURL?.description ?? dashText
    }
    
    var avatarURL: URL? {
        return userDetail?.avatarURL
    }
    
    var name: String {
        return userDetail?.login.capitalized ?? dashText
    }
    
    var location: String {
        return userDetail?.location ?? dashText
    }
}

extension GitUserDetailViewModel: LoadableViewModel {
    var errorMessage: String? {
        guard error != nil else { return nil }
        return .fetchingErrorMessage
    }
    
    func fetchOnAppear() async {
        guard shouldReloadOnAppear else { return }
        await fetchUserDetail()
    }
}
