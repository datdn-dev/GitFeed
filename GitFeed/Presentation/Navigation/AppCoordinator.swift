//
//  AppCoordinator.swift
//  GitFeed
//
//  Created by Dat on 21/03/2025.
//

import Foundation
import SwiftUI

class AppCoordinator: ObservableObject {
    private var dependencies: Dependency
    @Published var navPath = NavigationPath()
    
    init(dependencies: Dependency) {
        self.dependencies = dependencies
    }
    
    @MainActor @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .list:
            buildUsersListView()
        case .userDetail(let user):
            buildUserDetailView(for: user)
        }
    }
    
    func push(_ screen: Screen) {
        navPath.append(screen)
    }
    
    func pop() {
        navPath.removeLast()
    }
    
    func popToRoot() {
        navPath.removeLast(navPath.count)
    }
}

extension AppCoordinator {
    @MainActor
    private func buildUsersListView() -> some View {
        let vModel = dependencies.makeUsersViewModel()
        return GitUsersView(viewModel: vModel)
    }
    
    @MainActor
    private func buildUserDetailView(for user: GitUser) -> some View {
        let vModel = dependencies.makeDetailViewModel(with: user)
        return GitUserDetailView(viewModel: vModel)
    }
}
