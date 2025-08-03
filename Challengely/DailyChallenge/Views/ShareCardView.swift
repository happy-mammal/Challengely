//
//  ShareCardView.swift
//  Challengely
//
//  Created by Yash Lalit on 03/08/25.
//

import SwiftUI

struct ShareCardView: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Daily Challenge")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Completed Today!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Challenge Card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label(challenge.interest.name, systemImage: challenge.interest.icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Spacer()
                    Text(challenge.difficulty.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(challenge.difficulty.color)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Text(challenge.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(challenge.description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                HStack {
                    Label(challenge.estimatedTime, systemImage: "clock")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                    Label("Completed", systemImage: "checkmark.seal.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.green)
                }
            }
            .padding(20)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            
            // Footer
            Text("Challengely")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(30)
        .background(
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .frame(width: 300, height: 400)
    }
}

#Preview {
    ShareCardView(
        challenge: .init(title: "Some Challege", description: "Some Desc", estimatedTime: "10 mins", difficulty: .easy, interest: CommonConstants.interests[0])
    )
}
