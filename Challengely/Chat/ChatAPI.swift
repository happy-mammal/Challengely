//
//  ChatAPI.swift
//  Challengely
//
//  Created by Yash Lalit on 01/08/25.
//

import Foundation

enum Sender: String, Codable {
    case user, ai
}

enum MessageSender: String, Codable {
    case user, assistant
}

protocol ChatServiceProtocol {
    func getMessages(page: Int) -> [Chat]?
    func getMessage(_ id: UUID) -> Chat?
    func generate(for userInput: String) async -> ChatResponse
}

protocol ChatStoreProtocol {
    var totalItems: Int { get }
    var totalPages: Int { get }
    var chats: [Chat] { get }
    func save(_ chat: Chat)
}

struct MessageBlock: Identifiable, Equatable {
    static func == (lhs: MessageBlock, rhs: MessageBlock) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    let sender: Sender
    let messages: [Message]
}

struct EnhancedMessageBlock: Identifiable, Equatable {
    let id: UUID
    let type: MessageSender
    let content: String
    let timestamp: Date
    
    init(id: UUID = UUID(), type: MessageSender, content: String, timestamp: Date = Date()) {
        self.id = id
        self.type = type
        self.content = content
        self.timestamp = timestamp
    }
}

struct Message {
    let id = UUID()
    let type: MessageType
}

enum MessageType {
    case text(String)
    case textSub(ChatMessageStreamer)
}

struct Chat: Identifiable, Codable, Equatable {
    var id  = UUID()
    let query: String
    let reply: String
    let responseMessage: String?
    let isSuccess: Bool
    let timestamp: Date
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.id == rhs.id
    }
}

struct ChatResponse {
    let isSuccess: Bool
    let conversationId: UUID
    let message: String?
}

struct ChatServiceConstants {
    static let fallbackMessage = "That's interesting! Could you elaborate a bit?"

    static let outOfScopeMessage = "Hmm, that doesn't look like something I can help with. Try asking about your challenge!"
    
    static let fallbackSuggestions: [String] = [
        "Tell me more about your experience.",
        "What was the most difficult part?",
        "What helped you stay focused?",
        "Any reflections after the challenge?",
        "Want to try something new today?"
    ]

    static let commonSpamPatterns: [String] = [
        "free money", "visit my site", "click here", "buy now", "subscribe", "http", "https", ".com", ".ru", ".xyz",
        "cheap deal", "limited offer", "promo code", "get rich", "earn fast", "guaranteed income",
        "t.me/", "bit.ly", "@everyone", "#giveaway", "!!!", "dm me", "check my page",
        "win big", "make $$$", "join group", "exclusive access", "referral link"
    ]

    static let keywordToResponses: [Set<String>: [String]] = [
        ["nervous", "worried", "anxious", "stressed"]: [
            "Start small. 5 minutes is a great place to begin.",
            "It's okay to feel nervous. Every expert was once a beginner.",
            "Breathe deeply. You've got this! 💪",
            "Stress is temporary. Take a mindful pause."
        ],
        ["distracted", "unfocused", "can't concentrate"]: [
            "Try counting your breaths from 1 to 10, then repeat.",
            "Bring your attention gently back. No judgment.",
            "Totally normal! Just return to your breath.",
            "Focus comes in waves — you're doing fine."
        ],
        ["challenge", "today's challenge", "what's my challenge", "give challenge", "show task", "new task"]: [
            "Your challenge today is a 30-minute meditation. ✨",
            "Today you're trying mindful silence for 30 minutes.",
            "Let's start strong: 30-minute meditation is today's goal.",
            "Here’s your new challenge — dive in when you're ready."
        ],
        ["done", "completed", "finished", "i did it", "check", "marked"]: [
            "Awesome work! How did that feel?",
            "Nice job completing the challenge! What was the hardest part?",
            "🎉 You did it! What stood out to you?",
            "That’s another step forward. Great work!"
        ],
        ["streak", "momentum", "habit", "routine", "daily"]: [
            "You're crushing it! 🔥 Keep the streak alive!",
            "Consider setting a daily reminder to build consistency.",
            "Every day counts. Tomorrow is waiting!",
            "Momentum is growing — stay with it!"
        ],
        ["motivate", "inspire", "need push", "boost"]: [
            "One step at a time. You've got this.",
            "Even a small effort today brings big change tomorrow.",
            "Every champion was once a beginner. Start now.",
            "Need a boost? Keep your why close."
        ],
        ["fail", "missed", "couldn't", "can't do", "didn't"]: [
            "It's okay to miss a day. What matters is you're back now.",
            "Progress isn't linear. You're still on the path.",
            "Tomorrow is a new chance. Let's go again!",
            "Failure isn't the end — it's part of the process."
        ]
    ]
    
    static let keywordToSuggestions: [Set<String>: [String]] = [
        ["nervous", "worried", "anxious", "stressed"]: [
            "Feeling anxious today.",
            "Bit nervous, honestly.",
            "Worried about messing up.",
            "I'm stressed out.",
            "Having an anxious moment.",
            "Pretty nervous about starting.",
            "Feeling a little worried."
        ],
        
        ["distracted", "unfocused", "can't concentrate"]: [
            "Totally distracted today.",
            "Can’t concentrate right now.",
            "Unfocused and scattered.",
            "I’m really distracted.",
            "Struggling to concentrate.",
            "Mind keeps wandering.",
            "Focus is off today."
        ],
        
        ["challenge", "today's challenge", "what's my challenge", "give challenge", "show task", "new task"]: [
            "What’s today’s challenge?",
            "Give me a new challenge.",
            "Show me my task.",
            "Ready for today’s challenge!",
            "Challenge me please.",
            "What’s my challenge today?",
            "Show task for the day."
        ],
        
        ["done", "completed", "finished", "i did it", "check", "marked"]: [
            "Just completed it.",
            "Challenge done!",
            "I did it!",
            "Marked as done.",
            "Finished my task.",
            "Checked it off.",
            "Wrapped it up."
        ],
        
        ["streak", "momentum", "habit", "routine", "daily"]: [
            "How’s my streak going?",
            "Still on my habit streak!",
            "Keeping my routine strong.",
            "Daily challenge done!",
            "Let’s keep the momentum.",
            "Show my streak progress.",
            "Routine is building."
        ],
        
        ["motivate", "inspire", "need push", "boost"]: [
            "Need some motivation.",
            "Looking for a boost.",
            "Inspire me today!",
            "Push me forward.",
            "Could use a bit of motivation.",
            "Help me stay inspired.",
            "Give me a boost!"
        ],
        
        ["fail", "missed", "couldn't", "can't do", "didn't"]: [
            "I missed today’s challenge.",
            "Couldn’t finish it.",
            "Didn’t get it done.",
            "Feel like I failed today.",
            "Can’t do it today.",
            "Slipped up today.",
            "Didn’t go well."
        ]
    ]



}
