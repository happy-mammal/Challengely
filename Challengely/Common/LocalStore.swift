//
//  LocalStore.swift
//  Challengely
//
//  Created by Yash Lalit on 03/08/25.
//

import Foundation

protocol LocalStoreProtocol {
    func saveUserPrefs(_ prefs: UserPreferences)
    func loadUserPrefs() -> UserPreferences?
    func markFirstLaunch()
    func isFirstLaunch() -> Bool
    
}
class LocalStore: LocalStoreProtocol {
    private let userDefault = UserDefaults.standard
    
    private enum LocalStoreKeys: String {
        case userPreferences
        case hasLaunchedBefore
    }
    
    func markFirstLaunch() {
        userDefault.set(true, forKey: LocalStoreKeys.hasLaunchedBefore.rawValue)
    }
    
    func isFirstLaunch() -> Bool {
        !userDefault.bool(forKey: LocalStoreKeys.hasLaunchedBefore.rawValue)
    }
    
    func saveUserPrefs(_ prefs: UserPreferences) {
        guard let encoded = try? JSONEncoder().encode(prefs) else { return }
        
        userDefault.set(encoded, forKey: LocalStoreKeys.userPreferences.rawValue)
    }
    
    func loadUserPrefs() -> UserPreferences? {
        guard let data = userDefault.data(forKey: LocalStoreKeys.userPreferences.rawValue) else { return nil }
        
        guard let decoded = try? JSONDecoder().decode(UserPreferences.self, from: data) else { return nil }
        
        return decoded
    }
}
