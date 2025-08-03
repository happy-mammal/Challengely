//
//  CommonAPI.swift
//  Challengely
//
//  Created by Yash Lalit on 03/08/25.
//

import Foundation
import SwiftUI

struct Interest: Identifiable, Equatable, Hashable, Codable, CaseIterable {
    var id = UUID()
    let name: String
    let icon: String
    
    var color: Color {
        switch name.lowercased() {
        case "fitness": return .green
        case "creativity": return .purple
        case "mindfulness": return .blue
        case "learning": return .orange
        case "social": return .pink
        default: return .gray
        }
    }
    
    static let allCases: [Interest] = [
        Interest(name: "Fitness", icon: "figure.walk"),
        Interest(name: "Creativity", icon: "paintbrush"),
        Interest(name: "Mindfulness", icon: "brain.head.profile"),
        Interest(name: "Learning", icon: "book"),
        Interest(name: "Social", icon: "person.2")
    ]
}

enum Difficulty: String, CaseIterable, Identifiable, Codable, Equatable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .easy: return "Quick simple tasks that fit perfectly into a busy day."
        case .medium: return "Engaging challenges that require some dedicated effort."
        case .hard: return "Demanding tasks designed to truly push your limits."
        }
    }

    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }

    var icon: String {
        switch self {
        case .easy: return "face.smiling"
        case .medium: return "bolt"
        case .hard: return "flame"
        }
    }
    
    var index: Int {
        switch self {
        case .easy:
            0
        case .medium:
            1
        case .hard:
            2
        }
    }
}

struct Preferences: Codable {
    let name: String
    let interests: [Interest]
    let difficulty: Difficulty
}

struct UserPreferences: Codable {
    let name: String
    let interests: [Interest]
    let difficulty: Difficulty
}
