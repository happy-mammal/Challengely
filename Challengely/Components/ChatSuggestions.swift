//
//  ChatSuggestions.swift
//  Challengely
//
//  Created by Yash Lalit on 03/08/25.
//

import SwiftUI

struct SuggestionPills: View {
    let suggestions: [String]
    let onSuggestionTapped: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button(action: {
                        onSuggestionTapped(suggestion)
                    }) {
                        Text(suggestion)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.blue.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SuggestionPills(
        suggestions: ["Thanks", "Bye", "Hola"],
        onSuggestionTapped: { _ in }
    )
}
