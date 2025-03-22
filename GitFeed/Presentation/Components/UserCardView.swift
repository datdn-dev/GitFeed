//
//  UserCardView.swift
//  GitFeed
//
//  Created by Dat on 19/03/2025.
//

import SwiftUI
import NukeUI

/// A reusable user card view that displays an avatar, title, and subtitle.
/// This view is used to present user details in a compact and visually appealing format.
struct UserCardView<C: View>: View {
    private let avatarURL: URL?
    private let title: String
    private let subtitle: () -> C
    
    /// Initializes the `UserCardView`.
    /// - Parameters:
    ///   - avatarURL: The URL of the user's avatar image.
    ///   - title: The title (typically the username).
    ///   - subtitle: A closure returning a custom view for the subtitle (e.g., additional user info).
    init(avatarURL: URL?, title: String, @ViewBuilder subtitle: @escaping () -> C) {
        self.avatarURL = avatarURL
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            /// Lazy loading avatar image with placeholder and error handling.
            LazyImage(source: avatarURL) { avatarImage(from: $0) }
            .frame(width: 80, height: 80)
            .cornerRadius(10)
            
            /// User information section.
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.headline)
                Divider()
                subtitle()
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10, y: 5)
    }
}

// MARK: - Helper methods
extension UserCardView {
    /// Handles the avatar image state, including loading, error, and display.
    /// - Parameter state: The current state of the lazy-loaded image.
    /// - Returns: A view displaying the avatar with appropriate error handling.
    @ViewBuilder
    private func avatarImage(from state: LazyImageState) -> some View {
        ZStack {
            avatarBackground
            if state.isLoading {
                ProgressView()
            } else if state.error != nil {
                Image.avatarError
                    .imageScale(.large)
                    .foregroundColor(.white)
            } else {
                state.image
            }
        }
    }
    
    /// Provides a placeholder background for the avatar.
    private var avatarBackground: some View {
        Rectangle().fill(Color.secondary)
    }
}

// MARK: - Preview
struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserCardView(avatarURL: URL(string: "https://avatars.githubusercontent.com/u/1?v=4"), title: "mojombo") {
            Text("https://github.com/mojombo").foregroundColor(.blue).underline()
        }
    }
}
