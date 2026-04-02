import SwiftUI

// MARK: - Goal Selection View

/// Embeddable goal selection content using the new 5 WellnessGoal macro goals.
/// Parent (OnboardingView) provides the ScrollView wrapper and Continue/Back buttons.
struct GoalSelectionView: View {
    @Binding var selectedGoals: Set<ProtocolGoal>

    @State private var appeared = false
    @State private var selectedWellnessGoals: Set<WellnessGoal> = []

    private let goalService: GoalServiceProtocol = MockGoalService()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Data source indicator
            HStack {
                DataSourceIndicator(isMock: true)
                Spacer()
            }
            .padding(.horizontal, AlcheSpacing.xl)
            .padding(.top, AlcheSpacing.md)

            heroSection
            goalCards
        }
        .onAppear {
            // Sync legacy goals to wellness goals on appear
            syncFromLegacy()
            withAnimation(.easeOut(duration: 0.6)) {
                appeared = true
            }
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
            Text("Your Focus\nAreas")
                .font(.alcheDisplayL)
                .foregroundStyle(Color.alchePrimaryText)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)

            HStack(spacing: AlcheSpacing.sm) {
                Image(systemName: "terminal")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.alcheEditorialMuted)

                Text("> SELECT 1\u{2013}3 PROTOCOLS")
                    .font(.alcheOverlineTiny)
                    .textCase(.uppercase)
                    .tracking(1.5)
                    .foregroundStyle(Color.alcheEditorialMuted)

                Spacer()

                Text("\(selectedWellnessGoals.count)/3")
                    .font(.alcheMono)
                    .foregroundStyle(selectedWellnessGoals.isEmpty ? Color.alcheEditorialMuted : Color.alchePrimary)
            }
        }
        .padding(.horizontal, AlcheSpacing.xl)
        .padding(.top, AlcheSpacing.xl)
        .padding(.bottom, AlcheSpacing.xl)
    }

    // MARK: - Goal Cards

    private var goalCards: some View {
        VStack(spacing: AlcheSpacing.lg) {
            ForEach(Array(WellnessGoal.allCases.enumerated()), id: \.element.id) { index, goal in
                WellnessGoalCard(
                    goal: goal,
                    isSelected: selectedWellnessGoals.contains(goal)
                ) {
                    withAnimation(.alcheDefault) {
                        toggleGoal(goal)
                    }
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)
                .animation(
                    .easeOut(duration: 0.6).delay(0.1 + Double(index) * 0.08),
                    value: appeared
                )
            }
        }
        .padding(.horizontal, AlcheSpacing.xl)
    }

    // MARK: - Goal Toggle

    private func toggleGoal(_ goal: WellnessGoal) {
        if selectedWellnessGoals.contains(goal) {
            selectedWellnessGoals.remove(goal)
        } else if selectedWellnessGoals.count < 3 {
            selectedWellnessGoals.insert(goal)
        }
        syncToLegacy()
    }

    /// Sync WellnessGoal selections back to the legacy ProtocolGoal binding
    private func syncToLegacy() {
        var legacyGoals = Set<ProtocolGoal>()
        for goal in selectedWellnessGoals {
            if let legacy = goal.legacyGoalTag {
                legacyGoals.insert(legacy)
            }
        }
        selectedGoals = legacyGoals
    }

    /// Sync from legacy ProtocolGoal binding into WellnessGoal set on appear
    private func syncFromLegacy() {
        var wellness = Set<WellnessGoal>()
        for legacyGoal in selectedGoals {
            for wg in WellnessGoal.allCases {
                if wg.legacyGoalTag == legacyGoal {
                    wellness.insert(wg)
                }
            }
        }
        selectedWellnessGoals = wellness
    }
}

// MARK: - Wellness Goal Card

private struct WellnessGoalCard: View {
    let goal: WellnessGoal
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                // Top row: index + title
                HStack(alignment: .firstTextBaseline) {
                    Text(goal.index)
                        .font(.alcheOverline)
                        .textCase(.uppercase)
                        .tracking(1)
                        .foregroundStyle(isSelected ? Color.alchePrimary : Color.alcheEditorialMuted)

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.alchePrimary)
                            .transition(.opacity.combined(with: .scale))
                    }
                }

                // Goal name
                Text(goal.displayName)
                    .font(.alcheSubheading)
                    .foregroundStyle(Color.alchePrimaryText)

                // User feeling quote
                Text("\"\(goal.userFeeling)\"")
                    .font(.alcheCaption)
                    .italic()
                    .foregroundStyle(Color.alcheEditorialMuted)

                // Divider
                Rectangle()
                    .fill(isSelected ? Color.alchePrimary.opacity(0.3) : Color.alcheEditorialBlack.opacity(0.06))
                    .frame(height: 1)
                    .padding(.vertical, AlcheSpacing.xs)

                // Code tag
                Text(goal.codeTag)
                    .font(.alcheOverlineTiny)
                    .textCase(.uppercase)
                    .tracking(1)
                    .foregroundStyle(isSelected ? Color.alchePrimary : Color.alcheEditorialMuted)
            }
            .padding(AlcheSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.alchePrimary.opacity(0.04) : Color.alcheSurface)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
            .overlay(
                RoundedRectangle(cornerRadius: AlcheRadii.md)
                    .stroke(
                        isSelected ? Color.alchePrimary : Color.alcheEditorialBlack.opacity(0.08),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.alcheDefault, value: isSelected)
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        GoalSelectionView(
            selectedGoals: .constant([.glow, .calm])
        )
    }
    .background(Color.alcheBackground)
}
