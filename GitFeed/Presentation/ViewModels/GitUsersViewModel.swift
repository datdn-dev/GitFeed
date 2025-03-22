//
//  GitUsersViewModel.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

@MainActor
class GitUsersViewModel: ObservableObject {
    private let paging: UsersPaging
    private var error: Error?
    
    @Published var users: [GitUser] = []
    @Published var isLoading = false
    @Published var isLoadMore = false
    @Published var showError = false
    
    init(paging: UsersPaging) {
        self.paging = paging
    }
    
    func fetchUsers() async {
        resetState()
        setLoadingState(true)
        await excute()
        setLoadingState(false)
    }
    
    func fetchMoreUsers(from user: GitUser) async {
        guard shouldLoadMore(from: user) else { return }
        setLoadingMoreState(true)
        await excute()
        setLoadingMoreState(false)
    }
    
    private func excute() async {
        do {
            let users = try await paging.fetchNextUsers()
            addUsers(users)
        } catch {
            setErrorState(error)
        }
    }
}

extension GitUsersViewModel {
    private var shouldReloadOnAppear: Bool {
        return !isLoading && users.isEmpty
    }
    
    private func shouldLoadMore(from user: GitUser) -> Bool {
        return users.last == user && paging.avaiableUsers && (!isLoadMore && !isLoading)
    }
    
    private func resetState() {
        isLoadMore = false
        isLoading = false
        showError = false
        error = nil
    }
    
    private func setLoadingState(_ state: Bool) {
        isLoading = state
    }
    
    private func setLoadingMoreState(_ state: Bool) {
        isLoadMore = state
    }
    
    private func setErrorState(_ error: Error) {
        self.error = error
        self.showError = true
    }
    
    private func addUsers(_ users: [GitUser]) {
        self.users += users
    }
}

/// MARK: Presentation
extension GitUsersViewModel {
    var errorTitle: String {
        return error?.localizedDescription ?? ""
    }
}

extension GitUsersViewModel: LoadableViewModel {
    private var errorOnFirstLoad: Bool {
        return error != nil && users.isEmpty
    }
    
    var errorMessage: String? {
        guard errorOnFirstLoad else { return nil }
        return .fetchingErrorMessage
    }
    
    func fetchOnAppear() async {
        guard shouldReloadOnAppear else { return }
        await fetchUsers()
    }
}
