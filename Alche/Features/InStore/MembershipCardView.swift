import SwiftUI

struct MembershipCardView: View {
    let membership: Membership
    let userName: String

    var body: some View {
        VStack(spacing: 0) {
            // Card face
            VStack(spacing: AlcheSpacing.lg) {
                // Top bar
                HStack {
                    Text("alche")
                        .font(.displayL)
                        .foregroundStyle(Color.alcheWhite)

                    Spacer()

                    Text(membership.tier.displayName.uppercased())
                        .font(.overline)
                        .foregroundStyle(Color.alcheWhite.opacity(0.7))
                }

                Spacer()

                // Member info
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                        Text(userName)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheWhite)

                        if membership.isFoundingMember {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 9))
                                Text("Founding Member")
                                    .font(.alcheOverline)
                            }
                            .foregroundStyle(Color.amber)
                        }
                    }

                    Spacer()

                    // Credits
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(membership.creditsRemaining)")
                            .font(.displayL)
                            .foregroundStyle(Color.alcheWhite)
                        Text("credits")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheWhite.opacity(0.6))
                    }
                }
            }
            .padding(AlcheSpacing.lg)
            .frame(height: 200)
            .background(
                LinearGradient(
                    colors: tierGradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.lg))
            .shadow(color: Color.alcheEditorialBlack.opacity(0.2), radius: 16, y: 8)
        }
    }

    private var tierGradientColors: [Color] {
        switch membership.tier {
        case .free:
            [Color.stone, Color.stone.opacity(0.8)]
        case .core:
            [Color.terra, Color.terra.opacity(0.8)]
        case .pro:
            [Color.deep, Color.terra.opacity(0.6)]
        case .premium:
            [Color.deep, Color.amber.opacity(0.5)]
        }
    }
}

#Preview {
    MembershipCardView(
        membership: .preview,
        userName: "Lena M."
    )
    .padding()
    .background(Color.alcheSurface)
}
