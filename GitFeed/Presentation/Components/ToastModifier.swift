//
//  ToastModifier.swift
//  GitFeed
//
//  Created by Dat on 20/03/2025.
//

import SwiftUI

/// A modifier that displays a temporary toast message.
struct ToastModifier: ViewModifier {
    /// Controls whether the toast is visible.
    @Binding var isPresented: Bool
    
    /// The message to display in the toast.
    let message: String
    
    /// The duration the toast remains visible.
    let duration: TimeInterval
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                VStack {
                    Spacer()
                    ToastView(message: message)
                        .padding(.bottom, 30)
                        .onAppear {
                            dismissAfter()
                        }
                }
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
    
    /// Dismisses the toast after the specified duration.
    private func dismissAfter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                isPresented = false
            }
        }
    }
}


