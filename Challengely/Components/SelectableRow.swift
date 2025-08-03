//
//  SelectableRow.swift
//  Challengely
//
//  Created by Yash Lalit on 30/07/25.
//

import SwiftUI
import UIKit

struct SelectableRow: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let animation: Namespace.ID
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? difficulty.color : Color(.systemGray5))
                        .frame(width: 50, height: 50)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
                    
                    Image(systemName: difficulty.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .white : .primary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(difficulty.rawValue.capitalized)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isSelected ? .primary : .primary)
                    
                    Text(difficulty.description)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(difficulty.color)
                        .matchedGeometryEffect(id: "checkmark", in: animation)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? difficulty.color.opacity(0.1) : Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? difficulty.color : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .shadow(color: isSelected ? difficulty.color.opacity(0.3) : Color.black.opacity(0.05), radius: isSelected ? 8 : 4, x: 0, y: isSelected ? 4 : 2)
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
    
    @Previewable @Namespace var animation
    @Previewable @State var index = 0
    VStack(spacing: 16) {
        SelectableRow(
            difficulty: .easy,
            isSelected: index == 0,
            animation: animation,
            onTap: {index = 0 }
        )
        
        SelectableRow(
            difficulty: .medium,
            isSelected: index == 1,
            animation: animation,
            onTap: {index = 1}
        )
        
        SelectableRow(
            difficulty: .hard,
            isSelected: index == 2,
            animation: animation,
            onTap: {index = 2}
        )
        
    }
    .padding()
}
