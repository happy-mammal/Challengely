//
//  OnboardingFinishView.swift
//  Challengely
//
//  Created by Yash Lalit on 29/07/25.
//

import SwiftUI
import ConfettiSwiftUI

struct OnboardingCompleteView: View {
    @State private var animate: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "sparkles")
                .font(.system(size: 50))
                .foregroundColor(.blue)
                .scaleEffect(animate ? 1 : 0.7)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: animate)

            Text("You're In!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 10)
                .animation(.easeOut.delay(0.1), value: animate)

            Text("Let's start crafting your first challenge journey. 🚀")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 10)
                .animation(.easeOut.delay(0.2), value: animate)

            Spacer()
        }
        .confettiCannon(trigger: $animate)
        .onAppear {
            animate = true
        }
    }
}

#Preview {
   
    OnboardingCompleteView()
    
}
