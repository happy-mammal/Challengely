//
//  MotivationalIcon.swift
//  Challengely
//
//  Created by Yash Lalit on 03/08/25.
//

import SwiftUI
struct MotivationalIcon: View {
    let icon: String
    let color: Color
    let xOffset: CGFloat
    let yOffset: CGFloat
    let delay: Double
    let trigger: Bool

    @State private var appear = false

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 30))
            .foregroundColor(color)
            .opacity(appear ? 1 : 0)
            .scaleEffect(appear ? 1 : 0.3)
            .offset(x: appear ? xOffset : 0, y: appear ? yOffset : 0)
            .onChange(of: trigger) { _, newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        withAnimation(.easeOut(duration: 0.5)) {
                            appear = true
                        }
                    }
                }
            }
    }
}
