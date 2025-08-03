//
//  DailyChallengeView.swift
//  Challengely
//
//  Created by Yash Lalit on 03/08/25.
//

import SwiftUI
import ComposableArchitecture
import ConfettiSwiftUI

struct DailyChallengeView: View {
    let store: StoreOf<DailyChallengeStore>
    
    @State private var confettiCounter = 0
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?
    @State private var generatingShareImage = false

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(spacing: 24) {
              
                    VStack(spacing: 8) {
                        Text(greeting())
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                        
                        Text("Ready for today's challenge?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    if viewStore.isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.2)
                            Text("Loading your challenge...")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .padding()
                    } else if let challenge = viewStore.currentChallenge {
                        
                        DailyChallengeCardView(
                            challenge: challenge,
                            isCompleted: viewStore.isCompleted,
                            onAccept: {
                                viewStore.send(.onAccept)
                            },
                            onShare: {
                                generateShareImage(challenge: challenge)
                                showShareSheet = true
                            },
                            onComplete: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    viewStore.send(.onComplete)
                                    confettiCounter += 1
                                }
                            },
                            onCancel: {
                                viewStore.send(.onCancel)
                            }
                            
                        )
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 48))
                                .foregroundColor(.blue)
                            
                            Text("No challenge for today")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Check back tomorrow for a fresh challenge!")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .padding()
                    }
                }
                .padding()
            }
            .confettiCannon(
                trigger: $confettiCounter,
                num: 50,
                openingAngle: Angle(degrees: 0),
                closingAngle: Angle(degrees: 360),
                radius: 200
            )
            .refreshable {
                if !viewStore.isLoading && !viewStore.inProgress {
                    viewStore.send(.refreshChallenge)
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let shareImage = shareImage {
                    ShareSheet(items: [shareImage])
                }else {
                    ProgressView()
                        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
    
    private func greeting() -> String {
       
        let hour = Calendar.current.component(.hour, from: Date())
        if let prefs = LocalStore().loadUserPrefs(), !prefs.name.isEmpty {
            switch hour {
            case 5..<12: return "Good Morning, \(prefs.name)!"
            case 12..<17: return "Good Afternoon, \(prefs.name)!"
            case 17..<22: return "Good Evening, \(prefs.name)!"
            default: return "Hello, \(prefs.name)!"
            }
        } else {
            switch hour {
            case 5..<12: return "Good Morning!"
            case 12..<17: return "Good Afternoon!"
            case 17..<22: return "Good Evening!"
            default: return "Hola, Amigo!"
            }
        }
        
       
        
    }
    

    private func generateShareImage(challenge: Challenge) {
        generatingShareImage = true
        Task { @MainActor in
            
            let view = ShareCardView(challenge: challenge)
            let renderer = ImageRenderer(content: view)
            renderer.scale = 2.0 // Adjust as needed

            if let image = renderer.uiImage {
                self.shareImage = image
            }
            generatingShareImage = false
        }
    }



}





#Preview {
    DailyChallengeView(
        store: Store(initialState: DailyChallengeStore.State()) {
            DailyChallengeStore()
        }
    )
}
