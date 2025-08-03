import Foundation
import ComposableArchitecture

@Reducer
struct DailyChallengeStore {
    @ObservableState
    struct State: Equatable {
        var currentChallenge: Challenge?
        var isLoading: Bool = false
        var isCompleted: Bool = false
        var inProgress: Bool = false
        var allChallenges: [Challenge] = []
    }
    
    enum Action: Equatable {
        case onAppear
        case loadChallenges
        case selectTodayChallenge
        case onComplete
        case refreshChallenge
        case setLoading(Bool)
        case setChallenge(Challenge?)
        case setCompleted(Bool)
        case onAccept
        case onCancel
    }
    
    @Dependency(\.localStore) var localStore
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.loadChallenges)
                    await send(.selectTodayChallenge)
                }
                
            case .loadChallenges:
                state.allChallenges = CommonConstants.interests.flatMap { interest in
                    [

                        Challenge(
                            title: "Quick \(interest.name) Warm-up",
                            description: "Spend 10 minutes doing a light \(interest.name.lowercased()) activity.",
                            estimatedTime: "10 mins",
                            difficulty: .easy,
                            interest: interest
                        ),
                        Challenge(
                            title: "\(interest.name) Inspiration",
                            description: "Read or watch a short piece to get inspired in \(interest.name.lowercased()).",
                            estimatedTime: "5 mins",
                            difficulty: .easy,
                            interest: interest
                        ),
                        Challenge(
                            title: "\(interest.name) Journal Entry",
                            description: "Write down 3 things you like or learned about \(interest.name.lowercased()).",
                            estimatedTime: "7 mins",
                            difficulty: .easy,
                            interest: interest
                        ),

                        // Medium
                        Challenge(
                            title: "\(interest.name) Practice Session",
                            description: "Spend focused time improving a specific skill in \(interest.name.lowercased()).",
                            estimatedTime: "25 mins",
                            difficulty: .medium,
                            interest: interest
                        ),
                        Challenge(
                            title: "\(interest.name) Challenge",
                            description: "Try a new technique or tool in \(interest.name.lowercased()).",
                            estimatedTime: "30 mins",
                            difficulty: .medium,
                            interest: interest
                        ),
                        Challenge(
                            title: "\(interest.name) Deep Practice",
                            description: "Work on a moderate project or routine for \(interest.name.lowercased()).",
                            estimatedTime: "20 mins",
                            difficulty: .medium,
                            interest: interest
                        ),

                        // Hard
                        Challenge(
                            title: "Advanced \(interest.name) Task",
                            description: "Take on a complex or time-intensive project related to \(interest.name.lowercased()).",
                            estimatedTime: "45 mins",
                            difficulty: .hard,
                            interest: interest
                        ),
                        Challenge(
                            title: "\(interest.name) Mastery Session",
                            description: "Challenge yourself with a high-difficulty task in \(interest.name.lowercased()).",
                            estimatedTime: "60 mins",
                            difficulty: .hard,
                            interest: interest
                        ),
                        Challenge(
                            title: "\(interest.name) Endurance Challenge",
                            description: "Sustain focus on one difficult \(interest.name.lowercased()) task without breaks.",
                            estimatedTime: "50 mins",
                            difficulty: .hard,
                            interest: interest
                        )
                    ]
                }
                return .none
                
            case .selectTodayChallenge:
                
                if let lastChallengeOn = UserDefaults.standard.string(forKey: "lastChallengeOn"),
                      let date = ISO8601DateFormatter().date(from: lastChallengeOn),
                   Calendar.current.isDateInToday(date) {
                    return .none
                }
                
                // Always select a challenge for today, regardless of previous selections
                guard let prefs = localStore.loadUserPrefs() else { 
                    // If no preferences, use default values
                    let defaultInterest = Interest.allCases.randomElement()!
                    let challenges = state.allChallenges.filter { $0.interest == defaultInterest }
                    state.currentChallenge = challenges.randomElement()
                    state.isCompleted = false
                    return .none
                }
                
                // Filter challenges based on user preferences
                let availableChallenges = state.allChallenges.filter { challenge in
                    prefs.interests.contains(challenge.interest) && challenge.difficulty == prefs.difficulty
                }
                
                // If no challenges match preferences, use any available challenge
                let challengesToUse = availableChallenges.isEmpty ? state.allChallenges : availableChallenges
                
                state.currentChallenge = challengesToUse.randomElement()
                state.isCompleted = false
                
                return .none
                
            case .onComplete:
                state.inProgress = false
                state.isCompleted = true
                UserDefaults.standard.set(Date.now.ISO8601Format(), forKey: "lastChallengeOn")
                return .none
                
            case .refreshChallenge:
                return .run { send in
                    await send(.setLoading(true))
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    await send(.selectTodayChallenge)
                    await send(.setLoading(false))
                }
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                return .none
                
            case let .setChallenge(challenge):
                state.currentChallenge = challenge
                return .none
                
            case let .setCompleted(isCompleted):
                state.isCompleted = isCompleted
                return .none
                
            case .onAccept:
                state.inProgress = true
                return .none
                
            case .onCancel:
                state.inProgress = false
                return .none
            }
        }
    }
} 
