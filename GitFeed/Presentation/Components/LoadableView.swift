//
//  LoadableView.swift
//  GitFeed
//
//  Created by Dat on 20/03/2025.
//

import SwiftUI

/// A protocol defining a loadable view model that can handle loading states and errors.
protocol LoadableViewModel: ObservableObject {
    /// Indicates whether the view is currently loading.
    var isLoading: Bool { get set }
    
    /// Error message to display when an error occurs.
    var errorMessage: String? { get }
    
    /// Fetches data when the view appears.
    func fetchOnAppear() async
}

/// A reusable view that handles loading and error states for a `LoadableViewModel`.
struct LoadingErrorView<VM: LoadableViewModel>: View {
    @ObservedObject var viewModel: VM
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                progress
            } else if viewModel.errorMessage != nil {
                error
            }
        }
    }
    
    /// Displays a loading indicator when data is being fetched.
    private var progress: some View {
        ProgressView()
    }
    
    /// Displays an error message with a retry button when an error occurs.
    @ViewBuilder
    private var error: some View {
        if let errorMessage = viewModel.errorMessage {
            ErrorView(message: errorMessage, onRetry: refresh)
        }
    }
    
    /// Triggers a refresh when the user taps the retry button.
    private func refresh() {
        Task { await viewModel.fetchOnAppear() }
    }
}
