//
//  ChatAssistantView.swift
//  Challengely
//
//  Created by Yash Lalit on 01/08/25.
//

import SwiftUI
import ComposableArchitecture

struct ChatAssistantView: View {
    let store: StoreOf<ChatStore>
    let onBack: () -> Void
    
    @FocusState var isInputFocused
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                ChatMessagingView(
                    messages: viewStore.messages,
                    showLoading: viewStore.isLoading,
                    suggestions: viewStore.currentSuggestions,
                    onSuggestionTapped: { suggestion in
                        viewStore.send(.suggestionTapped(suggestion))
                    }
                )
            }
            .onTapGesture {
                isInputFocused = false
            }
            .onAppear {
                isInputFocused = true
                viewStore.send(.onAppear)
            }
            .refreshable {
                viewStore.send(.loadMessages)
            }
            .safeAreaInset(edge: .top, content: {
                ZStack {
                    Color(.systemGray6).ignoresSafeArea()
                    
                    VStack(spacing: 8) {
                        Text("Challengely")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color(.label))
                        
                        HStack {
                            Button {
                                onBack()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .renderingMode(.template)
                                    .foregroundStyle(Color(.systemBlue))
                                    .font(.system(size: 18, weight: .medium))
                                    .frame(width: 44, height: 44)
                                    .background(Color(.systemGray5))
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            Text("AI Assistant")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(.secondaryLabel))
                            
                            Spacer()
                            
                            // Placeholder for balance
                            Color.clear
                                .frame(width: 44, height: 44)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 8)
                }
                .fixedSize(horizontal: false, vertical: true)
            })
            .safeAreaInset(edge: .bottom) {
                ChatInputView(
                    isFocused: $isInputFocused,
                    text: Binding(
                        get: { viewStore.userInput },
                        set: { viewStore.send(.userInputChanged($0)) }
                    ),
                    onSend: { viewStore.send(.onSend) },
                    canSend: viewStore.canSend
                )
            }
        }
    }
}

#Preview {
    ChatAssistantView(
        store: Store(initialState: ChatStore.State()) {
            ChatStore()
        },
        onBack: {}
    )
}
