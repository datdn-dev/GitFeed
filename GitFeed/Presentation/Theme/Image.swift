//
//  Image.swift
//  GitFeed
//
//  Created by Dat on 22/03/2025.
//

import Foundation
import SwiftUI

extension Image {
    /// Icon representing followers.
    static let follower = Image(systemName: "person.2.fill")
    
    /// Icon representing following users.
    static let following = Image(systemName: "rosette")
    
    /// Placeholder avatar when an error occurs.
    static let avatarError = Image(systemName: "person.fill.questionmark")
    
    /// Icon representing a data fetching error.
    static let fetchingError = Image(systemName: "exclamationmark.triangle.fill")
    
    /// Icon for displaying location information.
    static let location = Image(systemName: "location")
}
