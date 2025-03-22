//
//  View+Extensions.swift
//  GitFeed
//
//  Created by Dat Doan on 22/3/25.
//

import Foundation
import SwiftUI

extension View {
    func toast(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 2.0) -> some View {
        modifier(ToastModifier(isPresented: isPresented, message: message, duration: duration))
    }
}
