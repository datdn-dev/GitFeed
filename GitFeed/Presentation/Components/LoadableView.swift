//
//  LoadableView.swift
//  GitFeed
//
//  Created by Dat on 20/03/2025.
//

import SwiftUI

protocol LoadableViewModel: ObservableObject {
    var isLoading: Bool { get set }
    var errorMessage: String? { get }
    func fetchOnAppear() async
}

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
    
    private var progress: some View {
        ProgressView()
    }
    
    @ViewBuilder
    private var error: some View {
        if let errorMessage = viewModel.errorMessage {
            ErrorView(message: errorMessage, onRetry: refresh)
        }
    }
    
    private func refresh() {
        Task { await viewModel.fetchOnAppear() }
    }
}
