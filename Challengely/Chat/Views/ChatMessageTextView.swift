//
//  TextMessageView.swift
//  Challengely
//
//  Created by Yash Lalit on 01/08/25.
//

import SwiftUI

struct ChatMessageTextView: View {
    let text: String
    let sender: Sender
    
    var body: some View {
        Text(text)
            .font(.system(size: 16))
            .padding(12)
            .foregroundColor(sender == .user ? .white : .primary)
            .background(sender == .user ? Color.blue : Color(.systemGray5))
            .cornerRadius(12)
           
    }
}

#Preview {
    @Previewable @State var isVisible = false
    VStack {
        if isVisible {
            ChatMessageTextView(text: "Hello man", sender: .ai)
                
        }
        Button("Toggle") {
            withAnimation {
                isVisible.toggle()
            }
        }
    }
    
}
