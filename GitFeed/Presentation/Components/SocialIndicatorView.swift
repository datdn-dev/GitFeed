//
//  SocialIndicatorView.swift
//  GitFeed
//
//  Created by Dat on 19/03/2025.
//

import SwiftUI

protocol SocialIndicatorModelType {
    var image: Image { get }
    var background: Color { get }
    var title: String { get }
    var subtitle: String { get }
}

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
