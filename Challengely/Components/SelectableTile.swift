//
//  InterestCard.swift
//  Challengely
//
//  Created by Yash Lalit on 30/07/25.
//

import SwiftUI
import UIKit

struct SelectableTile: View {
    let isSelected: Bool
    let icon: String
    let title: String
    let color: Color
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color : Color(.systemGray5))
                        .frame(width: 60, height: 60)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(isSelected ? .white : .primary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .primary : .secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? color.opacity(0.1) : Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? color : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .shadow(color: isSelected ? color.opacity(0.3) : Color.black.opacity(0.05), radius: isSelected ? 8 : 4, x: 0, y: isSelected ? 4 : 2)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    @Previewable @State var isSelected = false
    HStack(spacing: 20) {
        SelectableTile(isSelected: isSelected, icon: "dumbbell", title: "Fitness", color: .blue, onTap: { isSelected.toggle() })
        SelectableTile(isSelected: false, icon: "dumbbell", title: "Fitness", color: .blue, onTap: {})
    }
    .frame(height: 200)
    .padding()
}
