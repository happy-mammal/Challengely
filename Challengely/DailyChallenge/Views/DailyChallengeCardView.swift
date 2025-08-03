//
//  DailyChallengeCardView.swift
//  Challengely
//
//  Created by Yash Lalit on 03/08/25.
//

import SwiftUI

struct DailyChallengeCardView: View {
    
    let challenge: Challenge
    var isCompleted: Bool
    var onAccept: () -> Void
    var onShare: () -> Void
    var onComplete: () -> Void
    var onCancel: () -> Void
    

    @State private var timerRunning = false
    @State private var remainingSeconds: Int = 0
    @State private var timer: Timer?
    @State private var showTimer = false
    @State private var isPressed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            nameAndDifficulty
            
            titleAndDescription

            timerStatus

            if !isCompleted && !timerRunning {
                cardButton(
                    "Accept Challenge",
                    icon: "bolt.fill",
                    gradient: LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    onTap: startTimer
                )
            }
            
            if timerRunning && !isCompleted {
                cardButton(
                    "Cancel Challenge",
                    icon: "bolt.slash.fill",
                    gradient: LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    onTap: {
                        stopTimer()
                        onCancel()
                    }
                )
  
            }
            
            if isCompleted {
                cardButton(
                    "Share",
                    icon: "square.and.arrow.up",
                    gradient: LinearGradient(
                        colors: [.green, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    onTap: onShare
                )
        
            }
            
            completionStatusAndDuration
            
   
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    isCompleted ? Color.green.opacity(0.3) : Color.clear,
                    lineWidth: 2
                )
        )
        .scaleEffect(isCompleted ? 1.02 : 1.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isCompleted)
        .onDisappear {
            timer?.invalidate()
        }
    }


}

//Components
extension DailyChallengeCardView {
    
    var completionStatusAndDuration: some View {
        HStack {
            if isCompleted {
                Label("Completed", systemImage: "checkmark.seal.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.green)
            }

            Spacer()
            
            Label(challenge.estimatedTime, systemImage: "clock")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.top, 8)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    func cardButton(_ title: String, icon: String, gradient: LinearGradient, onTap:  @escaping ()->Void) -> some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                onTap()
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(gradient)
            .cornerRadius(12)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    var nameAndDifficulty: some View {
        HStack {
            Label(challenge.interest.name, systemImage: challenge.interest.icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(challenge.difficulty.rawValue)
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(challenge.difficulty.color)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    var titleAndDescription: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(challenge.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .lineLimit(2)

            Text(challenge.description)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
    }
    
    @ViewBuilder
    var timerStatus: some View {
        if timerRunning && !isCompleted {
            VStack(spacing: 8) {
                Text("⏳ \(formatTime(remainingSeconds))")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.orange)
                    .transition(.scale.combined(with: .opacity))
                
                ProgressView(value: Double(parseEstimatedTime(challenge.estimatedTime) - remainingSeconds), total: Double(parseEstimatedTime(challenge.estimatedTime)))
                    .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                    .scaleEffect(y: 2)
            }
            .padding(.vertical, 8)
        }
    }
}

//Helper Functions
extension DailyChallengeCardView {
    
    private func startTimer() {
        let duration = parseEstimatedTime(challenge.estimatedTime)
        
        remainingSeconds = duration
        timerRunning = true
        showTimer = true
        
        onAccept()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if remainingSeconds > 0 {
                withAnimation(.easeInOut(duration: 0.5)) {
                    remainingSeconds -= 1
                }
            } else {
                stopTimer()
                
                onComplete()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timerRunning = false
        showTimer = false
    }

    private func parseEstimatedTime(_ text: String) -> Int {
        let comps = text.components(separatedBy: " ")
        
        //MARK: I have intentially made this mistake here so that challege is complete in 10 secs
        if let num = Int(comps.first ?? ""), comps.contains("min") {
            return num * 60
        }
        
        return 10
    }

    private func formatTime(_ seconds: Int) -> String {
        let min = seconds / 60
        let sec = seconds % 60
        return String(format: "%02d:%02d", min, sec)
    }
}

#Preview {
    DailyChallengeCardView(
        challenge: Challenge(
            title: "10 Min Morning Yoga",
            description: "Start your day with gentle stretching and breathing exercises to energize your body and mind.",
            estimatedTime: "10 mins",
            difficulty: .easy,
            interest: Interest(name: "Fitness", icon: "figure.walk")
        ),
        isCompleted: false,
        onAccept: {},
        onShare: {},
        onComplete: {},
        onCancel: {}
    )
    .padding()
}
