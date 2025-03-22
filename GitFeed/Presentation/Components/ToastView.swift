//
//  ToastView.swift
//  GitFeed
//
//  Created by Dat Doan on 22/3/25.
//

import SwiftUI

struct ToastView: View {
    let message: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(UIColor.systemGray))
                    .shadow(radius: 5)
            )
            .opacity(colorScheme == .dark ? 0.9 : 1.0)
            .transition(.opacity)
    }
}
