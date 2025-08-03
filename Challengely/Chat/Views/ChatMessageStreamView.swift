//
//  StreamMessageView.swift
//  Challengely
//
//  Created by Yash Lalit on 01/08/25.
//

import SwiftUI

struct ChatMessageStreamView: View {
    
    @StateObject var streamer: ChatMessageStreamer
    
    var body: some View {
        
        Text(streamer.result)
            .font(.system(size: 16))
            .padding(12)
            .foregroundColor(.primary)
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .animation(.none, value: streamer.result)
        
    }
    
}

#Preview {
    
    
}

