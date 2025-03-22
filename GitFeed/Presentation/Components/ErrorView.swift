//
//  ErrorView.swift
//  GitFeed
//
//  Created by Dat on 21/03/2025.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image.fetchingError
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)

            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal, 20)

            Button(action: onRetry) {
                Text(verbatim: .retry)
                    .font(.headline)
                    .padding()
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Error", onRetry: {})
    }
}
