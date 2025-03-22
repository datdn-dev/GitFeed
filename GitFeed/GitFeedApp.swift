//
//  GitFeedApp.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import SwiftUI

@main
struct GitFeedApp: App {
    let coordinator = AppCoordinator(dependencies: Dependencies.make())
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: coordinator)
                .environmentObject(coordinator)
        }
    }
}
