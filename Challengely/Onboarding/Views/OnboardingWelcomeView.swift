//
//  WelcomeView.swift
//  Challengely
//
//  Created by Yash Lalit on 29/07/25.
//

import SwiftUI
struct OnboardingWelcomeView: View {
    @State private var animate = false
    @State private var pulse = false
    
    var body: some View {
        
        VStack(spacing: 24) {
            
            
            bouncingCircularTrophy
            
            welcomeText
            
            descriptionText
          
        }
        .padding()
        .onAppear {
            animate = true
            pulse = true
        }

    }
}

//Components
extension OnboardingWelcomeView {
    var bouncingCircularTrophy: some View {
        ZStack {
            Circle()
                .fill(Color(.systemGray6))
                .frame(width: 128, height: 128)
                .shadow(color: Color(.label).opacity(0.1), radius: 20, y: 10)
                .scaleEffect(animate ? 1 : 0.8)
                .opacity(animate ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: animate)
            
            Image(systemName: "trophy.fill")
                .renderingMode(.template)
                .foregroundStyle(Color(.systemBlue))
                .font(.system(size: 48, weight: .semibold))
                .scaleEffect(pulse ? 1.05 : 0.95)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulse)
        }
    }
    
    var welcomeText: some View {
        VStack(spacing: 0) {
            Text("Welcome to")
                .font(.title)
                .fontWeight(.medium)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 20)
                .animation(.easeOut(duration: 0.4).delay(0.2), value: animate)
            
            Text("Challengely")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color(.systemBlue))
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: animate)
        }
    }
    
    var descriptionText: some View {
        Text("Your daily dose of personalized challenges to help you grow and achieve your goals.")
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color(.secondaryLabel))
            .padding(.horizontal)
            .padding(.top, 12)
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.4), value: animate)
    }
}


#Preview {
    let screen = UIScreen.main.bounds
    
    ZStack(alignment: .center){
        Color(.systemBackground)
            .ignoresSafeArea()
        
        OnboardingWelcomeView()
        
    }
    .frame(width: screen.width,height: screen.height, alignment: .center)
    
}
