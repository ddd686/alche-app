import SwiftUI

// MARK: - Supplement Recommendation View

/// Shows the user's personalized supplement stack based on selected goals.
/// Accessible from Profile and from the Focus Area Reveal screen.
struct SupplementRecommendationView: View {
    @State private var viewModel = SupplementRecommendationViewModel()
    var initialGoals: Set<WellnessGoal> = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                // Data source indicator
                HStack {
                    DataSourceIndicator(isMock: true)
                    Spacer()
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Title
                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("Your Supplement\nStack")
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)

                    // Selected goals summary
                    if !viewModel.selectedGoals.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AlcheSpacing.sm) {
                                ForEach(Array(viewModel.selectedGoals).sorted(by: { $0.rawValue < $1.rawValue }), id: \.id) { goal in
                                    AlcheTag(
                                        text: goal.displayName,
                                        color: .alchePrimary,
                                        variant: .filled
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, AlcheSpacing.xxl)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: AlcheSpacing.md) {
                        Text(error)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await viewModel.load() }
                        }
                        .font(.alcheBody)
                        .foregroundStyle(Color.alchePrimary)
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                } else {
                    supplementContent
                }
            }
            .padding(.top, AlcheSpacing.md)
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Supplements")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if initialGoals.isEmpty {
                await viewModel.load()
            } else {
                await viewModel.loadWithGoals(initialGoals)
            }
        }
    }

    // MARK: - Supplement Content

    private var supplementContent: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.xl) {
            // Foundation supplements
            if !viewModel.foundationSupplements.isEmpty {
                supplementSection(
                    title: "FOUNDATION",
                    subtitle: "Shared across your goals",
                    supplements: viewModel.foundationSupplements
                )
            }

            // Goal-specific supplements
            if !viewModel.goalSpecificSupplements.isEmpty {
                supplementSection(
                    title: "GOAL-SPECIFIC",
                    subtitle: "Targeted for your selected focus areas",
                    supplements: viewModel.goalSpecificSupplements
                )
            }

            // Dose-stacking warnings
            if !viewModel.applicableStackingRules.isEmpty {
                stackingWarningsSection
            }

            // Timing conflicts
            if !viewModel.applicableTimingConflicts.isEmpty {
                timingConflictsSection
            }

            // Disclaimer
            disclaimerSection
        }
    }

    // MARK: - Supplement Section

    private func supplementSection(
        title: String,
        subtitle: String,
        supplements: [Supplement]
    ) -> some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.md) {
            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                Text(title)
                    .font(.alcheOverline)
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(Color.alcheEditorialMuted)

                Text(subtitle)
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheEditorialMuted)
            }
            .padding(.horizontal, AlcheSpacing.lg)

            ForEach(supplements, id: \.id) { supplement in
                SupplementCard(supplement: supplement)
                    .padding(.horizontal, AlcheSpacing.lg)
            }
        }
    }

    // MARK: - Stacking Warnings

    private var stackingWarningsSection: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.md) {
            HStack(spacing: AlcheSpacing.sm) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheWarning)

                Text("DOSE-STACKING NOTES")
                    .font(.alcheOverline)
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(Color.alcheEditorialMuted)
            }
            .padding(.horizontal, AlcheSpacing.lg)

            ForEach(Array(viewModel.applicableStackingRules.enumerated()), id: \.offset) { _, rule in
                AlcheCard(variant: .flat) {
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        HStack(spacing: AlcheSpacing.sm) {
                            Image(systemName: "pills")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheWarning)

                            Text(rule.supplementName)
                                .font(.alcheSubheading)
                                .foregroundStyle(Color.alchePrimaryText)
                        }

                        Text("Max daily: \(rule.maxDailyDose)")
                            .font(.alcheMono)
                            .foregroundStyle(Color.alchePrimary)

                        Text(rule.note)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheEditorialMuted)
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)
            }
        }
    }

    // MARK: - Timing Conflicts

    private var timingConflictsSection: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.md) {
            HStack(spacing: AlcheSpacing.sm) {
                Image(systemName: "clock.arrow.2.circlepath")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheInfo)

                Text("TIMING GUIDANCE")
                    .font(.alcheOverline)
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(Color.alcheEditorialMuted)
            }
            .padding(.horizontal, AlcheSpacing.lg)

            ForEach(Array(viewModel.applicableTimingConflicts.enumerated()), id: \.offset) { _, conflict in
                AlcheCard(variant: .flat) {
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        HStack(spacing: AlcheSpacing.sm) {
                            Text(conflict.0)
                                .font(.alcheBodyMedium)
                                .foregroundStyle(Color.alchePrimaryText)

                            Text("+")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheEditorialMuted)

                            Text(conflict.1)
                                .font(.alcheBodyMedium)
                                .foregroundStyle(Color.alchePrimaryText)
                        }

                        Text(conflict.2)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheEditorialMuted)
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)
            }
        }
    }

    // MARK: - Disclaimer

    private var disclaimerSection: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
            Rectangle()
                .fill(Color.alcheEditorialBlack.opacity(0.06))
                .frame(height: 1)
                .padding(.horizontal, AlcheSpacing.lg)

            Text("This supplement overview is for informational purposes only. It does not constitute medical advice, diagnosis, or treatment. Always consult a qualified healthcare practitioner before starting any supplement regimen.")
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheEditorialMuted)
                .padding(.horizontal, AlcheSpacing.lg)
        }
    }
}

// MARK: - Supplement Card

private struct SupplementCard: View {
    let supplement: Supplement

    var body: some View {
        AlcheCard {
            VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                // Top row: name + badges
                HStack(alignment: .top) {
                    Text(supplement.name)
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alchePrimaryText)

                    Spacer()

                    HStack(spacing: AlcheSpacing.sm) {
                        evidenceBadge

                        if supplement.isEULegal {
                            euLegalBadge
                        }
                    }
                }

                // Dosage
                Text(supplement.typicalDosage)
                    .font(.alcheMono)
                    .foregroundStyle(Color.alchePrimary)

                // Mechanism
                Text(supplement.mechanism)
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheEditorialMuted)
                    .lineLimit(2)
            }
        }
    }

    // MARK: - Evidence Badge

    private var evidenceBadge: some View {
        Text(supplement.evidence.displayName)
            .font(.alcheOverlineTiny)
            .textCase(.uppercase)
            .tracking(0.5)
            .foregroundStyle(evidenceColor)
            .padding(.horizontal, AlcheSpacing.sm)
            .padding(.vertical, AlcheSpacing.xs)
            .background(evidenceColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
            .overlay(
                RoundedRectangle(cornerRadius: AlcheRadii.sm)
                    .stroke(evidenceColor.opacity(0.3), lineWidth: 1)
            )
    }

    private var evidenceColor: Color {
        switch supplement.evidence {
        case .strong:
            Color.alcheSuccess
        case .moderateStrong:
            Color.alcheSuccess.opacity(0.8)
        case .moderate:
            Color.alcheWarning
        case .emerging:
            Color.alcheEditorialMuted
        }
    }

    // MARK: - EU Legal Badge

    private var euLegalBadge: some View {
        HStack(spacing: 2) {
            Image(systemName: "checkmark")
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(Color.alcheSuccess)

            Text("EU")
                .font(.alcheOverlineTiny)
                .foregroundStyle(Color.alcheSuccess)
        }
        .padding(.horizontal, AlcheSpacing.xs + 2)
        .padding(.vertical, AlcheSpacing.xs)
        .background(Color.alcheSuccess.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
    }
}

// MARK: - Preview

#Preview("Supplement Stack") {
    NavigationStack {
        SupplementRecommendationView()
    }
}

#Preview("With Goals") {
    NavigationStack {
        SupplementRecommendationView(
            initialGoals: [.deepRecovery, .stressResilience]
        )
    }
}
