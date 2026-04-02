import SwiftUI

struct PersonalizationLevelView: View {
    @State private var profile: UserWellnessProfile?
    @State private var isLoading = false

    private let service: QuestionnaireServiceProtocol = MockQuestionnaireService()
    private let userId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    var body: some View {
        AlcheCard(variant: .flat) {
            VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                        Text("YOUR ALCHE PROFILE")
                            .font(.alcheOverline)
                            .tracking(1)
                            .foregroundStyle(Color.alcheEditorialMuted)

                        Text("\(personalizationLevel)% personalized")
                            .font(.alcheSubheading)
                            .foregroundStyle(Color.alcheEditorialBlack)
                    }

                    Spacer()

                    // Percentage circle
                    ZStack {
                        Circle()
                            .stroke(Color.alcheEditorialBlack.opacity(0.06), lineWidth: 3)

                        Circle()
                            .trim(from: 0, to: Double(personalizationLevel) / 100.0)
                            .stroke(Color.alchePrimary, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .rotationEffect(.degrees(-90))

                        Text("\(personalizationLevel)")
                            .font(.alcheMono)
                            .foregroundStyle(Color.alchePrimary)
                    }
                    .frame(width: 44, height: 44)
                }

                // Divider
                Rectangle()
                    .fill(Color.alcheEditorialBlack.opacity(0.06))
                    .frame(height: 1)

                // Data layers checklist
                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    dataLayerRow(
                        name: "Quick Scan",
                        isComplete: profile?.hasCompletedQuickScan ?? false
                    )
                    dataLayerRow(
                        name: "GlowScan",
                        isComplete: false // Placeholder — not connected yet
                    )
                    dataLayerRow(
                        name: "Deep Profile",
                        isComplete: profile?.hasCompletedDeepProfile ?? false
                    )
                    dataLayerRow(
                        name: "Apple Health",
                        isComplete: false
                    )
                    dataLayerRow(
                        name: "Blood Panel",
                        isComplete: false
                    )
                }
            }
        }
        .task {
            await loadProfile()
        }
    }

    // MARK: - Data Layer Row

    @ViewBuilder
    private func dataLayerRow(name: String, isComplete: Bool) -> some View {
        HStack(spacing: AlcheSpacing.sm) {
            Image(systemName: isComplete ? "checkmark.square.fill" : "square")
                .font(.system(size: 14))
                .foregroundStyle(isComplete ? Color.alchePrimary : Color.alcheEditorialMuted)

            Text(name)
                .font(.alcheCaption)
                .foregroundStyle(isComplete ? Color.alchePrimaryText : Color.alcheEditorialMuted)

            Spacer()

            if isComplete {
                Text("COMPLETE")
                    .font(.alcheOverlineTiny)
                    .tracking(0.5)
                    .foregroundStyle(Color.alchePastelSage)
            }
        }
    }

    // MARK: - Computed

    private var personalizationLevel: Int {
        profile?.personalizationLevel ?? 0
    }

    // MARK: - Load

    private func loadProfile() async {
        isLoading = true
        do {
            profile = try await service.userProfile(userId: userId)
        } catch {
            // Silently fail — shows 0% if profile can't load
        }
        isLoading = false
    }
}

// MARK: - Preview

#Preview {
    VStack {
        PersonalizationLevelView()
            .padding(.horizontal, AlcheSpacing.lg)
    }
    .background(Color.alcheBackground)
}
