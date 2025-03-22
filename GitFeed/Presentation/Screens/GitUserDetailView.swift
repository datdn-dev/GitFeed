//
//  GitUserDetailView.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import SwiftUI

struct GitUserDetailView: View {
    /// ViewModel
    @StateObject var viewModel: GitUserDetailViewModel
    
    var body: some View {
        ZStack {
            LoadingErrorView(viewModel: viewModel)
            if viewModel.userDetail != nil {
                mainContent
            }
        }
        .onAppear {
            Task { await viewModel.fetchOnAppear() }
        }
        .navigationTitle(String.userDetailNavTitle)
    }
    
    /// Main content when user data is available.
    @ViewBuilder
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                userCard
                socialInfo
                blogInfo
            }
            .padding()
        }
    }
    
    /// User profile card with avatar and location.
    @ViewBuilder
    private var userCard: some View {
        UserCardView(avatarURL: viewModel.avatarURL, title: viewModel.name) {
            HStack {
                Image.location
                Text(viewModel.location)
            }
        }
    }
    
    /// Follower and following count indicators.
    @ViewBuilder
    private var socialInfo: some View {
        HStack {
            SocialIndicatorView(model: viewModel.followerViewModel)
            Spacer(minLength: 60)
            SocialIndicatorView(model: viewModel.followingViewModel)
        }
        .fixedSize()
    }
    
    /// Blog information.
    private var blogInfo: some View {
        VStack(alignment: .leading) {
            Text(verbatim: .blog).font(.title).bold().frame(maxWidth: .infinity, alignment: .leading)
            Text(viewModel.blogURL).foregroundColor(.secondary)
        }
    }
}


