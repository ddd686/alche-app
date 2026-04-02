import SwiftUI

struct RegionDetailSheet: View {
    let region: RegionState
    let projection: FutureProjection?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                    // Header
                    VStack(spacing: AlcheSpacing.md) {
                        ZStack {
                            Circle()
                                .fill(statusColor.opacity(0.15))
                                .frame(width: 100, height: 100)

                            Circle()
                                .fill(statusColor.opacity(0.6))
                                .frame(width: 64, height: 64)

                            Text("\(region.score)")
                                .font(.alcheDisplayL)
                                .foregroundStyle(.white)
                        }

                        Text(region.region.displayName)
                            .font(.alcheDisplayL)
                            .foregroundStyle(Color.alchePrimaryText)

                        Text(statusLabel)
                            .font(.alcheBody)
                            .foregroundStyle(statusColor)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, AlcheSpacing.md)

                    Divider()
                        .background(Color.alcheWarmGray)

                    // Linked categories
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("CONNECTED TO")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        ForEach(region.linkedCategories, id: \.self) { category in
                            HStack(spacing: AlcheSpacing.sm) {
                                Image(systemName: category.icon)
                                    .font(.alcheBody)
                                    .foregroundStyle(Color.alchePrimary)
                                    .frame(width: 32)

                                Text(category.displayName)
                                    .font(.alcheBody)
                                    .foregroundStyle(Color.alchePrimaryText)
                            }
                        }
                    }

                    // Recommendations based on status
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("WHAT YOU CAN DO")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        ForEach(recommendations, id: \.self) { rec in
                            HStack(alignment: .top, spacing: AlcheSpacing.sm) {
                                Image(systemName: "leaf")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSage)
                                    .padding(.top, 2)

                                Text(rec)
                                    .font(.alcheBody)
                                    .foregroundStyle(Color.alchePrimaryText)
                            }
                        }
                    }

                    // Future projection
                    if let projection {
                        AlcheCard {
                            VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                                Text("PROJECTED IMPROVEMENT")
                                    .font(.alcheOverline)
                                    .foregroundStyle(Color.alcheSecondaryText)
                                    .tracking(0.8)

                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Now: \(projection.currentScore)")
                                            .font(.alcheBody)
                                            .foregroundStyle(Color.alcheSecondaryText)
                                        Text("In \(projection.timeframeWeeks) weeks: \(projection.projectedScore)")
                                            .font(.alcheBodyMedium)
                                            .foregroundStyle(Color.alcheSage)
                                    }

                                    Spacer()

                                    VStack {
                                        Text("+\(projection.improvement)")
                                            .font(.alcheDisplayL)
                                            .foregroundStyle(Color.alcheSage)
                                        Text("points")
                                            .font(.alcheCaption)
                                            .foregroundStyle(Color.alcheSecondaryText)
                                    }
                                }

                                Text("If you follow the recommended protocols consistently")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }
                        }
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)
                .padding(.bottom, AlcheSpacing.xxl)
            }
            .background(Color.alcheBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Color.alchePrimary)
                }
            }
        }
    }

    private var statusColor: Color {
        switch region.status {
        case .thriving: .alcheSage
        case .balanced: .alcheSage
        case .attention: .alcheAmber
        case .concern: .alchePrimary
        }
    }

    private var statusLabel: String {
        switch region.status {
        case .thriving: "Thriving"
        case .balanced: "Balanced"
        case .attention: "Needs attention"
        case .concern: "Worth looking into"
        }
    }

    private var recommendations: [String] {
        switch region.region {
        case .skin:
            return [
                "Try a weekly Glow Scan to track your skin's appearance over time",
                "Our Glow smoothie with collagen boost supports skin wellness",
                "Regular LED Glow sessions support skin renewal",
            ]
        case .cardiovascular:
            return [
                "Regular movement supports cardiovascular wellness",
                "Omega-3 rich foods and healthy fats are your friends",
                "Our Energy blend contains heart-supporting nutrients",
            ]
        case .metabolic:
            return [
                "Balanced meals with whole foods support metabolic health",
                "The Gut smoothie supports metabolic wellness",
                "Consistent meal timing helps maintain metabolic balance",
            ]
        case .immune:
            return [
                "Vitamin D supplementation is especially important in Berlin winters",
                "LED Recovery sessions support your body's natural repair processes",
                "Sleep quality directly affects immune function",
            ]
        case .hormonal:
            return [
                "Morning light exposure supports healthy cortisol patterns",
                "The Calm smoothie with adaptogens supports hormonal balance",
                "Consistent sleep and wake times help hormonal rhythms",
            ]
        case .musculoskeletal:
            return [
                "LED Recovery sessions support muscle recovery",
                "Our Recovery Complex with turmeric and magnesium helps post-exercise",
                "Regular movement with adequate rest supports long-term joint health",
            ]
        case .cognitive:
            return [
                "Omega-3s and B-vitamins support cognitive function",
                "Quality sleep is the single biggest lever for mental clarity",
                "The Calm smoothie supports focus and mental balance",
            ]
        }
    }
}

#Preview {
    RegionDetailSheet(
        region: RegionState(region: .immune, status: .attention, score: 64, linkedCategories: [.inflammation, .nutrients]),
        projection: FutureProjection(region: .immune, currentScore: 64, projectedScore: 78, timeframeWeeks: 12, protocolFollowed: true)
    )
}
