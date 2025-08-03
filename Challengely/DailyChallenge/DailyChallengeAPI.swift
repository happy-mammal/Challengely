//
//  DailyChallengeAPI.swift
//  Challengely
//
//  Created by Yash Lalit on 03/08/25.
//

import Foundation
import SwiftUI

struct Challenge: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let estimatedTime: String
    let difficulty: Difficulty
    let interest: Interest
    
    static func == (lhs: Challenge, rhs: Challenge) -> Bool {
        lhs.id == rhs.id
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
