import SwiftUI

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = OnboardingViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            ProgressView(value: viewModel.progressFraction)
                .tint(Color.alchePrimary)
                .padding(.horizontal, AlcheSpacing.lg)
                .padding(.top, AlcheSpacing.sm)

            TabView(selection: $viewModel.currentPage) {
                welcomePage.tag(0)
                goalsPage.tag(1)
                tierPage.tag(2)
                completionPage.tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.alcheDefault, value: viewModel.currentPage)
        }
        .background(Color.alcheBackground)
    }

    // MARK: - Page 0: Welcome

    private var welcomePage: some View {
        VStack(spacing: AlcheSpacing.xl) {
            Spacer()

            Image(systemName: "leaf.circle")
                .font(.system(size: 80))
                .foregroundStyle(Color.alchePrimary)

            VStack(spacing: AlcheSpacing.md) {
                Text("Welcome to Alche")
                    .font(.alcheDisplayXL)
                    .foregroundStyle(Color.alchePrimaryText)

                Text("Your longevity, daily.")
                    .font(.alcheDisplayL)
                    .foregroundStyle(Color.alcheAmber)

                Text("Track your wellness, follow personalised protocols, book recovery sessions, and belong to a community that takes the long view.")
                    .font(.alcheBody)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AlcheSpacing.xl)
            }

            Spacer()

            AlcheButton("Get started") {
                viewModel.nextPage()
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.bottom, AlcheSpacing.xl)
        }
    }

    // MARK: - Page 1: Goals

    private var goalsPage: some View {
        VStack(spacing: AlcheSpacing.lg) {
            ScrollView {
                GoalSelectionView(selectedGoals: $viewModel.selectedGoals)
                    .padding(.top, AlcheSpacing.lg)
            }

            VStack(spacing: AlcheSpacing.sm) {
                AlcheButton("Continue", style: .primary) {
                    viewModel.nextPage()
                }
                .disabled(!viewModel.canProceedFromGoals)
                .opacity(viewModel.canProceedFromGoals ? 1 : 0.5)

                AlcheButton("Back", style: .ghost) {
                    viewModel.previousPage()
                }
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.bottom, AlcheSpacing.lg)
        }
    }

    // MARK: - Page 2: Tier Selection

    private var tierPage: some View {
        VStack(spacing: AlcheSpacing.lg) {
            ScrollView {
                VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("Choose your path")
                            .font(.alcheDisplayL)
                            .foregroundStyle(Color.alchePrimaryText)

                        Text("You can always change this later.")
                            .font(.alcheBody)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }

                    ForEach(MembershipTier.allCases, id: \.self) { tier in
                        TierCard(
                            tier: tier,
                            isSelected: viewModel.selectedTier == tier
                        ) {
                            viewModel.selectedTier = tier
                        }
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)
                .padding(.top, AlcheSpacing.lg)
            }

            VStack(spacing: AlcheSpacing.sm) {
                AlcheButton("Continue") {
                    viewModel.nextPage()
                }

                AlcheButton("Back", style: .ghost) {
                    viewModel.previousPage()
                }
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.bottom, AlcheSpacing.lg)
        }
    }

    // MARK: - Page 3: Completion

    private var completionPage: some View {
        VStack(spacing: AlcheSpacing.xl) {
            Spacer()

            Image(systemName: "checkmark.circle")
                .font(.system(size: 80))
                .foregroundStyle(Color.alcheSage)

            VStack(spacing: AlcheSpacing.md) {
                Text("You're all set")
                    .font(.alcheDisplayXL)
                    .foregroundStyle(Color.alchePrimaryText)

                Text("Your personalised experience is ready. Let's start your journey.")
                    .font(.alcheBody)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AlcheSpacing.xl)
            }

            Spacer()

            AlcheButton("Enter Alche", isLoading: viewModel.isLoading) {
                Task {
                    await viewModel.completeOnboarding()
                    appState.hasCompletedOnboarding = true
                }
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.bottom, AlcheSpacing.xl)
        }
    }
}

// MARK: - Tier Card

private struct TierCard: View {
    let tier: MembershipTier
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                HStack {
                    Text(tier.displayName)
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alcheEditorialBlack)

                    Spacer()

                    if tier.monthlyPriceCents > 0 {
                        Text("EUR \(tier.monthlyPriceCents / 100)/mo")
                            .font(.alcheBodyMedium)
                            .foregroundStyle(Color.alchePrimary)
                    } else {
                        Text("Free")
                            .font(.alcheBodyMedium)
                            .foregroundStyle(Color.alcheSage)
                    }
                }

                Text(tierDescription)
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)

                if tier.ledCreditsPerMonth > 0 {
                    HStack(spacing: AlcheSpacing.xs) {
                        Image(systemName: "light.max")
                            .font(.caption2)
                        Text("\(tier.ledCreditsPerMonth) LED sessions/month")
                            .font(.alcheCaption)
                    }
                    .foregroundStyle(Color.alchePrimary)
                }
            }
            .padding(AlcheSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.alchePrimary.opacity(0.06) : Color.alcheSurface)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
            .overlay(
                RoundedRectangle(cornerRadius: AlcheRadii.md)
                    .stroke(isSelected ? Color.alchePrimary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .animation(.alcheQuick, value: isSelected)
    }

    private var tierDescription: String {
        switch tier {
        case .free: "Explore the Alche experience. Browse content, attend community events."
        case .core: "Access LED sessions, daily protocols, and member pricing on products."
        case .pro: "Expanded LED credits, all protocols, priority booking, and full content access."
        case .premium: "Unlimited LED sessions, premium protocols, VIP events, and personal concierge."
        }
    }
}

#Preview {
    OnboardingView()
        .environment(AppState())
}
