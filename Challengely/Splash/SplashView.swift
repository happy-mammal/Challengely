//
//  ContentView.swift
//  Challengely
//
//  Created by Yash Lalit on 29/07/25.
//

import SwiftUI
import ComposableArchitecture

struct SplashView: View {
    
    let store: StoreOf<SplashStore>
    
    private let screen = UIScreen.main.bounds
    
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            ZStack {
                
               background
            
               glowingCircle(viewStore)
                
               surroundingMotivationalIcons(viewStore)
               
               expandingTrophyIcon(viewStore)

            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}


//Components
extension SplashView {
    var background: some View {
        Color(.systemBackground).ignoresSafeArea()
    }
    
    func glowingCircle(_ viewStore:ViewStoreOf<SplashStore>) -> some View {
        Circle()
            .fill(Color.blue.opacity(0.5))
            .frame(width: screen.width * 0.2, height: screen.width * 0.2)
            .scaleEffect(viewStore.showGlow ? 2 : 0.5)
            .opacity(viewStore.showGlow ? 0 : 1)
            .blur(radius: 8)
            .animation(.easeOut(duration: 0.6), value: viewStore.showGlow)
    }
    
    func surroundingMotivationalIcons(_ viewStore:ViewStoreOf<SplashStore>) -> some View {
        Group {
            MotivationalIcon(
                icon: "star.fill", color: .yellow,
                xOffset: -screen.width * 0.3,
                yOffset: -screen.height * 0.2,
                delay: 0.1,
                trigger: viewStore.animateIcons
            )

            MotivationalIcon(
                icon: "flame.fill",
                color: .red,
                xOffset: screen.width * 0.35,
                yOffset: -screen.height * 0.15,
                delay: 0.2,
                trigger: viewStore.animateIcons
            )

            MotivationalIcon(
                icon: "checkmark.seal.fill",
                color: .green,
                xOffset: -screen.width * 0.25,
                yOffset: screen.height * 0.18,
                delay: 0.3,
                trigger: viewStore.animateIcons
            )

            MotivationalIcon(
                icon: "bolt.fill",
                color: .blue,
                xOffset: screen.width * 0.3,
                yOffset: screen.height * 0.2,
                delay: 0.4,
                trigger: viewStore.animateIcons
            )
        }
    }
    
    func expandingTrophyIcon(_ viewStore:ViewStoreOf<SplashStore>) -> some View {
        Image(systemName: "trophy.fill")
            .resizable()
            .scaledToFit()
            .frame(width: screen.width * 0.25)
            .foregroundColor(.blue)
            .scaleEffect(viewStore.showTrophy ? (viewStore.zoomOut ? 52 : 1) : 0.3)
            .opacity(viewStore.showTrophy ? 1 : 0)
            .animation(.easeOut(duration: 0.6), value: viewStore.showTrophy)
            .animation(.easeInOut(duration: 0.8), value: viewStore.zoomOut)
    }
}


#Preview {
    SplashView(
        store: Store(initialState: SplashStore.State()) {
            SplashStore()
        }
    )
}
