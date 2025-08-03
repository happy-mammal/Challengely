//
//  StepperProgressView.swift
//  Challengely
//
//  Created by Yash Lalit on 29/07/25.
//

import SwiftUI

struct ProgressStepper: View {
    let currentStep: Int
    let totalSteps: Int

    private var progress: CGFloat {
        guard totalSteps > 0 else { return 0 }
        return min(max(CGFloat(currentStep) / CGFloat(totalSteps), 0), 1)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
               
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.secondarySystemFill))
                    .frame(height: 8)

                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: progress >= 1.0 ? [Color.green, Color.mint] : [Color.blue, Color.cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(0, geometry.size.width * progress), height: 8)
                    .shadow(
                        color: progress >= 1.0 ? Color.green.opacity(0.3) : Color.blue.opacity(0.3),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
                    .animation(.bouncy(duration: 0.5), value: progress)
            }
        }
        .frame(height: 8)
        .padding(.horizontal)
    }
}

#Preview {
    @Previewable @State var currentStep = 3
    
    VStack(spacing: 30) {
        ProgressStepper(currentStep: currentStep, totalSteps: 3)
        
        Button("Click Me") {
            currentStep -= 1
        }
    }
    .padding()
}
