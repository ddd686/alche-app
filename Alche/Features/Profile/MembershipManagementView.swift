import SwiftUI

struct MembershipManagementView: View {
    let membership: Membership
    @State private var complimentaryAllowance: ComplimentarySessionAllowance?
    @State private var isLoadingAllowance = false

    private let doctorSessionService: DoctorSessionServiceProtocol = MockDoctorSessionService()
    private let demoUserId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                // Current tier card
                AlcheCard(shadow: .medium) {
                    VStack(spacing: AlcheSpacing.md) {
                        HStack {
                            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                                if membership.isFoundingMember {
                                    Text("FOUNDING MEMBER")
                                        .font(.alcheOverline)
                                        .foregroundStyle(Color.alcheAmber)
                                        .tracking(0.8)
                                }

                                Text(membership.tier.displayName)
                                    .font(.alcheDisplayL)
                                    .foregroundStyle(Color.alcheEditorialBlack)

                                Text(statusLabel)
                                    .font(.alcheCaption)
                                    .foregroundStyle(statusColor)
                            }

                            Spacer()

                            VStack {
                                Text("EUR \(membership.tier.monthlyPriceCents / 100)")
                                    .font(.alcheDisplayL)
                                    .foregroundStyle(Color.alchePrimary)
                                Text("/month")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }
                        }

                        Divider()
                            .background(Color.alcheWarmGray)

                        // Credits
                        HStack {
                            Label("LED Credits", systemImage: "light.max")
                                .font(.alcheBody)
                                .foregroundStyle(Color.alcheEditorialBlack)

                            Spacer()

                            Text("\(membership.creditsRemaining) / \(membership.tier.ledCreditsPerMonth)")
                                .font(.alcheBodyMedium)
                                .foregroundStyle(Color.alchePrimary)
                        }

                        // Complimentary wellness session (Premium members only)
                        if membership.tier == .premium {
                            Divider()
                                .background(Color.alcheWarmGray)

                            HStack {
                                Label("Wellness Session", systemImage: "stethoscope")
                                    .font(.alcheBody)
                                    .foregroundStyle(Color.alcheEditorialBlack)

                                Spacer()

                                if let allowance = complimentaryAllowance {
                                    if allowance.hasAvailable {
                                        HStack(spacing: AlcheSpacing.xs) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.alcheCaption)
                                                .foregroundStyle(Color.alcheSage)
                                            Text("1 included this month")
                                                .font(.alcheCaption)
                                                .foregroundStyle(Color.alcheSage)
                                        }
                                    } else {
                                        HStack(spacing: AlcheSpacing.xs) {
                                            Image(systemName: "checkmark.circle")
                                                .font(.alcheCaption)
                                                .foregroundStyle(Color.alcheSecondaryText)
                                            Text("Used this month")
                                                .font(.alcheCaption)
                                                .foregroundStyle(Color.alcheSecondaryText)
                                        }
                                    }
                                } else if isLoadingAllowance {
                                    ProgressView()
                                        .scaleEffect(0.7)
                                        .tint(Color.alchePrimary)
                                }
                            }
                        }
                    }
                }

                // Tier comparison
                VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                    Text("AVAILABLE PLANS")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(0.8)

                    ForEach(MembershipTier.allCases, id: \.self) { tier in
                        TierComparisonRow(
                            tier: tier,
                            isCurrent: tier == membership.tier
                        )
                    }
                }

                // Manage
                VStack(spacing: AlcheSpacing.sm) {
                    if membership.tier != .premium {
                        AlcheButton("Upgrade", icon: "arrow.up") {
                            // TODO: Navigate to paywall
                        }
                    }

                    if membership.tier != .free {
                        AlcheButton("Manage subscription", style: .secondary) {
                            // TODO: Open StoreKit subscription management
                        }
                    }
                }
            }
            .padding(AlcheSpacing.lg)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Membership")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if membership.tier == .premium {
                isLoadingAllowance = true
                do {
                    complimentaryAllowance = try await doctorSessionService.complimentaryAllowance(
                        userId: demoUserId,
                        month: Date()
                    )
                } catch {
                    complimentaryAllowance = nil
                }
                isLoadingAllowance = false
            }
        }
    }

    private var statusLabel: String {
        switch membership.status {
        case .active: "Active"
        case .paused: "Paused"
        case .cancelled: "Cancelled"
        case .trial: "Trial"
        }
    }

    private var statusColor: Color {
        switch membership.status {
        case .active: .alcheSage
        case .trial: .alcheInfo
        case .paused: .alcheAmber
        case .cancelled: .alcheError
        }
    }
}

// MARK: - Tier Comparison Row

private struct TierComparisonRow: View {
    let tier: MembershipTier
    let isCurrent: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                HStack(spacing: AlcheSpacing.sm) {
                    Text(tier.displayName)
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alchePrimaryText)

                    if isCurrent {
                        Text("Current")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSage)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.alcheSage.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }

                Text("\(tier.ledCreditsPerMonth) LED sessions/month")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
            }

            Spacer()

            if tier.monthlyPriceCents > 0 {
                Text("EUR \(tier.monthlyPriceCents / 100)")
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alchePrimary)
            } else {
                Text("Free")
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alcheSage)
            }
        }
        .padding(AlcheSpacing.md)
        .background(isCurrent ? Color.alchePrimary.opacity(0.04) : Color.alcheWarmGray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
    }
}

#Preview {
    NavigationStack {
        MembershipManagementView(membership: .preview)
    }
}
