import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppStore>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Group {
                switch viewStore.currentScreen {
                case .splash:
                    SplashView(
                        store: store.scope(
                            state: \.splashState,
                            action: AppStore.Action.splash
                        )
                    )
                    
                case .onboarding:
                    OnboardingView(
                        store: store.scope(
                            state: \.onboardingState,
                            action: AppStore.Action.onboarding
                        )
                    )
                    
                case .home:
                    HomeView(
                        store: store.scope(
                            state: \.homeState,
                            action: AppStore.Action.home
                        )
                    )
                }
            }
        }
    }
} 