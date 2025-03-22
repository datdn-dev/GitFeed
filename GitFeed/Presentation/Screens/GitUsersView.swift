//
//  GitUsersView.swift
//  GitFeed
//
//  Created by Dat on 18/03/2025.
//

import SwiftUI

struct GitUsersView: View {
    @StateObject var viewModel: GitUsersViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            if viewModel.isLoading || viewModel.errorMessage != nil {
                LoadingErrorView(viewModel: viewModel)
            } else {
                listUsersView
            }
        }
        .navigationTitle(String.usersNavTitle)
        .onAppear {
            Task { await viewModel.fetchOnAppear() }
        }
    }
    
    var listUsersView: some View {
        List {
            ForEach(viewModel.users) { user in
                UserCardView(avatarURL: user.avatarURL, title: user.login.capitalized) {
                    Text(user.htmlURL.description).underline().foregroundColor(.blue)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .onTapGesture {
                    coordinator.push(.userDetail(user))
                }
                .onAppear {
                    Task { await viewModel.fetchMoreUsers(from: user) }
                }
            }
            if viewModel.isLoadMore {
                loadMoreProgress
            }
        }
        .listStyle(.plain)
        .toast(isPresented: $viewModel.showError, title: viewModel.errorTitle)
    }
    
    var loadMoreProgress: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .listRowSeparator(.hidden)
    }
}
