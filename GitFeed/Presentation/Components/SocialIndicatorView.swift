//
//  SocialIndicatorView.swift
//  GitFeed
//
//  Created by Dat on 19/03/2025.
//

import SwiftUI

/// A protocol defining the data model for a social indicator (e.g., followers, following).
protocol SocialIndicatorModelType {
    /// The icon representing the indicator.
    var image: Image { get }
    
    /// The background color of the indicator icon.
    var background: Color { get }
    
    /// The main title (e.g., number of followers).
    var title: String { get }
    
    /// The subtitle describing the indicator.
    var subtitle: String { get }
}

/// A reusable view that displays a social indicator with an icon, title, and subtitle.
struct SocialIndicatorView: View {
    let model: SocialIndicatorModelType
    
    var body: some View {
        VStack {
            ZStack {
                Circle().fill(model.background)
                model.image.imageScale(.large)
            }
            .frame(width: 70)
            Text(model.title).font(.headline)
            Text(model.subtitle)
        }
    }
}
