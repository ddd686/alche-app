import SwiftUI

struct DailyProtocolCard: View {
    let protocolItem: HealthProtocol
    let completedSteps: Int
    let totalSteps: Int

    var body: some View {
        AlcheCard {
            VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                        Text("TODAY'S PROTOCOL")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        Text(protocolItem.name)
                            .font(.alcheSubheading)
                            .foregroundStyle(Color.alcheEditorialBlack)
                    }

                    Spacer()

                    if let goal = protocolItem.goalTag {
                        AlcheTag(text: goal.displayName, color: goalColor(goal))
                    }
                }

                // Progress bar
                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    ProgressView(value: progress)
                        .tint(Color.alcheSage)

                    Text("\(completedSteps) of \(totalSteps) steps completed")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }

                // Next step preview
                if let nextStep = nextUncompletedStep {
                    HStack(spacing: AlcheSpacing.sm) {
                        Image(systemName: stepIcon(nextStep.category))
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alchePrimary)
                            .frame(width: 24, height: 24)
                            .background(Color.alchePrimary.opacity(0.06))
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 2) {
                            Text(nextStep.time)
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                            Text(nextStep.action)
                                .font(.alcheBody)
                                .foregroundStyle(Color.alchePrimaryText)
                        }
                    }
                    .padding(AlcheSpacing.sm)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.alcheWhite)
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
                }
            }
        }
    }

    private var progress: Double {
        guard totalSteps > 0 else { return 0 }
        return Double(completedSteps) / Double(totalSteps)
    }

    private var nextUncompletedStep: ProtocolStep? {
        guard completedSteps < protocolItem.steps.count else { return nil }
        return protocolItem.steps[completedSteps]
    }

    private func goalColor(_ goal: ProtocolGoal) -> Color {
        switch goal {
        case .sleep: .alcheInfo
        case .energy: .alchePrimary
        case .recovery: .alcheSage
        case .glow: .alcheAmber
        case .calm: .alcheSage
        case .gut: .alcheSage
        }
    }

    private func stepIcon(_ category: StepCategory) -> String {
        switch category {
        case .supplement: "pill"
        case .nutrition: "fork.knife"
        case .movement: "figure.walk"
        case .light: "sun.max"
        case .mindfulness: "brain.head.profile"
        case .sleep: "moon"
        case .hydration: "drop"
        }
    }
}

#Preview {
    DailyProtocolCard(
        protocolItem: .preview,
        completedSteps: 2,
        totalSteps: 5
    )
    .padding()
    .background(Color.alcheBackground)
}
