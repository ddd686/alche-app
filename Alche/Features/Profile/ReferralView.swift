import SwiftUI

struct ReferralView: View {
    @Bindable var viewModel: ProfileViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.xl) {
                // Hero
                VStack(spacing: AlcheSpacing.md) {
                    Image(systemName: "person.2.circle")
                        .font(.system(size: 56))
                        .foregroundStyle(Color.alchePrimary)

                    Text("Invite a friend")
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)

                    Text("Share your referral code and give someone you care about the Alche experience. When they join, you both get a little something.")
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AlcheSpacing.lg)
                }
                .padding(.top, AlcheSpacing.lg)

                // Referral code card
                AlcheCard(shadow: .medium) {
                    VStack(spacing: AlcheSpacing.md) {
                        Text("YOUR REFERRAL CODE")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        Text(viewModel.referralCode)
                            .font(.alcheMonoLarge)
                            .foregroundStyle(Color.alchePrimary)
                            .textSelection(.enabled)

                        // Copy button
                        Button {
                            UIPasteboard.general.string = viewModel.referralCode
                            viewModel.copyReferralCode()
                        } label: {
                            HStack(spacing: AlcheSpacing.sm) {
                                Image(systemName: viewModel.referralCopied ? "checkmark" : "doc.on.doc")
                                Text(viewModel.referralCopied ? "Copied" : "Copy code")
                                    .font(.alcheBodyMedium)
                            }
                            .foregroundStyle(viewModel.referralCopied ? Color.alcheSage : Color.alchePrimary)
                            .animation(.alcheQuick, value: viewModel.referralCopied)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Share button
                ShareLink(
                    item: viewModel.referralLink,
                    subject: Text("Join me on Alche"),
                    message: Text("I've been using Alche for my wellness routine in Berlin and thought you'd like it. Use my code \(viewModel.referralCode) when you sign up: \(viewModel.referralLink)")
                ) {
                    HStack(spacing: AlcheSpacing.sm) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share invite link")
                            .font(.alcheBodyMedium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .padding(.horizontal, AlcheSpacing.lg)
                    .foregroundStyle(Color.alcheWhite)
                    .background(Color.alchePrimary)
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Rewards explanation
                VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                    Text("HOW IT WORKS")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(0.8)

                    RewardStep(
                        number: 1,
                        title: "Share your code",
                        description: "Send your referral code or link to a friend"
                    )
                    RewardStep(
                        number: 2,
                        title: "They sign up",
                        description: "Your friend creates an Alche account using your code"
                    )
                    RewardStep(
                        number: 3,
                        title: "You both benefit",
                        description: "You each receive a complimentary LED session credit"
                    )
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Stats placeholder
                AlcheCard {
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("YOUR REFERRALS")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        HStack(spacing: AlcheSpacing.xl) {
                            VStack(spacing: AlcheSpacing.xs) {
                                Text("0")
                                    .font(.alcheHeading)
                                    .foregroundStyle(Color.alcheEditorialBlack)
                                Text("Invited")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }

                            VStack(spacing: AlcheSpacing.xs) {
                                Text("0")
                                    .font(.alcheHeading)
                                    .foregroundStyle(Color.alcheEditorialBlack)
                                Text("Joined")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }

                            VStack(spacing: AlcheSpacing.xs) {
                                Text("0")
                                    .font(.alcheHeading)
                                    .foregroundStyle(Color.alcheSage)
                                Text("Credits earned")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Terms
                Text("Referral credits are applied after the invited person completes their first booking. One credit per referral, unlimited referrals. Terms apply.")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AlcheSpacing.xl)
            }
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Invite Friends")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Reward Step

private struct RewardStep: View {
    let number: Int
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: AlcheSpacing.md) {
            Text("\(number)")
                .font(.alcheBodyMedium)
                .foregroundStyle(Color.alcheWhite)
                .frame(width: 28, height: 28)
                .background(Color.alchePrimary)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.alcheSubheading)
                    .foregroundStyle(Color.alchePrimaryText)
                Text(description)
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ReferralView(viewModel: ProfileViewModel())
    }
}
