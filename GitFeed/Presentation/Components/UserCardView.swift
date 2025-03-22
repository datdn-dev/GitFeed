//
//  UserCardView.swift
//  GitFeed
//
//  Created by Dat on 19/03/2025.
//

import SwiftUI
import NukeUI

struct UserCardView<C: View>: View {
    private let avatarURL: URL?
    private let title: String
    private let subtitle: () -> C
    
    init(avatarURL: URL?, title: String, @ViewBuilder subtitle: @escaping () -> C) {
        self.avatarURL = avatarURL
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            LazyImage(source: avatarURL) { avatarImage(from: $0) }
            .frame(width: 80, height: 80)
            .cornerRadius(10)
            
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

extension UserCardView {
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
    
    private var avatarBackground: some View {
        Rectangle().fill(Color.secondary)
    }
}

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserCardView(avatarURL: URL(string: "https://avatars.githubusercontent.com/u/1?v=4"), title: "mojombo") {
            Text("https://github.com/mojombo").foregroundColor(.blue).underline()
        }
    }
}
