import Foundation
import ComposableArchitecture

@Reducer
struct SplashStore {
    @ObservableState
    struct State: Equatable {
        var showTrophy = false
        var animateIcons = false
        var zoomOut = false
        var showGlow = false
        var isAnimationComplete = false
    }
    
    enum Action: Equatable {
        case onAppear
        case showTrophy
        case animateIcons
        case zoomOut
        case showGlow
        case animationComplete
        case onboardingComplete
        case homeComplete
    }
    
    @Dependency(\.localStore) var localStore
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try await Task.sleep(nanoseconds: 500_000_000)
                    await send(.showTrophy)
                    
                    try await Task.sleep(nanoseconds: 500_000_000)
                    await send(.animateIcons)
                    
                    try await Task.sleep(nanoseconds: 1000_000_000)
                    await send(.zoomOut)
                    
                    try await Task.sleep(nanoseconds: 800_000_000)
                    await send(.animationComplete)
                }
                
            case .showTrophy:
                state.showTrophy = true
                return .none
                
            case .animateIcons:
                state.animateIcons = true
                return .none
                
            case .zoomOut:
                state.zoomOut = true
                return .none
                
            case .showGlow:
                state.showGlow = true
                return .none
                
            case .animationComplete:
                state.isAnimationComplete = true
                
                if localStore.isFirstLaunch() {
                    return .send(.onboardingComplete)
                } else {
                    return .send(.homeComplete)
                }
                
            case .onboardingComplete, .homeComplete:
                return .none
            }
        }
    }
}

extension DependencyValues {
    var localStore: LocalStoreProtocol {
        get { self[LocalStoreKey.self] }
        set { self[LocalStoreKey.self] = newValue }
    }
    
    var chatService: ChatServiceProtocol {
        get { self[ChatServiceKey.self] }
        set { self[ChatServiceKey.self] = newValue }
    }
}

private enum LocalStoreKey: DependencyKey {
    static let liveValue: LocalStoreProtocol = LocalStore()
}

private enum ChatServiceKey: DependencyKey {
    static let liveValue: ChatServiceProtocol = ChatService.shared
} 