import SwiftUI

struct MacroProgressBar: View {
    let label: String
    let current: Double
    let goal: Double
    var color: Color = .alchePastelSage
    var unit: String = "g"

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return current / goal
    }

    private var isOverBudget: Bool {
        progress > 1.0
    }

    private var displayColor: Color {
        isOverBudget ? .alcheError : color
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            HStack {
                Text(label)
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alchePrimaryText)

                Spacer()

                Text("\(Int(current))\(unit) / \(Int(goal))\(unit)")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheEditorialMuted)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Track — sharp rectangle, warmGray
                    Rectangle()
                        .fill(Color.alcheWarmGray)
                        .frame(height: 2)

                    // Fill — sharp rectangle
                    Rectangle()
                        .fill(displayColor)
                        .frame(width: geo.size.width * min(progress, 1.0), height: 2)
                        .animation(.alcheDefault, value: progress)
                }
            }
            .frame(height: 2)
        }
    }
}

// MARK: - Preview

#Preview("Macro Progress Bars") {
    VStack(spacing: AlcheSpacing.lg) {
        MacroProgressBar(label: "Protein", current: 82, goal: 130, color: .alchePastelSage)
        MacroProgressBar(label: "Carbs", current: 145, goal: 220, color: .alcheEditorialAccent)
        MacroProgressBar(label: "Fat", current: 38, goal: 65, color: .alchePrimary)
        MacroProgressBar(label: "Over budget", current: 250, goal: 220, color: .alcheEditorialAccent)
    }
    .padding(AlcheSpacing.lg)
    .background(Color.alcheBackground)
}
