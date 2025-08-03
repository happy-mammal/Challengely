//
//  OnboardingFinishView.swift
//  Challengely
//
//  Created by Yash Lalit on 29/07/25.
//

import SwiftUI
import ConfettiSwiftUI

struct OnboardingCompleteView: View {
    
    let animate: Bool
    
    @State private var animateLocal = false
    
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
        .confettiCannon(trigger: $animateLocal)
        .onChange(of: animate) { _, newValue in
            if newValue {
               
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    animateLocal = true
                }
                
            } else {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    animateLocal = false
                }
            }
        }
    }
}

#Preview {
   
    OnboardingCompleteView(animate: true)
    
}
