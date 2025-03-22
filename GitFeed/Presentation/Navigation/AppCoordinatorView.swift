//
//  AppCoordinatorView.swift
//  GitFeed
//
//  Created by Dat on 21/03/2025.
//

import SwiftUI

struct AppCoordinatorView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.navPath) {
            coordinator.build(.list)
                .navigationDestination(for: Screen.self) { coordinator.build($0) }
        }
    }
}
