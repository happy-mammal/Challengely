import Foundation
import ComposableArchitecture

@Reducer
struct HomeStore {
    @ObservableState
    struct State: Equatable {
        var selectedTab = 0
        var dailyChallengeState = DailyChallengeStore.State()
        var chatState = ChatStore.State()
    }
    
    enum Action: Equatable {
        case tabSelected(Int)
        case dailyChallenge(DailyChallengeStore.Action)
        case chat(ChatStore.Action)
        case backToDailyChallenge
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.dailyChallengeState, action: /Action.dailyChallenge) {
            DailyChallengeStore()
        }
        
        Scope(state: \.chatState, action: /Action.chat) {
            ChatStore()
        }
        
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none
                
            case .backToDailyChallenge:
                state.selectedTab = 0
                return .none
                
            default:
                return .none
            }
        }
    }
} 
