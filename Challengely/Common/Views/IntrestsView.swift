//
//  InterestsView.swift
//  Challengely
//
//  Created by Yash Lalit on 29/07/25.
//

import SwiftUI

struct IntrestsView: View {
    let animate: Bool
    @Binding var interests: [Interest: Bool]

    @State private var animateLocal = false
    @State private var selectedCount = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("Choose your interests")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .opacity(animateLocal ? 1 : 0)
                        .offset(y: animateLocal ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateLocal)

                    Text("Select at least one to personalize your challenges")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(.secondaryLabel))
                        .padding(.horizontal)
                        .opacity(animateLocal ? 1 : 0)
                        .offset(y: animateLocal ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateLocal)
                    
                    // Selection counter
                    if selectedCount > 0 {
                        Text("\(selectedCount) selected")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Capsule())
                            .transition(.scale.combined(with: .opacity))
                    }
                }

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ],
                    spacing: 16
                ) {
                    ForEach(Array(interests.keys.enumerated()), id: \.element) { index, item in
                        SelectableTile(
                            isSelected: interests[item] ?? false,
                            icon: item.icon,
                            title: item.name,
                            color: item.color
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                interests[item]!.toggle()
                                selectedCount = interests.values.filter { $0 }.count
                            }
                        }
                        .opacity(animateLocal ? 1 : 0)
                        .offset(y: animateLocal ? 0 : 30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3 + Double(index) * 0.1), value: animateLocal)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Spacer(minLength: 40)
            }
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                selectedCount = interests.values.filter { $0 }.count
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    animateLocal = true
                }
            } else {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    animateLocal = false
                }
            }
        }
        .onChange(of: interests) { _, newInterests in
            selectedCount = newInterests.values.filter { $0 }.count
        }
        .scrollIndicators(.hidden)
    }
}



#Preview {
    @Previewable @State var interests = Dictionary(
        uniqueKeysWithValues: Interest.allCases.map { ($0, false) }
    )
    
    IntrestsView(animate: true, interests: $interests)
}

