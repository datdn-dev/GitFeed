//
//  AppCoordinator.swift
//  GitFeed
//
//  Created by Dat on 21/03/2025.
//

import Foundation
import SwiftUI

/// `AppCoordinator` is responsible for managing navigation within the application.
/// It uses `NavigationPath` to support data-driven navigation.
class AppCoordinator: ObservableObject {
    /// Dependency container.
    private var dependencies: Dependency
    
    /// Stores the current navigation path.
    @Published var navPath = NavigationPath()
    
    /// Initializes `AppCoordinator` with the required dependencies.
    /// - Parameter dependencies: The `Dependency` object used to create ViewModels and other services.
    init(dependencies: Dependency) {
        self.dependencies = dependencies
    }
    
    /// Builds the corresponding View for a given `Screen`.
    /// - Parameter screen: The screen to display.
    /// - Returns: A  View associated with the screen.
    @MainActor @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .list:
            buildUsersListView()
        case .userDetail(let user):
            buildUserDetailView(for: user)
        }
    }
    
    /// Navigates to a new screen.
    /// - Parameter screen: The screen to navigate to.
    func push(_ screen: Screen) {
        navPath.append(screen)
    }
    
    /// Navigates back to the previous screen.
    func pop() {
        navPath.removeLast()
    }
    
    /// Navigates back to the root screen.
    func popToRoot() {
        navPath.removeLast(navPath.count)
    }
}

extension AppCoordinator {
    /// Creates and returns `GitUsersView` with a `GitUsersViewModel` from `dependencies`.
    @MainActor
    private func buildUsersListView() -> some View {
        let vModel = dependencies.makeUsersViewModel()
        return GitUsersView(viewModel: vModel)
    }
    
    /// Creates and returns `GitUserDetailView` with a `GitUserDetailViewModel` from `dependencies`.
    /// - Parameter user: The `GitUser` object to display details for.
    @MainActor
    private func buildUserDetailView(for user: GitUser) -> some View {
        let vModel = dependencies.makeDetailViewModel(with: user)
        return GitUserDetailView(viewModel: vModel)
    }
}
