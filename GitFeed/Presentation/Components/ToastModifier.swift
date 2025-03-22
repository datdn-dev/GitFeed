//
//  ToastModifier.swift
//  GitFeed
//
//  Created by Dat on 20/03/2025.
//

import SwiftUI

struct ToastView: View {
    enum Position {
        case top, bottom
    }
    
    let image: Image?
    let title: String
    let subtitle: String?
    let position: Position
    let onClose: () -> Void
    let showCloseButton: Bool
    
    var body: some View {
        VStack {
            if position == .top { Spacer() }
            
            HStack(spacing: 12) {
                if let image = image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                if showCloseButton {
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            
            if position == .bottom { Spacer() }
        }
        .transition(.move(edge: position == .top ? .top : .bottom).combined(with: .opacity))
    }
}


struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let image: Image?
    let title: String
    let subtitle: String?
    let position: ToastView.Position
    let duration: Double
    let showCloseButton: Bool
    
    @State private var opacity: Double = 0
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                ToastView(
                    image: image,
                    title: title,
                    subtitle: subtitle,
                    position: position,
                    onClose: {
                        dismissToast()
                    },
                    showCloseButton: showCloseButton
                )
                .padding(position == .top ? .top : .bottom, 50)
                .opacity(opacity)
                .offset(y: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = position == .top ? min(gesture.translation.height, 0) : max(gesture.translation.height, 0)
                        }
                        .onEnded { _ in
                            if abs(offset) > 50 {
                                dismissToast()
                            } else {
                                withAnimation {
                                    offset = 0
                                }
                            }
                        }
                )
                .onAppear {
                    withAnimation(.easeIn(duration: 0.3)) {
                        opacity = 1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        if !showCloseButton {
                            dismissToast()
                        }
                    }
                }
            }
        }
    }
    
    private func dismissToast() {
        withAnimation(.easeOut(duration: 0.3)) {
            opacity = 0
            offset = position == .top ? -100 : 100
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
            offset = 0
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, image: Image? = nil, title: String, subtitle: String? = nil, position: ToastView.Position = .bottom, duration: Double = 2.5, showCloseButton: Bool = false) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, image: image, title: title, subtitle: subtitle, position: position, duration: duration, showCloseButton: showCloseButton))
    }
}

