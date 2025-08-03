//
//  ChatInputView.swift
//  Challengely
//
//  Created by Yash Lalit on 01/08/25.
//

import SwiftUI

struct ChatInputView: View {
    
    @FocusState.Binding var isFocused: Bool
    
    @Binding var text: String
    
    let onSend: ()-> Void
    
    let canSend: Bool
    
    @State private var currentLineCount: Int = 1
    
    @State private var textFieldWidth: CGFloat = 0
    
    @State private var showContextToolbar = true
    
    @State private var showExpandedInput = false
    
    private let textFieldFont: UIFont = .systemFont(ofSize: 16)
    
    private let screen = UIScreen.main.bounds
    
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    
    private var characterCountColor: Color {
        switch text.count {
        case 0..<400: return .green
        case 400..<500: return .orange
        default: return .red
        }
    }
    
    private func updateLineCount(for newText: String, width: CGFloat) {
        guard width > 0 else {
            currentLineCount = 1
            return
        }

        let attributedString = NSAttributedString(string: newText, attributes: [.font: textFieldFont])
        let boundingBox = attributedString.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        let lineHeight = textFieldFont.lineHeight
        let calculatedLines = max(1, Int(ceil(boundingBox.height / lineHeight)))

        if calculatedLines != currentLineCount {
            currentLineCount = calculatedLines
        }
    }
    
    private func limitInputText(for newText: String) {
        if text.count > 500 {
            feedbackGenerator.notificationOccurred(.warning)
            text = String(newText.prefix(500))
        }
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemGray6))
                .ignoresSafeArea()
                .animation(.bouncy, value: text)
            
            VStack(spacing: 0) {
                
                inputField
                
                inputToolbar
 
            }
            .padding()
            
        }
        .fixedSize(horizontal: false, vertical: true)
        .onChange(of: text) { _, newText in
            limitInputText(for: newText)
            updateLineCount(for: newText, width: textFieldWidth)
        }
        .sheet(isPresented: $showExpandedInput) {
            expandedInputField
        }
        
       
    }

}

extension ChatInputView {
    
    var textField: some View {
        TextField("Ask anything...", text: $text, axis: .vertical)
            .font(.system(size: 16))
            .lineLimit(4)
            .overlay(
                GeometryReader { proxy in
                    Color.clear.onAppear {
                        textFieldWidth = proxy.size.width
                    }
                }
            )
            .focused($isFocused)
    }
    
    var textFieldActions: some View {
        
        VStack(spacing: 0) {
            if currentLineCount > 4 {
                Button {
                    showExpandedInput = true
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .renderingMode(.template)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(.systemBlue))
                }
                
                Spacer(minLength: screen.height * 0.02)
                
            }
            
            Spacer()
            if canSend {
                Button(action: {
                    if canSend {
                        onSend()
                    }
                }) {
                    Circle()
                        .fill(.blue)
                        .frame(
                            width: screen.width * 0.1,
                            height: screen.width * 0.1
                        )
                        .overlay(
                            Image(systemName: "arrow.up")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                        )
                }
                
            }

        }
        .transition(.scale.combined(with: .opacity))
    }
    
    var inputField: some View {
        HStack(alignment:.center, spacing: 0){
            
            textField
            
            if !text.isEmpty {
                Spacer(minLength: screen.width * 0.05)
                textFieldActions
                    
            }
            
        }
        .padding(12)
        .animation(.bouncy, value: text)
    }
    
    var inputToolbar: some View {
        HStack {
        
            leadingInputToolbarItems
            
            Spacer()
            
            trailingInputToolbarItems
            
           
            
        }
        .animation(.bouncy, value: text)
    }
    
    var leadingInputToolbarItems: some View {
        Button {
           
        } label: {
            Image(systemName: "plus")
                .foregroundColor(Color(.systemBlue))
                .font(.title)
                .fontWeight(.semibold)
                .frame(width: 35, height: 35)
                .transition(.move(edge: .leading).combined(with: .opacity))
        }
    }
    
    @ViewBuilder
    var trailingInputToolbarItems: some View {
        if text.isEmpty {
            inputActions
        }else {
            charLimitView
        }
    }
    
    var inputActions: some View {
        HStack(spacing: 0) {
            Button {
                
            } label: {
                Circle()
                    .fill(.blue)
                    .frame(
                        width: screen.width * 0.1,
                        height: screen.width * 0.1
                    )
                    .overlay(
                        Image(systemName: "camera.fill")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    )
            }
            .padding(.trailing)

            Button {
                
            } label: {
                Circle()
                    .fill(.blue)
                    .frame(
                        width: screen.width * 0.1,
                        height: screen.width * 0.1
                    )
                    .overlay(
                        Image(systemName: "mic.fill")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    )
            }

        }
        .transition(.move(edge: .trailing).combined(with: .opacity))
    }
    
    var charLimitView: some View {
        Text("\(text.count)/500")
            .foregroundColor(characterCountColor)
            .font(.system(size: 16))
            .transition(
                .move(edge: .bottom)
                .combined(with: .opacity)
            )
    }
    
    var expandedInputField: some View {
        HStack(alignment: .top){
            
            expandedTextField
            
            expandedTextFieldActions
               
        }
        .padding()
    }
    
    var expandedTextField: some View {
        VStack{
            Color.clear.frame(width: 35, height: 35)
            
            TextField("Ask anything...", text: $text, axis: .vertical)
                .font(.system(size: 16))
                .focused($isFocused)
                
        }
    }
    
    var expandedTextFieldActions: some View {
        VStack{
            Button {
                showExpandedInput = false
            } label: {
                Image(systemName: "arrow.down.right.and.arrow.up.left")
                    
                    .renderingMode(.template)
                    .foregroundColor(Color(.systemBlue))
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .frame(width: 35, height: 35)
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
            
            Spacer()
            
            if canSend {
                Button {
                    showExpandedInput = false
                    if canSend {
                        onSend()
                    }
                    
                } label: {
                    Circle()
                        .fill(.blue)
                        .frame(
                            width: screen.width * 0.1,
                            height: screen.width * 0.1
                        )
                        .overlay(
                            Image(systemName: "arrow.up")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                        )
                    
                }
            }
        }
    }
    
}

#Preview {
    struct PreviewWrapper: View {
        @FocusState private var isFocused: Bool
        @State var text = "Hello, this is a test message"
        
        var body: some View {
            VStack {
                Spacer()
                ChatInputView(
                    isFocused: $isFocused,
                    text: $text,
                    onSend: {},
                    canSend: true
                )
                
            }
            .background(Color(.systemBackground))
        }
    }
    return PreviewWrapper()
}
