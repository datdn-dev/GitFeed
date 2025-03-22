//
//  AppCoordinatorView.swift
//  GitFeed
//
//  Created by Dat on 21/03/2025.
//

import SwiftUI

/// `AppCoordinatorView` is the main container for managing app navigation.
/// It uses `NavigationStack` and observes `AppCoordinator` to dynamically update the navigation path.
struct AppCoordinatorView: View {
    /// The app coordinator responsible for handling navigation.
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.navPath) {
            coordinator.build(.list)
                .navigationDestination(for: Screen.self) { coordinator.build($0) }
        }
    }
}
