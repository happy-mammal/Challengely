//
//  ChallengelyApp.swift
//  Challengely
//
//  Created by Yash Lalit on 29/07/25.
//


import SwiftUI
import ComposableArchitecture

@main
struct ChallenglyApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(initialState: AppStore.State()) {
                    AppStore()
                }
            )
        }
    }
}
