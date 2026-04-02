import SwiftUI

// MARK: - Data Source Indicator

/// Displays a subtle "Sample Data" badge when mock data is active.
/// Every vision feature screen (Glow Scan, Biomarkers, Digital Twin)
/// must show this indicator when using mock services.
///
/// Usage:
/// ```swift
/// DataSourceIndicator(isMock: viewModel.isUsingMockData)
/// ```
struct DataSourceIndicator: View {
    let isMock: Bool
    var style: IndicatorStyle = .badge

    enum IndicatorStyle {
        case badge
        case inline
    }

    var body: some View {
        if isMock {
            switch style {
            case .badge:
                badgeView
            case .inline:
                inlineView
            }
        }
    }

    private var badgeView: some View {
        HStack(spacing: AlcheSpacing.xs) {
            Circle()
                .fill(Color.alcheEditorialAccent)
                .frame(width: 6, height: 6)

            Text("Sample Data")
                .font(.alcheMono)
                .textCase(.uppercase)
                .tracking(0.5)
                .foregroundStyle(Color.alcheEditorialMuted)
        }
        .padding(.horizontal, AlcheSpacing.sm)
        .padding(.vertical, AlcheSpacing.xs)
        .background(Color.alcheWarmGray.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
    }

    private var inlineView: some View {
        HStack(spacing: AlcheSpacing.xs) {
            Image(systemName: "info.circle")
                .font(.caption2)

            Text("Showing sample data — connect your data to see real results")
                .font(.alcheCaption)
        }
        .foregroundStyle(Color.alcheEditorialMuted)
        .padding(AlcheSpacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.alcheWarmGray.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
        .overlay(
            RoundedRectangle(cornerRadius: AlcheRadii.sm)
                .stroke(Color.alcheEditorialBlack.opacity(0.05), lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview("Data Source Indicator") {
    VStack(spacing: AlcheSpacing.lg) {
        DataSourceIndicator(isMock: true, style: .badge)
        DataSourceIndicator(isMock: true, style: .inline)
        DataSourceIndicator(isMock: false)
    }
    .padding(AlcheSpacing.lg)
    .background(Color.alcheBackground)
}
