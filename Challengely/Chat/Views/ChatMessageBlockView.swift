//
//  MessageBlockView.swift
//  Challengely
//
//  Created by Yash Lalit on 01/08/25.
//

import SwiftUI

struct ChatMessageBlockView: View {
    
    let block: MessageBlock
    
    @State var animate = false
    
    var body: some View {
        HStack {
            if block.sender == .ai {
                avatarView(for: .ai)
            }

            VStack(alignment: .leading) {
                ForEach(block.messages, id: \.id) { message in
                    switch message.type {
                    case .text(let text):
                        ChatMessageTextView(text: text, sender: block.sender)
                            
                            .transition(.move(edge: .leading).combined(with: .opacity))

                    case .textSub(let streamer):
                        ChatMessageStreamView(streamer: streamer)
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                }
            }
            if block.sender == .user {
                avatarView(for: .user)
            }
        }
        .frame(maxWidth: .infinity, alignment: block.sender == .ai ? .leading : .trailing)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .opacity(animate ? 1 : 0)
        .offset(y: animate ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animate = true
            }
        }


    }
}

extension ChatMessageBlockView {
    @ViewBuilder
    func avatarView(for sender: Sender) -> some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: sender == .ai ? [.blue, .purple] : [.green, .blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 40, height: 40)
            .overlay {
                Image(systemName: sender == .ai ? "sparkles" : "person.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
    }

}

#Preview {
    VStack(spacing: 20) {
      ChatMessageBlockView(
            block: MessageBlock(
                sender: .ai,
                messages: [.init(type: .text("Hello! How can I help you with today's challenge?"))]
            )
        )
        
       ChatMessageBlockView(
            block: MessageBlock(
                sender: .user,
                messages: [.init(type: .text("What's today's challenge?"))] 
            )
        )
    }
    .padding()
}
