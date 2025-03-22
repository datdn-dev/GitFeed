//
//  ToastModifier.swift
//  GitFeed
//
//  Created by Dat on 20/03/2025.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
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
    
    private func dismissAfter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                isPresented = false
            }
        }
    }
}


