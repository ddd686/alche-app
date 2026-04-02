import SwiftUI

struct FocusAreaRevealView: View {
    @Environment(AppState.self) private var appState

    @State private var headlineVisible = false
    @State private var visibleGoalCount = 0
    @State private var ctaVisible = false

    private let service: QuestionnaireServiceProtocol = MockQuestionnaireService()

    private var recommendedGoals: [WellnessGoal] {
        let goals = service.computeGoalRecommendations(from: appState.userWellnessProfile.quickScanAnswers)
        // Cap at 3 goals
        return Array(goals.prefix(3))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: AlcheSpacing.xl) {
                    // Headline
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("YOUR FOCUS AREAS")
                            .font(.alcheOverline)
                            .tracking(2)
                            .foregroundStyle(Color.alcheEditorialMuted)

                        Text("Your Alchemy,\nRevealed")
                            .font(.alcheDisplayL)
                            .foregroundStyle(Color.alchePrimaryText)
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                    .padding(.top, AlcheSpacing.xxl)
                    .opacity(headlineVisible ? 1 : 0)
                    .offset(y: headlineVisible ? 0 : 12)

                    // Goal cards
                    VStack(spacing: AlcheSpacing.md) {
                        ForEach(Array(recommendedGoals.enumerated()), id: \.element.id) { index, goal in
                            goalCard(goal: goal, index: index)
                                .opacity(index < visibleGoalCount ? 1 : 0)
                                .offset(y: index < visibleGoalCount ? 0 : 16)
                                .animation(
                                    .easeOut(duration: 0.5).delay(Double(index) * 0.3),
                                    value: visibleGoalCount
                                )
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)

                    Spacer(minLength: AlcheSpacing.xxl)
                }
            }

            // CTA
            if ctaVisible {
                VStack(spacing: 0) {
                    Divider()
                        .foregroundStyle(Color.alcheEditorialAccent.opacity(0.3))

                    AlcheButton("Continue", style: .primary, isFullWidth: true) {
                        // Save recommended goals to profile
                        appState.userWellnessProfile.selectedGoals = Set(recommendedGoals)
                        appState.onboardingStep = .glowScanInvitation
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                    .padding(.vertical, AlcheSpacing.md)
                }
                .background(Color.alcheBackground)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(Color.alcheBackground)
        .onAppear {
            animateReveal()
        }
    }

    // MARK: - Goal Card

    private func goalCard(goal: WellnessGoal, index: Int) -> some View {
        AlcheCard(variant: .default) {
            VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                // Top row: index + goal name
                HStack(alignment: .firstTextBaseline) {
                    Text(goal.index)
                        .font(.alcheOverlineTiny)
                        .foregroundStyle(Color.alcheEditorialMuted)

                    Spacer()

                    Image(systemName: iconForGoal(goal))
                        .font(.alcheBody)
                        .foregroundStyle(Color.alchePrimary)
                }

                // Goal display name
                Text(goal.displayName)
                    .font(.alcheDisplayS)
                    .foregroundStyle(Color.alcheCardText)

                // User feeling quote
                HStack(spacing: AlcheSpacing.sm) {
                    Rectangle()
                        .fill(Color.alchePrimary)
                        .frame(width: 2)

                    Text("\"\(goal.userFeeling)\"")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheEditorialMuted)
                        .italic()
                }
                .fixedSize(horizontal: false, vertical: true)

                // Code tag
                Text(goal.codeTag)
                    .font(.alcheOverlineTiny)
                    .tracking(1)
                    .foregroundStyle(Color.alcheEditorialMuted)
            }
        }
    }

    // MARK: - Animation

    private func animateReveal() {
        // Headline fades in first
        withAnimation(.easeOut(duration: 0.5)) {
            headlineVisible = true
        }

        // Then goal cards stagger in
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(600))
            withAnimation {
                visibleGoalCount = recommendedGoals.count
            }

            // CTA appears after all cards
            let totalDelay = 600 + (recommendedGoals.count * 300) + 300
            try? await Task.sleep(for: .milliseconds(totalDelay))
            withAnimation(.alcheDefault) {
                ctaVisible = true
            }
        }
    }

    // MARK: - Helpers

    private func iconForGoal(_ goal: WellnessGoal) -> String {
        switch goal {
        case .deepRecovery: "moon.stars.fill"
        case .stressResilience: "leaf.fill"
        case .innerBalance: "circle.grid.cross.fill"
        case .radiantDefense: "sparkles"
        case .cellularVitality: "bolt.heart.fill"
        }
    }
}

#Preview {
    let state = AppState()
    // Simulate having answers for Q1
    state.userWellnessProfile.quickScanAnswers = [
        QuestionnaireAnswer(questionId: "q1", selectedOptionIds: ["energy", "skin", "stress"])
    ]

    return FocusAreaRevealView()
        .environment(state)
}
