import Foundation

class ChatStorage: ChatStoreProtocol {
    var totalItems: Int {
        chats.count
    }
    
    var totalPages: Int {
        Int(chats.count / 10) + 1
    }
    
    private(set) var chats: [Chat] = []
    
    private enum ChatStoreKeys: String {
        case history
        case lastSavedOn
    }
    
    private let calendar = Calendar.current
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadChats()
    }
    
    private func loadChats() {
        guard let lastSavedOn = userDefaults.string(forKey: ChatStoreKeys.lastSavedOn.rawValue) else {
            self.chats = []
            return
        }
        
        guard let lastSavedDate = ISO8601DateFormatter().date(from: lastSavedOn) else {
            self.chats = []
            return
        }
        
        guard calendar.isDateInToday(lastSavedDate) else {
            userDefaults.removeObject(forKey: ChatStoreKeys.history.rawValue)
            userDefaults.removeObject(forKey: ChatStoreKeys.lastSavedOn.rawValue)
            self.chats = []
            return
        }
        
        guard let data = userDefaults.data(forKey: ChatStoreKeys.history.rawValue) else {
            self.chats = []
            return
        }
        
        guard let messages = try? JSONDecoder().decode([Chat].self, from: data) else {
            self.chats = []
            return
        }
        
        let today = Date()
        self.chats = messages.filter { calendar.isDate($0.timestamp, inSameDayAs: today) }
    }
    
    func save(_ chat: Chat) {
        let today = Date()
        var existingChats = chats.filter { calendar.isDate($0.timestamp, inSameDayAs: today) }
        existingChats.append(chat)
        
        guard let data = try? JSONEncoder().encode(existingChats) else { return }
        
        chats = existingChats
        
        userDefaults.set(data, forKey: ChatStoreKeys.history.rawValue)
        userDefaults.set(Date.now.ISO8601Format(), forKey: ChatStoreKeys.lastSavedOn.rawValue)
    }
}
