//
//  SocialIndicatorViewModel.swift
//  GitFeed
//
//  Created by Dat on 21/03/2025.
//

import Foundation
import SwiftUI

/// ViewModel for representing a social indicator (followers, following, etc.).
struct SocialIndicatorViewModel: SocialIndicatorModelType {
    /// Icon representing the social indicator.
    var image: Image
    
    /// Background color of the indicator.
    var background: Color
    
    /// Displayed title (e.g., follower count).
    var title: String
    
    /// Description (e.g., "Followers" or "Following").
    var subtitle: String
    
    init(image: Image, background: Color, title: String, subtitle: String) {
        self.image = image
        self.background = background
        self.title = title
        self.subtitle = subtitle
    }
}
