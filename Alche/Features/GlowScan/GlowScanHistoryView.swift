import SwiftUI

struct GlowScanHistoryView: View {
    let viewModel: GlowScanViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                DataSourceIndicator(isMock: viewModel.isUsingMockData)

                // Trend chart
                if viewModel.scanHistory.count >= 2 {
                    AlcheCard(shadow: .medium) {
                        VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                            HStack {
                                Text("GLOW SCORE TREND")
                                    .font(.alcheOverline)
                                    .foregroundStyle(Color.alcheSecondaryText)
                                    .tracking(0.8)

                                Spacer()

                                HStack(spacing: AlcheSpacing.xs) {
                                    Image(systemName: viewModel.overallTrend.icon)
                                    Text(viewModel.overallTrend.label)
                                }
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSage)
                            }

                            MarkerTrendChart(
                                dataPoints: viewModel.scanHistory.reversed().map { Double($0.overallScore) },
                                referenceMin: nil,
                                referenceMax: nil,
                                color: .alchePrimary
                            )
                        }
                    }
                }

                // Scan list
                VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                    Text("ALL SCANS")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(0.8)

                    if viewModel.scanHistory.isEmpty {
                        AlcheEmptyStateView(
                            icon: "sparkles",
                            title: "No scans yet",
                            message: "Take your first Glow Scan to start tracking your skin's appearance over time."
                        )
                    } else {
                        ForEach(viewModel.scanHistory) { scan in
                            ScanHistoryRow(scan: scan)
                        }
                    }
                }
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Scan History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Scan History Row

private struct ScanHistoryRow: View {
    let scan: GlowScanResult

    var body: some View {
        AlcheCard {
            HStack {
                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text(formattedDate)
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alcheEditorialBlack)

                    HStack(spacing: AlcheSpacing.md) {
                        MiniScore(label: "Hydration", score: scan.hydrationScore)
                        MiniScore(label: "Radiance", score: scan.radianceScore)
                        MiniScore(label: "Texture", score: scan.textureScore)
                    }
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("\(scan.overallScore)")
                        .font(.alcheHeading)
                        .foregroundStyle(scoreColor)
                    Text("Glow")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, HH:mm"
        return formatter.string(from: scan.scannedAt)
    }

    private var scoreColor: Color {
        switch scan.overallScore {
        case 80...100: .alcheSage
        case 65..<80: .alcheAmber
        default: .alchePrimary
        }
    }
}

private struct MiniScore: View {
    let label: String
    let score: Int

    var body: some View {
        VStack(spacing: 2) {
            Text("\(score)")
                .font(.alcheCaption)
                .foregroundStyle(Color.alchePrimaryText)
            Text(label)
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheSecondaryText)
        }
    }
}

#Preview {
    NavigationStack {
        GlowScanHistoryView(viewModel: GlowScanViewModel())
    }
}
