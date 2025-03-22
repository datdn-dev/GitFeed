//
//  GitUserDetailView.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import SwiftUI

struct GitUserDetailView: View {
    @StateObject var viewModel: GitUserDetailViewModel
    
    var body: some View {
        ZStack {
            LoadingErrorView(viewModel: viewModel)
            mainContent
        }
        .onAppear {
            Task { await viewModel.fetchOnAppear() }
        }
        .navigationTitle(String.userDetailNavTitle)
    }
    
    @ViewBuilder
    private var mainContent: some View {
        if viewModel.userDetail != nil {
            ScrollView {
                VStack(spacing: 20) {
                    userCard
                    socialInfo
                    blogInfo
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    private var userCard: some View {
        UserCardView(avatarURL: viewModel.avatarURL, title: viewModel.name) {
            HStack {
                Image.location
                Text(viewModel.location)
            }
        }
    }
    
    @ViewBuilder
    private var socialInfo: some View {
        HStack {
            SocialIndicatorView(model: viewModel.followerViewModel)
            Spacer(minLength: 60)
            SocialIndicatorView(model: viewModel.followingViewModel)
        }
        .fixedSize()
    }
    
    private var blogInfo: some View {
        VStack(alignment: .leading) {
            Text(verbatim: .blog).font(.title).bold().frame(maxWidth: .infinity, alignment: .leading)
            Text(viewModel.blogURL).foregroundColor(.secondary)
        }
    }
}


