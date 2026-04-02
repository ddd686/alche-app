import SwiftUI

struct BiomarkerDetailView: View {
    let biomarker: Biomarker

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                // Header
                VStack(spacing: AlcheSpacing.md) {
                    Image(systemName: biomarker.category.icon)
                        .font(.system(size: 36))
                        .foregroundStyle(statusColor)

                    Text(biomarker.displayName)
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)

                    AlcheTag(
                        text: biomarker.status.displayName,
                        color: statusColor,
                        isSelected: true
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.top, AlcheSpacing.md)

                // Value card
                AlcheCard(shadow: .medium) {
                    VStack(spacing: AlcheSpacing.md) {
                        HStack {
                            Text("Your value")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                            Spacer()
                            Text("Reference range")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                        }

                        HStack {
                            Text("\(biomarker.value, specifier: "%.1f") \(biomarker.unit)")
                                .font(.alcheHeading)
                                .foregroundStyle(statusColor)

                            Spacer()

                            if let min = biomarker.referenceMin, let max = biomarker.referenceMax {
                                Text("\(min, specifier: "%.0f") – \(max, specifier: "%.0f") \(biomarker.unit)")
                                    .font(.alcheMono)
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }
                        }

                        // Visual range bar
                        if biomarker.referenceMin != nil && biomarker.referenceMax != nil {
                            GeometryReader { geometry in
                                let width = geometry.size.width
                                ZStack(alignment: .leading) {
                                    // Full range
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color.alcheWarmGray)
                                        .frame(height: 8)

                                    // Reference range
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color.alcheSage.opacity(0.3))
                                        .frame(width: width * 0.6, height: 8)
                                        .offset(x: width * 0.2)

                                    // Current value marker
                                    let position = markerPosition(in: width)
                                    Circle()
                                        .fill(statusColor)
                                        .frame(width: 14, height: 14)
                                        .offset(x: position - 7)
                                }
                            }
                            .frame(height: 14)
                        }
                    }
                }

                // What it means
                if let meaning = biomarker.whatItMeans {
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("WHAT THIS MEANS")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        Text(meaning)
                            .font(.alcheBody)
                            .foregroundStyle(Color.alchePrimaryText)
                            .lineSpacing(4)
                    }
                }

                // Recommendation
                if let rec = biomarker.recommendation {
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("WHAT YOU CAN DO")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        HStack(alignment: .top, spacing: AlcheSpacing.sm) {
                            Image(systemName: "leaf")
                                .font(.alcheBody)
                                .foregroundStyle(Color.alcheSage)
                                .padding(.top, 2)

                            Text(rec)
                                .font(.alcheBody)
                                .foregroundStyle(Color.alchePrimaryText)
                                .lineSpacing(4)
                        }
                        .padding(AlcheSpacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.alcheSage.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
                    }
                }

                // Trend chart placeholder
                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("TREND")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(0.8)

                    MarkerTrendChart(
                        dataPoints: generateTrendData(),
                        referenceMin: biomarker.referenceMin,
                        referenceMax: biomarker.referenceMax,
                        color: statusColor
                    )
                }

                // Category context
                AlcheCard {
                    HStack(spacing: AlcheSpacing.sm) {
                        Image(systemName: biomarker.category.icon)
                            .foregroundStyle(Color.alchePrimary)
                        Text("Part of your \(biomarker.category.displayName) profile")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                }
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helpers

    private var statusColor: Color {
        switch biomarker.status {
        case .optimal: .alcheSage
        case .normal: .alchePrimaryText
        case .attention: .alcheAmber
        case .concern: .alchePrimary
        }
    }

    private func markerPosition(in width: CGFloat) -> CGFloat {
        guard let _ = biomarker.referenceMin, let max = biomarker.referenceMax else { return width / 2 }
        let fullRange = max * 1.5
        let clamped = Swift.max(0, Swift.min(biomarker.value, fullRange))
        return width * clamped / fullRange
    }

    private func generateTrendData() -> [Double] {
        // Generate plausible trend data (mock)
        let base = biomarker.value
        return (0..<6).map { i in
            let variance = Double.random(in: -2...2)
            let trend = Double(i) * 0.3
            return base - trend + variance
        }.reversed()
    }
}

#Preview {
    NavigationStack {
        BiomarkerDetailView(biomarker: .preview)
    }
}
