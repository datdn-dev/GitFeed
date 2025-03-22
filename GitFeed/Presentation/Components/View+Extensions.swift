//
//  View+Extensions.swift
//  GitFeed
//
//  Created by Dat Doan on 22/3/25.
//

import Foundation
import SwiftUI

extension View {
    /// Displays a toast message with an optional duration.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to control the visibility of the toast.
    ///   - message: The message to display in the toast.
    ///   - duration: The duration for which the toast remains visible (default: 2.0 seconds).
    /// - Returns: A modified view with a toast overlay.
    func toast(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 2.0) -> some View {
        modifier(ToastModifier(isPresented: isPresented, message: message, duration: duration))
    }
}
