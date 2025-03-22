//
//  GitUsersViewModel.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import Foundation

/// `GitUsersViewModel` is responsible for managing the state and logic of fetching users.
/// It handles data fetching, error management, and loading states.
@MainActor
class GitUsersViewModel: ObservableObject {
    /// Paging
    private let paging: UsersPaging
    
    /// Error when loading first page users or load more.
    private var error: Error?
    
    /// Stores the list of fetched users.
    @Published var users: [GitUser] = []
    
    /// Indicates whether the initial data loading is in progress.
    @Published var isLoading = false
    
    /// Indicates whether more users are being loaded (pagination).
    @Published var isLoadMore = false
    
    /// Controls the visibility of an error toast message.
    @Published var showError = false
    
    /// Initializes the ViewModel with a `UsersPaging` instance for pagination.
    /// - Parameter paging: The object responsible for fetching paginated user data.
    init(paging: UsersPaging) {
        self.paging = paging
    }
    
    /// Fetches the initial list of users.
    /// This method resets the current state and performs a fresh data fetch.
    func fetchUsers() async {
        resetState()
        setLoadingState(true)
        await excute()
        setLoadingState(false)
    }
    
    /// Fetches additional users when the user reaches the end of the list.
    /// - Parameter user: The last visible user, used to determine whether more data should be loaded.
    func fetchMoreUsers(from user: GitUser) async {
        guard shouldLoadMore(from: user) else { return }
        setLoadingMoreState(true)
        await excute()
        setLoadingMoreState(false)
    }
    
    /// Executes the data fetching process and updates the state accordingly.
    private func excute() async {
        do {
            let users = try await paging.fetchNextUsers()
            addUsers(users)
        } catch {
            setErrorState(error)
        }
    }
}

// MARK: - Helper Methods
extension GitUsersViewModel {
    /// Determines whether the data should be reloaded when the view appears.
    private var shouldReloadOnAppear: Bool {
        return !isLoading && users.isEmpty
    }
    
    /// Determines whether more data should be loaded based on the current state.
    /// - Parameter user: The last visible user in the list.
    private func shouldLoadMore(from user: GitUser) -> Bool {
        return users.last == user && paging.avaiableUsers && (!isLoadMore && !isLoading)
    }
    
    /// Resets the ViewModel's state before fetching new data.
    private func resetState() {
        isLoadMore = false
        isLoading = false
        showError = false
        error = nil
    }
    
    /// Updates the loading state for the initial fetch.
    /// - Parameter state: A boolean indicating whether loading is in progress.
    private func setLoadingState(_ state: Bool) {
        isLoading = state
    }
    
    /// Updates the loading state for pagination (loading more users).
    /// - Parameter state: A boolean indicating whether additional data is being loaded.
    private func setLoadingMoreState(_ state: Bool) {
        isLoadMore = state
    }
    
    /// Handles error state when data fetching fails.
    /// - Parameter error: The error encountered during data fetching.
    private func setErrorState(_ error: Error) {
        self.error = error
        self.showError = true
    }
    
    /// Appends new users to the existing list.
    /// - Parameter users: The list of users fetched from the API.
    private func addUsers(_ users: [GitUser]) {
        self.users += users
    }
}

// MARK: Presentation
extension GitUsersViewModel {
    /// Returns a user-friendly error message.
    var errorTitle: String {
        return error?.localizedDescription ?? ""
    }
}

// MARK: - LoadableViewModel
extension GitUsersViewModel: LoadableViewModel {
    /// Determines whether an error occurred on the first data load.
    private var errorOnFirstLoad: Bool {
        return error != nil && users.isEmpty
    }
    
    /// Returns the error message if the initial data load fails.
    var errorMessage: String? {
        guard errorOnFirstLoad else { return nil }
        return .fetchingErrorMessage
    }
    
    /// Fetches data when the view appears, if needed.
    func fetchOnAppear() async {
        guard shouldReloadOnAppear else { return }
        await fetchUsers()
    }
}
