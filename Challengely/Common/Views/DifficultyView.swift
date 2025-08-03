import SwiftUI

struct DifficultyView: View {
    let animate: Bool
    @Binding var difficulty: Difficulty?

    @Namespace private var animation
    @State private var animateLocal = false

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 12) {
                Text("Set Your Challenge Level")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .opacity(animateLocal ? 1 : 0)
                    .offset(y: animateLocal ? 0 : 20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateLocal)

                Text("Choose how challenging you want your daily activities to be")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .opacity(animateLocal ? 1 : 0)
                    .offset(y: animateLocal ? 0 : 20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateLocal)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            VStack(spacing: 16) {
                ForEach(Array(Difficulty.allCases.enumerated()), id: \.element) { index, level in
                    SelectableRow(
                        difficulty: level,
                        isSelected: difficulty == level,
                        animation: animation
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            difficulty = level
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .opacity(animateLocal ? 1 : 0)
                    .offset(x: animateLocal ? 0 : -50)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3 + Double(index) * 0.15), value: animateLocal)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            Spacer(minLength: 30)
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    animateLocal = true
                }
            } else {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    animateLocal = false
                }
            }
        }
    }
}



#Preview {
    @Previewable @State var isActive = false
    @Previewable @State var difficulty: Difficulty? = nil
    
    ZStack {
        Color(.systemBackground).ignoresSafeArea()

        DifficultyView(animate: isActive, difficulty: $difficulty)
        
        Button("Toggle", action: { isActive.toggle() })
        
    }
    
}
