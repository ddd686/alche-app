import SwiftUI

struct GlowScanResultView: View {
    let result: GlowScanResult
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AlcheSpacing.lg) {
                    // Mock data indicator
                    DataSourceIndicator(isMock: result.isMock)

                    // Hero score
                    VStack(spacing: AlcheSpacing.md) {
                        Text("Your Glow Score")
                            .font(.alcheDisplayL)
                            .foregroundStyle(Color.alchePrimaryText)

                        ZStack {
                            Circle()
                                .stroke(Color.alcheWarmGray, lineWidth: 6)
                                .frame(width: 140, height: 140)

                            Circle()
                                .trim(from: 0, to: CGFloat(result.overallScore) / 100)
                                .stroke(scoreColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                .frame(width: 140, height: 140)
                                .rotationEffect(.degrees(-90))

                            VStack(spacing: 2) {
                                Text("\(result.overallScore)")
                                    .font(.alcheMonoLarge)
                                    .foregroundStyle(scoreColor)
                                Text("/ 100")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }
                        }

                        Text(overallMessage)
                            .font(.alcheBody)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AlcheSpacing.lg)
                    }

                    Divider()
                        .background(Color.alcheWarmGray)

                    // Category breakdown
                    VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                        Text("BREAKDOWN")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        ForEach(result.categories, id: \.name) { category in
                            SkinCategoryCard(category: category)
                        }
                    }

                    // Recommendations
                    if let recs = result.recommendations, !recs.isEmpty {
                        VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                            Text("RECOMMENDATIONS")
                                .font(.alcheOverline)
                                .foregroundStyle(Color.alcheSecondaryText)
                                .tracking(0.8)

                            ForEach(recs, id: \.reason) { rec in
                                HStack(alignment: .top, spacing: AlcheSpacing.sm) {
                                    Image(systemName: "leaf")
                                        .font(.alcheCaption)
                                        .foregroundStyle(Color.alcheSage)
                                        .padding(.top, 2)

                                    Text(rec.reason)
                                        .font(.alcheBody)
                                        .foregroundStyle(Color.alchePrimaryText)
                                        .lineSpacing(2)
                                }
                                .padding(AlcheSpacing.md)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.alcheSage.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
                            }
                        }
                    }

                    // Inline data source note
                    DataSourceIndicator(isMock: result.isMock, style: .inline)
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

    private var scoreColor: Color {
        switch result.overallScore {
        case 80...100: .alcheSage
        case 65..<80: .alcheAmber
        default: .alchePrimary
        }
    }

    private var overallMessage: String {
        switch result.overallScore {
        case 80...100: "Your skin is looking radiant. Whatever you're doing, keep it up."
        case 70..<80: "Looking good overall, with a couple of areas to focus on."
        case 60..<70: "Your skin could use a little more attention. Check the recommendations below."
        default: "There's room to glow. Small changes can make a big difference."
        }
    }
}

#Preview {
    GlowScanResultView(result: .preview)
}
