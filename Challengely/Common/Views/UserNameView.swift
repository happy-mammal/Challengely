//
//  NameEntryView.swift
//  Challengely
//
//  Created by Yash Lalit on 29/07/25.
//
import SwiftUI

struct UserNameView: View {
    let animate: Bool
    @Binding var name: String

    @FocusState.Binding var isFocused: Bool
    @State private var animateLocal = false

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 12) {
                Text("Let’s get to know you")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .opacity(animateLocal ? 1 : 0)
                    .offset(y: animateLocal ? 0 : 10)
                    .animation(.easeOut.delay(0.1), value: animateLocal)

                Text("What should we call you?")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .opacity(animateLocal ? 1 : 0)
                    .offset(y: animateLocal ? 0 : 10)
                    .animation(.easeOut.delay(0.2), value: animateLocal)
            }

            ZStack(alignment: .trailing) {
                TextField("", text: $name)
                    .focused($isFocused)
                    .padding()
                    .font(.title2.weight(.semibold))
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(isFocused ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                    )
                    .overlay(
                        HStack {
                            Spacer()
                            if !name.isEmpty {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        name = ""
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 22, weight: .regular))
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 12)
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
                    .tint(.blue)
                    .animation(.easeInOut(duration: 0.25), value: name)
            }

            Spacer()
                
        }
        .padding()
        .onChange(of: animate) { _, newValue in
            if newValue {
                if !animateLocal {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        animateLocal = true
                    }

                }
            }

        }
    }
}



#Preview {
    @Previewable @State var name: String = ""
    @Previewable @FocusState var isFocused: Bool
    UserNameView(animate: true, name: $name, isFocused: $isFocused)
}
