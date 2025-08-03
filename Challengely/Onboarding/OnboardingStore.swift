import Foundation
import ComposableArchitecture

@Reducer
struct OnboardingStore {
    @ObservableState
    struct State: Equatable {
        var currentPage = 0
        var interests: [Interest: Bool] = [:]
        var difficulty: Difficulty?
        var name: String = ""
        var isAnimating = false
        var validationError: String?
        
        var shouldShowBackButton: Bool {
            currentPage > 1 && currentPage < 4
        }
        
        var shouldShowSkipButton: Bool {
            currentPage > 0 && currentPage < 4
        }
        
        var nextButtonTitle: String {
            switch currentPage {
            case 0:
                return "Get Started"
            case 4:
                return "Let's Go"
            default:
                return "Continue"
            }
        }
        
        var shouldShowStepper: Bool {
            currentPage > 0
        }
        
        var canProceed: Bool {
            switch currentPage {
            case 0:
                return true
            case 1:
                return interests.values.contains(true)
            case 2:
                return difficulty != nil
            case 3:
                return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            case 4:
                return true
            default:
                return false
            }
        }
        
        var selectedInterestsCount: Int {
            interests.values.filter { $0 }.count
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case nextTapped
        case backTapped
        case skipTapped
        case interestTapped(Interest)
        case difficultySelected(Difficulty)
        case nameChanged(String)
        case setPreferences
        case onboardingComplete
        case setAnimating(Bool)
        case clearValidationError
    }
    
    @Dependency(\.localStore) var localStore
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // Initialize interests
                for interest in Interest.allCases {
                    if state.interests[interest] == nil {
                        state.interests[interest] = false
                    }
                }
                return .none
                
            case .nextTapped:
                if !state.canProceed {
                    state.validationError = getValidationError(for: state.currentPage)
                    return .none
                }
                
                state.validationError = nil
                
                if state.currentPage < 4 {
                    state.isAnimating = true
                    state.currentPage += 1
                    return .run { send in
                        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
                        await send(.setAnimating(false))
                    }
                } else {
                    setPreferences(state: &state)
                    return .send(.onboardingComplete)
                }
                
            case .backTapped:
                if state.currentPage > 0 {
                    state.isAnimating = true
                    state.currentPage -= 1
                    state.validationError = nil
                    return .run { send in
                        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
                        await send(.setAnimating(false))
                    }
                }
                return .none
                
            case .skipTapped:
                setPreferences(state: &state)
                return .send(.onboardingComplete)
                
            case .interestTapped(let interest):
                state.interests[interest]?.toggle()
                state.validationError = nil
                return .none
                
            case .difficultySelected(let difficulty):
                state.difficulty = difficulty
                state.validationError = nil
                return .none
                
            case .nameChanged(let name):
                state.name = name
                state.validationError = nil
                return .none
                
            case .setAnimating(let isAnimating):
                state.isAnimating = isAnimating
                return .none
                
            case .clearValidationError:
                state.validationError = nil
                return .none
                
            case .setPreferences, .onboardingComplete:
                return .none
            }
        }
    }
    
    private func setPreferences(state: inout State) {
        let selectedInterests = state.interests.compactMap { interest, isSelected in
            isSelected ? interest : nil
        }
        
        let userPreferences = UserPreferences(
            name: state.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
            "Friend" : state.name.trimmingCharacters(in: .whitespacesAndNewlines),
            interests: selectedInterests,
            difficulty: state.difficulty ?? .medium
        )
        
        localStore.saveUserPrefs(userPreferences)
        localStore.markFirstLaunch()
    }
    
    private func getValidationError(for page: Int) -> String {
        switch page {
        case 1:
            return "Please select at least one interest"
        case 2:
            return "Please select a difficulty level"
        case 3:
            return "Please enter your name"
        default:
            return ""
        }
    }
} 
