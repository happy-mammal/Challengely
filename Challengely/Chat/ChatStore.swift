import Foundation
import UIKit
import ComposableArchitecture

@Reducer
struct ChatStore {
    @ObservableState
    struct State: Equatable {
        var messages: [MessageBlock] = []
        var currentSuggestions: [String] = []
        var isStreaming: Bool = false
        var isLoading: Bool = false
        var userInput: String = ""
        var currentPage: Int = 1
        var typingIndicatorVisible = false
        var lastResponseTime: Date = Date()
        
        var canSend: Bool {
            !isLoading && !isStreaming && !userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        
        var characterCount: Int {
            userInput.count
        }
        
        var isNearCharacterLimit: Bool {
            characterCount > 450
        }
        
        var isAtCharacterLimit: Bool {
            characterCount >= 500
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case userInputChanged(String)
        case sendMessage(String)
        case setLoading(Bool)
        case setStreaming(Bool)
        case addMessage(MessageBlock)//
        case hideTypingIndicator //
        case addSuggestion(String) //
        case clearSuggestions //
        case onSend
        case loadMessages
        case suggestionTapped(String)
        case loadMessagesResponse([Chat])
    }
    
    @Dependency(\.localStore) var localStore
    @Dependency(\.chatService) var chatService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                if state.messages.isEmpty {
                    let welcomeMessage = MessageBlock(
                        sender: .ai,
                        messages: [.init(type: .text("Hey there! 👋 I'm your challenge assistant. I'm here to help you with today's challenge, provide motivation, and answer any questions you might have. What would you like to know?"))]
                    )
                    state.messages.append(welcomeMessage)
                    
                    // Use existing fallback suggestions from ChatService
                    state.currentSuggestions = ChatServiceConstants.keywordToSuggestions.randomElement()!.value
                }
                
                return .none
                
            case let .userInputChanged(input):
                state.userInput = input
                return .none
                
            case .onSend:
                guard !state.userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                      !state.isLoading && !state.isStreaming else {
                    return .none
                }
                
                let input = state.userInput.trimmingCharacters(in: .whitespacesAndNewlines)
                state.userInput = ""
                return .send(.sendMessage(input))
                
            case .sendMessage(let input):
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                
                let userMessage = MessageBlock(
                    sender: .user,
                    messages: [.init(type: .text(input))]
                )
                
                state.messages.append(userMessage)
                
                state.isLoading = true
                
                state.currentSuggestions.removeAll()
                
                return .run { [input] send in
                   
                    let response = await chatService.generate(for: input)
                    
   
                    await send(.setLoading(false))
                                       
                    if response.isSuccess {
                        
                        let generator = await UINotificationFeedbackGenerator()
                        await generator.notificationOccurred(.success)
                        
                        await send(.setStreaming(true))
                        
                        let streamer = ChatMessageStreamer(conversationId: response.conversationId) {
                            Task {
                                    await send(.setStreaming(false))
                                    let suggestions = generateSuggestionsForInput(input)
                                    for suggestion in suggestions.prefix(3) {
                                        await send(.addSuggestion(suggestion))
                                    }
                                }
                            
                        }
                        
                        let streamableMessage = MessageType.textSub(streamer)
                        
                        let message: Message = .init(type: streamableMessage)
                        
                        await send(.addMessage(.init(sender: .ai, messages: [message])))
               
                    }else {
                        
                        let generator = await UINotificationFeedbackGenerator()
                        await generator.notificationOccurred(.error)
                        
                        var replies: [String] = []
                        
                        guard let message = response.message else { return }
                        
                        replies.append(message)
                        
                        guard let conversation = chatService.getMessage(response.conversationId) else { return }
                        
                        replies.append(conversation.reply)
                        
                        let repliesToMessages = replies.map { Message(type: .text($0)) }
                        
                        await send(.addMessage(.init(sender: .ai, messages: repliesToMessages)))
                        
                        // Generate suggestions based on user input using existing keyword mapping
                        let suggestions = generateSuggestionsForInput(input)
                        for suggestion in suggestions.prefix(3) {
                            await send(.addSuggestion(suggestion))
                        }
                    }
                    
                }
                
            case let .setLoading(loading):
                state.isLoading = loading
                return .none
                
            case let .setStreaming(streaming):
                state.isStreaming = streaming
                return .none
                
            case let .addMessage(message):
                state.messages.append(message)
                return .none
                
            case .hideTypingIndicator:
                state.typingIndicatorVisible = false
                return .none
                
            case let .addSuggestion(suggestion):
                state.currentSuggestions.append(suggestion)
                return .none
                
            case .clearSuggestions:
                state.currentSuggestions.removeAll()
                return .none
                
            case .suggestionTapped(let suggestion):
                
                guard !state.isLoading && !state.isStreaming else {
                    return .none
                }
                
                return .send(.sendMessage(suggestion))
                
                
            case .loadMessages:
                let currentPage = state.currentPage
                return .run { send in
                    guard let conversations = chatService.getMessages(page: currentPage) else {
                        return
                    }
                    
                    await send(.loadMessagesResponse(conversations))
                }
                
            case let .loadMessagesResponse(conversations):
                var newMessages: [MessageBlock] = []
                
                for conversation in conversations {
                    // Add user message
                    let userMessage = MessageBlock(
                        sender: .user,
                        messages: [.init(type: .text(conversation.query))]
                    )
                    newMessages.append(userMessage)
                    
                    // Add AI response
                    var aiContent: [Message] = []
                    
                    if let responseMessage = conversation.responseMessage {
                        aiContent.append( .init(type: .text(responseMessage)))
                    }
                    
                    aiContent.append(.init(type: .text(conversation.reply)))
                    
                    let aiMessage = MessageBlock(
                        sender: .ai,
                        messages: aiContent
                    )
                    newMessages.append(aiMessage)
                }
                
                // Insert at the beginning to show older messages at the top
                state.messages.insert(contentsOf: newMessages, at: 0)
                state.currentPage += 1
                
                return .none
            }
        }
    }
    
    // Helper function to generate suggestions based on user input using existing keyword mapping
    private func generateSuggestionsForInput(_ input: String) -> [String] {
        let lowercased = input.lowercased()
        
        for (keywords, suggestions) in ChatServiceConstants.keywordToSuggestions {
            if keywords.first(where: { lowercased.contains($0) }) != nil {
                return suggestions
            }
        }
        
        // Fallback to general suggestions
        return ChatServiceConstants.fallbackSuggestions
    }
    

} 
