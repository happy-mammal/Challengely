import Foundation
import ComposableArchitecture

@Reducer
struct AppStore {
    @ObservableState
    struct State: Equatable {
        var currentScreen: AppScreen = .splash
        var splashState = SplashStore.State()
        var onboardingState = OnboardingStore.State()
        var homeState = HomeStore.State()
    }
    
    enum Action: Equatable {
        case splash(SplashStore.Action)
        case onboarding(OnboardingStore.Action)
        case home(HomeStore.Action)
        case navigateToOnboarding
        case navigateToHome
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.splashState, action: /Action.splash) {
            SplashStore()
        }
        
        Scope(state: \.onboardingState, action: /Action.onboarding) {
            OnboardingStore()
        }
        
        Scope(state: \.homeState, action: /Action.home) {
            HomeStore()
        }
        
        Reduce { state, action in
            switch action {
            case .splash(.onboardingComplete):
                state.currentScreen = .onboarding
                return .none
                
            case .splash(.homeComplete):
                state.currentScreen = .home
                return .none
                
            case .onboarding(.onboardingComplete):
                state.currentScreen = .home
                return .none
                
            case .navigateToOnboarding:
                state.currentScreen = .onboarding
                return .none
                
            case .navigateToHome:
                state.currentScreen = .home
                return .none
                
            case .splash, .onboarding, .home:
                return .none
            }
        }
    }
}

enum AppScreen: Equatable {
    case splash
    case onboarding
    case home
} 