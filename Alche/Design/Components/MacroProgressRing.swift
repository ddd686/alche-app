import SwiftUI

struct MacroProgressRing: View {
    let consumed: Int
    let goal: Int
    var ringColor: Color = .alchePrimary
    var trackColor: Color = .alcheWarmGray
    var lineWidth: CGFloat = 14

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return Double(consumed) / Double(goal)
    }

    private var isOverBudget: Bool {
        progress > 1.0
    }

    private var displayColor: Color {
        isOverBudget ? .alcheError : ringColor
    }

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(trackColor, lineWidth: lineWidth)

            // Progress arc
            Circle()
                .trim(from: 0, to: min(progress, 1.0))
                .stroke(
                    displayColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.alcheDefault, value: progress)

            // Center text
            VStack(spacing: AlcheSpacing.xs) {
                Text("\(consumed)")
                    .font(.alcheDisplayL)
                    .foregroundStyle(Color.alchePrimaryText)
                +
                Text(" / \(goal)")
                    .font(.alcheBody)
                    .foregroundStyle(Color.alcheEditorialMuted)

                Text("kcal")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheEditorialMuted)
            }
        }
    }
}

// MARK: - Preview

#Preview("Macro Progress Ring") {
    VStack(spacing: AlcheSpacing.xl) {
        MacroProgressRing(consumed: 1240, goal: 2000)
            .frame(width: 180, height: 180)

        MacroProgressRing(consumed: 2200, goal: 2000)
            .frame(width: 180, height: 180)

        MacroProgressRing(consumed: 0, goal: 2000)
            .frame(width: 120, height: 120)
    }
    .padding(AlcheSpacing.lg)
    .background(Color.alcheBackground)
}
