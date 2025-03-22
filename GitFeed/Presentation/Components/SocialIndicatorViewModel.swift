//
//  SocialIndicatorViewModel.swift
//  GitFeed
//
//  Created by Dat on 21/03/2025.
//

import Foundation
import SwiftUI

struct SocialIndicatorViewModel: SocialIndicatorModelType {
    var image: Image
    var background: Color
    var title: String
    var subtitle: String
    
    init(image: Image, background: Color, title: String, subtitle: String) {
        self.image = image
        self.background = background
        self.title = title
        self.subtitle = subtitle
    }
}
