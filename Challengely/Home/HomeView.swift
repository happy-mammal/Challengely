//
//  Home.swift
//  Challengely
//
//  Created by Yash Lalit on 29/07/25.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    let store: StoreOf<HomeStore>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView(selection: Binding(
                get: { viewStore.selectedTab },
                set: { viewStore.send(.tabSelected($0)) }
            )) {
                DailyChallengeView(
                    store: store.scope(
                        state: \.dailyChallengeState,
                        action: HomeStore.Action.dailyChallenge
                    )
                )
                .tag(0)
                .tabItem {
                    Image(systemName: "trophy")
                }
                    
                ChatAssistantView(
                    store: store.scope(
                        state: \.chatState,
                        action: HomeStore.Action.chat
                    ),
                    onBack: {
                        viewStore.send(.backToDailyChallenge)
                    }
                )
                .toolbar(.hidden, for: .tabBar)
                .tag(1)
                .tabItem {
                    Image(systemName: "sparkles")
                }
            }
        }
    }
}

#Preview {
    HomeView(
        store: Store(initialState: HomeStore.State()) {
            HomeStore()
        }
    )
}
