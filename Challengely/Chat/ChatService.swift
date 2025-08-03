//
//  ChatService.swift
//  Challengely
//
//  Created by Yash Lalit on 01/08/25.
//

import Foundation

final class ChatService: ChatServiceProtocol {
    
    private let maxCharacterLimit = 500
    private let minCharacterLimit = 3
    private let gibberishCharThreshold = 3
    private let gibberishLengthThreshold = 5
    private let alphanumericThreshold = 0.6
    private let chatStore: ChatStoreProtocol
    private var lastFetchedStartIndex: Int?
    
    static let shared = ChatService()
    
    private init() {
        self.chatStore = ChatStorage()
    }
    
    
    func getMessages(page: Int) ->  [Chat]? {
      
        guard page > 0 && page <= chatStore.totalPages else { return nil }
        
        let offset = (page - 1) * 10
        
        let lastIndex = chatStore.totalItems - offset - 1
        
        guard lastIndex >= 0 else {
            self.lastFetchedStartIndex = 0
            return nil
        }
        
        let firstIndex = lastIndex - 9 < 0 ? 0 : lastIndex - 9
        
        guard let lastFetchedStartIndex else {
            self.lastFetchedStartIndex = firstIndex
          
            return Array(chatStore.chats[firstIndex...lastIndex])
        }
        
        
        guard lastFetchedStartIndex > firstIndex else { return nil }
        
        self.lastFetchedStartIndex = firstIndex
        
        return Array(chatStore.chats[firstIndex...lastIndex])
        
    }
    
    func getMessage(_ id: UUID) -> Chat? {
        chatStore.chats.first{ $0.id == id }
    }

    func generate(for userInput: String) async -> ChatResponse {
        
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)

        guard validateGeneralText(trimmed), !isSpamMessage(trimmed) else {
           
            let conversation = Chat(
                query: userInput,
                reply: ChatServiceConstants.fallbackSuggestions.randomElement()!,
                responseMessage: ChatServiceConstants.outOfScopeMessage,
                isSuccess: false,
                timestamp: .now
            )
            
            let response = ChatResponse(
                isSuccess: conversation.isSuccess,
                conversationId: conversation.id,
                message: conversation.responseMessage
            )
                        
            chatStore.save(conversation)
            
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            return response
        }

        let lowercased = trimmed.lowercased()

        debugPrint("INPUT \(lowercased)")
        
        for (keywords, responses) in ChatServiceConstants.keywordToResponses {
            print("MATCHING \(keywords) \(responses)")
            if keywords.first(where: { lowercased.contains($0) }) != nil {
                
                let reply = responses.randomElement() ?? ChatServiceConstants.fallbackMessage
                
                let conversation = Chat(
                    query: userInput,
                    reply: reply,
                    responseMessage: nil,
                    isSuccess: true,
                    timestamp: .now
                )
                
                let response = ChatResponse(
                    isSuccess: conversation.isSuccess,
                    conversationId: conversation.id,
                    message: nil
                )
                
           
                chatStore.save(conversation)
                
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                
                return response
            }
        }


        let conversation = Chat(
            query: userInput,
            reply: ChatServiceConstants.fallbackSuggestions.randomElement()!,
            responseMessage: ChatServiceConstants.fallbackMessage,
            isSuccess: false,
            timestamp: .now
        )
        
        let response = ChatResponse(
            isSuccess: conversation.isSuccess,
            conversationId: conversation.id,
            message: conversation.responseMessage
        )
        
        chatStore.save(conversation)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        return response
        
    }

    private func validateGeneralText(_ text: String) -> Bool {
        guard !text.isEmpty else { return false }
        guard text.count <= maxCharacterLimit else { return false }
        guard text.count >= minCharacterLimit else { return false }
        guard isMostlyAlphanumeric(text) else { return false }
        guard !containsLink(text) else { return false }
        guard !containsJunkPattern(text) else { return false }
        guard !isGibberish(text) else { return false }
        return true
    }

    private func isMostlyAlphanumeric(_ text: String) -> Bool {
        let allowed = CharacterSet.alphanumerics.union(.whitespaces)
        let alphanumericCount = text.unicodeScalars.filter { allowed.contains($0) }.count
        return Double(alphanumericCount) / Double(text.count) >= alphanumericThreshold
    }

    private func containsLink(_ text: String) -> Bool {
        return text.range(of: "https?://\\S+", options: .regularExpression) != nil
    }

    private func containsJunkPattern(_ text: String) -> Bool {
        return text.range(of: "[a-zA-Z]{5,}\\d{3,}", options: .regularExpression) != nil
    }

    private func isGibberish(_ text: String) -> Bool {
        let cleaned = text.lowercased().replacingOccurrences(of: "[^a-z]", with: "", options: .regularExpression)
        let uniqueChars = Set(cleaned)
        return cleaned.count > gibberishLengthThreshold && uniqueChars.count <= gibberishCharThreshold
    }

    private func isSpamMessage(_ text: String) -> Bool {
        let lower = text.lowercased()
        return ChatServiceConstants.commonSpamPatterns.contains { lower.contains($0) }
    }

}
