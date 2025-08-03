//
//  OnboardingView.swift
//  Challengely
//
//  Created by Yash Lalit on 29/07/25.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    let store: StoreOf<OnboardingStore>
    
    private let screen = UIScreen.main.bounds
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollViewReader { proxy in
                ZStack {
                    
                    background
                    
                    pageView(viewStore)
                    
                }
                .safeAreaInset(edge: .bottom) {
                    bottomBarSection(viewStore, proxy: proxy)
                }
                .safeAreaInset(edge: .top) {
                    topBarSection(viewStore, proxy: proxy)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

//Components
extension OnboardingView {
    
    var background: some View {
        Color(UIColor.systemBackground).ignoresSafeArea()
    }
    func pageView(_ viewStore: ViewStoreOf<OnboardingStore>) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                OnboardingWelcomeView()
                    .frame(width: screen.width)
                    .fixedSize(horizontal: true, vertical: false)
                    .id(0)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    
                IntrestsView(
                    animate: viewStore.currentPage == 1,
                    interests: Binding(
                        get: { viewStore.interests },
                        set: { newValue in
                            for (key, value) in newValue {
                                if value != viewStore.interests[key] {
                                    viewStore.send(.interestTapped(key))
                                }
                            }
                        }
                    )
                )
                .frame(width: screen.width)
                .fixedSize(horizontal: true, vertical: false)
                .id(1)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
                DifficultyView(
                    animate: viewStore.currentPage == 2,
                    difficulty: Binding(
                        get: { viewStore.difficulty },
                        set: { newValue in
                            if let newValue = newValue {
                                viewStore.send(.difficultySelected(newValue))
                            }
                        }
                    )
                )
                .frame(width: screen.width)
                .fixedSize(horizontal: true, vertical: false)
                .id(2)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
                UserNameView(
                    animate: viewStore.currentPage == 3,
                    name: Binding(
                        get: { viewStore.name },
                        set: { viewStore.send(.nameChanged($0)) }
                    )
                )
                .frame(width: screen.width)
                .fixedSize(horizontal: true, vertical: false)
                .id(3)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
                OnboardingCompleteView(
                    animate: viewStore.currentPage == 4
                   )
                    .frame(width: screen.width)
                    .fixedSize(horizontal: true, vertical: false)
                    .id(4)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
        .scrollDisabled(true)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewStore.currentPage)
    }
    
    func backButton(_ viewStore: ViewStoreOf<OnboardingStore>, proxy: ScrollViewProxy) -> some View {
        Button {
            viewStore.send(.backTapped)
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                proxy.scrollTo(viewStore.currentPage, anchor: .center)
            }
        } label: {
            Image(systemName: "chevron.left")
                .renderingMode(.template)
                .foregroundStyle(Color(.label))
                .font(.system(size: 18, weight: .medium))
                .frame(width: 44, height: 44)
                .background(Color(.systemGray6))
                .clipShape(Circle())
        }
        .disabled(viewStore.isAnimating)
    }
    
    func skipButton(_ viewStore: ViewStoreOf<OnboardingStore>) -> some View {
        Button {
            viewStore.send(.skipTapped)
        } label: {
            Text("Skip")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.blue)
        }
        .disabled(viewStore.isAnimating)
    }
    
    func topBarSection(_ viewStore: ViewStoreOf<OnboardingStore>, proxy: ScrollViewProxy) -> some View {
        ZStack {
            
            if viewStore.shouldShowStepper {
                
                Color(.systemBackground).ignoresSafeArea()
                
                HStack {
                    if viewStore.shouldShowBackButton {
                        backButton(viewStore, proxy: proxy)
                    }

                    Spacer()
                    
                    ProgressStepper(
                        currentStep: viewStore.currentPage,
                        totalSteps: 4
                    )
                    .safeAreaPadding()
                    
                    Spacer()
                    
                    if viewStore.shouldShowSkipButton {
                        skipButton(viewStore)
                    }
                }
                .padding(.horizontal, 30)
            }
        }
        .frame(height: 60)
    }
    
    @ViewBuilder
    func validationError(_ viewStore: ViewStoreOf<OnboardingStore>) -> some View {
        if let error = viewStore.validationError {
            Text(error)
                .font(.caption)
                .foregroundColor(.red)
                .padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
    
    func nextButton(_ viewStore: ViewStoreOf<OnboardingStore>, proxy: ScrollViewProxy) -> some View {
        Button {
            viewStore.send(.nextTapped)
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                proxy.scrollTo(viewStore.currentPage, anchor: .center)
            }
        } label: {
            Capsule()
                .fill(viewStore.canProceed ? .blue : .gray)
                .frame(height: 50)
                .overlay {
                    HStack {
                        if viewStore.isAnimating {
                            ProgressView()
                                .progressViewStyle(
                                    CircularProgressViewStyle(tint: .white)
                                )
                                .scaleEffect(0.8)
                        } else {
                            Text(viewStore.nextButtonTitle)
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        }
                    }
                }
        }
        .disabled(!viewStore.canProceed || viewStore.isAnimating)
        .scaleEffect(viewStore.canProceed ? 1.0 : 0.95)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewStore.canProceed)
        .safeAreaPadding()
    }
    
    func bottomBarSection(_ viewStore: ViewStoreOf<OnboardingStore>, proxy: ScrollViewProxy) -> some View {
        VStack(spacing: 12) {
            
            validationError(viewStore)
            
            nextButton(viewStore, proxy: proxy)
           
            
        }
        .background(Color(UIColor.systemBackground))
    }
    
}

#Preview {
    OnboardingView(
        store: Store(initialState: OnboardingStore.State()) {
            OnboardingStore()
        }
    )
}
