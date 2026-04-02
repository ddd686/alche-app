import SwiftUI

struct SubscriptionPaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTier: MembershipTier = .core
    @State private var isProcessing = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AlcheSpacing.xl) {
                    // Hero
                    VStack(spacing: AlcheSpacing.md) {
                        Image(systemName: "leaf.circle")
                            .font(.system(size: 56))
                            .foregroundStyle(Color.alchePrimary)

                        Text("Unlock your full potential")
                            .font(.alcheDisplayL)
                            .foregroundStyle(Color.alchePrimaryText)
                            .multilineTextAlignment(.center)

                        Text("Choose the plan that fits your wellness journey")
                            .font(.alcheBody)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, AlcheSpacing.lg)

                    // Founding member banner
                    HStack(spacing: AlcheSpacing.sm) {
                        Image(systemName: "star.circle.fill")
                            .foregroundStyle(Color.alcheAmber)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Founding member pricing")
                                .font(.alcheBodyMedium)
                                .foregroundStyle(Color.alchePrimaryText)
                            Text("Lock in EUR 19/month for life. Limited availability.")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                        }
                    }
                    .padding(AlcheSpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.alcheAmber.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    .padding(.horizontal, AlcheSpacing.lg)

                    // Tier cards
                    VStack(spacing: AlcheSpacing.md) {
                        ForEach(MembershipTier.allCases, id: \.self) { tier in
                            PaywallTierCard(
                                tier: tier,
                                isSelected: selectedTier == tier,
                                isFoundingPrice: tier == .core
                            ) {
                                selectedTier = tier
                            }
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)

                    // Features comparison
                    VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                        Text("WHAT'S INCLUDED")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        FeatureRow(feature: "LED sessions", free: "Pay per session", core: "2/month", pro: "8/month", premium: "Unlimited")
                        FeatureRow(feature: "Daily protocols", free: "1 sample", core: "All", pro: "All", premium: "All + custom")
                        FeatureRow(feature: "Content access", free: "Free articles", core: "All articles", pro: "All + video", premium: "Everything")
                        FeatureRow(feature: "Member pricing", free: "—", core: "10% off", pro: "15% off", premium: "15% off")
                        FeatureRow(feature: "Priority booking", free: "—", core: "—", pro: "Yes", premium: "Yes + VIP")
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }
                .padding(.bottom, 100) // Space for bottom button
            }
            .background(Color.alcheBackground)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: AlcheSpacing.sm) {
                    if selectedTier != .free {
                        AlcheButton("Subscribe to \(selectedTier.displayName)", isLoading: isProcessing) {
                            // TODO: Wire to StoreKit 2
                            isProcessing = true
                            Task {
                                try? await Task.sleep(for: .seconds(1.5))
                                isProcessing = false
                                dismiss()
                            }
                        }
                    }

                    if selectedTier == .free {
                        AlcheButton("Continue with Free", style: .secondary) {
                            dismiss()
                        }
                    }

                    Text("Cancel anytime. Recurring billing.")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
                .padding(AlcheSpacing.lg)
                .background(.ultraThinMaterial)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip") { dismiss() }
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
    }
}

// MARK: - Paywall Tier Card

private struct PaywallTierCard: View {
    let tier: MembershipTier
    let isSelected: Bool
    let isFoundingPrice: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    HStack(spacing: AlcheSpacing.sm) {
                        Text(tier.displayName)
                            .font(.alcheSubheading)
                            .foregroundStyle(Color.alchePrimaryText)

                        if isFoundingPrice {
                            Text("Founding")
                                .font(.alcheOverline)
                                .foregroundStyle(Color.alcheAmber)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.alcheAmber.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }

                    Text("\(tier.ledCreditsPerMonth) LED sessions/month")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }

                Spacer()

                if tier.monthlyPriceCents > 0 {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("EUR \(tier.monthlyPriceCents / 100)")
                            .font(.alcheSubheading)
                            .foregroundStyle(Color.alchePrimary)
                        Text("/month")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                } else {
                    Text("Free")
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alcheSage)
                }

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.alcheSubheading)
                    .foregroundStyle(isSelected ? Color.alchePrimary : Color.alcheWarmGray)
                    .padding(.leading, AlcheSpacing.sm)
            }
            .padding(AlcheSpacing.md)
            .background(isSelected ? Color.alchePrimary.opacity(0.06) : Color.alcheWarmGray.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
            .overlay(
                RoundedRectangle(cornerRadius: AlcheRadii.md)
                    .stroke(isSelected ? Color.alchePrimary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Feature Row

private struct FeatureRow: View {
    let feature: String
    let free: String
    let core: String
    let pro: String
    let premium: String

    var body: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text(feature)
                .font(.alcheCaption)
                .foregroundStyle(Color.alchePrimaryText)

            HStack(spacing: AlcheSpacing.xs) {
                featurePill(free, tier: "Free")
                featurePill(core, tier: "Core")
                featurePill(pro, tier: "Pro")
                featurePill(premium, tier: "Prem")
            }
        }
        .padding(.vertical, AlcheSpacing.xs)
    }

    @ViewBuilder
    private func featurePill(_ value: String, tier: String) -> some View {
        VStack(spacing: 2) {
            Text(tier)
                .font(.alcheOverlineTiny)
                .foregroundStyle(Color.alcheSecondaryText)
            Text(value)
                .font(.alcheOverline)
                .foregroundStyle(value == "—" ? Color.alcheSecondaryText : Color.alchePrimaryText)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SubscriptionPaywallView()
}
