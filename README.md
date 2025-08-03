# 🚀 Challengely

> **A modern iOS app for daily challenges and personal growth, built with The Composable Architecture (TCA)**

## 📄 A Take Home Assignment for Founding Software Engineer - iOS by Yash Lalit

- **Developer**: Yash Lalit
- **Email**: yashlalit.23@gmail.com
- **GitHub**: [@happy-mammal](https://github.com/happy-mammal)
- **LinkedIn**: [Yash Lalit](https://www.linkedin.com/in/yash-lalit/)

## 📱 Overview
Challengely is a beautifully designed iOS application that helps users build positive habits through daily challenges. The app features an intelligent AI chat assistant, smooth onboarding flow, and engaging daily challenges with progress tracking.

### ✨ Key Features

- 🎯 **Daily Challenges** - Curated challenges with difficulty levels
- 🤖 **AI Chat Assistant** - Intelligent conversation with contextual responses
- 🎨 **Smooth Onboarding** - Beautiful multi-step user setup
- 📊 **Progress Tracking** - Visual progress indicators and completion celebrations
- 🎉 **Celebration Animations** - Confetti effects and micro-interactions
- 📤 **Social Sharing** - Share achievements on social media
- 🔄 **Pull-to-Refresh** - Load historical chat conversations
- 💾 **Local Storage** - Persistent user preferences and chat history


#### Architecture Layers:

```
┌─────────────────────────────────────┐
│           App Layer                 │
│  ┌─────────────────────────────┐    │
│  │        AppStore             │    │
│  │  - Global State Management  │    │
│  │  - Navigation Coordination  │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────┐
│         Feature Layer               │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐│
│  │ Splash  │ │Onboarding│ │  Home   ││
│  │ Store   │ │  Store   │ │ Store   ││
│  └─────────┘ └─────────┘ └─────────┘│
│  ┌─────────┐ ┌─────────┐ ┌─────────┐│
│  │DailyChal│ │  Chat   │ │Common   ││
│  │  Store  │ │ Store   │ │Services ││
│  └─────────┘ └─────────┘ └─────────┘│
└─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────┐
│         Service Layer               │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐│
│  │LocalStor│ │ChatServ │ │Dependency││
│  │   e     │ │  ice    │ │Injection││
│  └─────────┘ └─────────┘ └─────────┘│
└─────────────────────────────────────┘
```

## 📁 Project Structure

```
Challengely/
├── 📱 App/
│   ├── AppStore.swift          # Root reducer & global state
│   └── AppView.swift           # Main app container
│
├── 🎯 DailyChallenge/
│   ├── DailyChallengeStore.swift    # Challenge state management
│   ├── DailyChallengeView.swift     # Challenge UI
│   ├── DailyChallengeCardView.swift # Challenge card component
│   ├── DailyChallengeAPI.swift      # Challenge data models
│   └── DailyChallengeViewModel.swift
│
├── 💬 Chat/
│   ├── ChatStore.swift              # Chat state management
│   ├── ChatView.swift               # Chat UI
│   ├── ChatViewModel.swift
│   └── Views/
│       ├── ChatInputView.swift      # Expandable input field
│       ├── ChatMessagingView.swift  # Message list
│       ├── ChatMessageBlockView.swift # Message bubbles
│       ├── ChatMessageTextView.swift # Message text rendering
│       └── ChatMessageStreamView.swift # Streaming messages
│
├── 🎨 Onboarding/
│   ├── OnboardingStore.swift        # Onboarding state
│   ├── OnboardingView.swift         # Onboarding UI
│   ├── OnboardingViewModel.swift
│   └── Views/
│       ├── OnboardingWelcomeView.swift
│       ├── OnboardingCompleteView.swift
│       └── Service/
│
├── 🏠 Home/
│   ├── HomeStore.swift              # Tab navigation state
│   └── HomeView.swift               # Tab bar UI
│
├── 🌟 Splash/
│   ├── SplashStore.swift            # Splash state
│   ├── SplashView.swift             # Splash UI
│   └── SplashViewModel.swift
│
├── 🔧 Common/
│   ├── CommonAPI.swift              # Shared data models
│   ├── CommonConstants.swift        # App constants
│   ├── LocalStore.swift             # Local storage service
│   └── Views/
│       ├── DifficultyView.swift     # Difficulty selection
│       ├── InterestsView.swift      # Interest selection
│       └── UserNameView.swift       # Name input
│
├── 🧩 Components/
│   ├── CircularLoader.swift         # Loading indicator
│   ├── MotivationalIcon.swift       # Motivational icons
│   ├── ProgressStepper.swift        # Progress indicator
│   ├── SelectableRow.swift          # Selectable list items
│   └── SelectableTile.swift         # Selectable tiles
│
├── 🎨 Assets.xcassets/              # App icons & images
├── 📱 Launch Screen.storyboard      # Launch screen
└── 🚀 ChallengelyApp.swift          # App entry point
```

# NOTE: Please Go to DailyChallengeCardView and find "I have intentially made this mistake here so that challenge is completed in 10 secs" as MARK comment and change min to mins in order to get real timer as per the challege estimated time.
