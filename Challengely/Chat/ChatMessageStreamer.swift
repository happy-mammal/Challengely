//
//  ChatMessageStreamer.swift
//  Challengely
//
//  Created by Yash Lalit on 02/08/25.
//

import Foundation

class ChatMessageStreamer: ObservableObject {
    
    @Published var result: String = ""
    
    private let completion: ()->Void
    
    private let chatService: ChatServiceProtocol
        
    private var streamingTask: Task<Void, Never>? = nil
    
    init(conversationId: UUID, completion: @escaping ()->Void) {
        self.chatService = ChatService.shared
        self.completion = completion
        stream(for: conversationId)
    }
    
    private func stream(for id: UUID)  {
        guard let response = chatService.getMessage(id) else { return }
        
        if let streamingTask {
            streamingTask.cancel()
            self.streamingTask = nil
        }
        
        streamingTask = Task {
            for character in response.reply {
                await MainActor.run {
                    result.append(character)
                }
                try? await Task.sleep(nanoseconds: 50_000_000)
            }
            
            streamingTask?.cancel()
            
            streamingTask = nil
            
            completion()
        }
    }

}
