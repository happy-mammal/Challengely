//
//  ChatMessagingView.swift
//  Challengely
//
//  Created by Yash Lalit on 01/08/25.
//

import SwiftUI

struct ChatMessagingView: View {
    var messages: [MessageBlock]
    var showLoading: Bool
    var suggestions: [String]
    var onSuggestionTapped: (String) -> Void
    
    @State private var scrollToBottom = false
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(messages, id: \.id) { message in
                        ChatMessageBlockView(block: message)
                            .id(message.id)
                    }
                    
                    // Suggestions
                    if !suggestions.isEmpty && !messages.isEmpty {
                        SuggestionPills(
                            suggestions: suggestions,
                            onSuggestionTapped: onSuggestionTapped
                        )
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    // Loading indicator
                    if showLoading {
                        TypingIndicator()
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    Color.clear.frame(height: 1).id("bottom")
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .onChange(of: messages.count) { _, _ in
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
            .onChange(of: showLoading) { _, _ in
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
            .onAppear {
                proxy.scrollTo("bottom", anchor: .bottom)
            }
        }
    }
}


#Preview {
    ChatMessagingView(
        messages: [
            MessageBlock(sender: .ai, messages: [.init(type: .text("Hello! How can I help you today?"))]),
            MessageBlock(sender: .user, messages: [.init(type: .text("What's today's challenge?"))])
        ],
        showLoading: false,
        suggestions: ["I need motivation", "Give me tips"],
        onSuggestionTapped: { _ in }
    )
}
