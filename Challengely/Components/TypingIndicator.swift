//
//  TypingIndicator.swift
//  Challengely
//
//  Created by Yash Lalit on 03/08/25.
//

import SwiftUI

struct TypingIndicator: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Color(.systemGray3))
                    .frame(width: 8, height: 8)
                    .scaleEffect(1.0 + animationOffset)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: animationOffset
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemGray6))
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            animationOffset = 0.3
        }
    }
}

#Preview {
    TypingIndicator()
}
