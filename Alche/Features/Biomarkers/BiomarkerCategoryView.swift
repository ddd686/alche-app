import SwiftUI

struct BiomarkerCategoryView: View {
    let category: BiomarkerCategory
    let biomarkers: [Biomarker]

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                // Category header
                VStack(spacing: AlcheSpacing.sm) {
                    Image(systemName: category.icon)
                        .font(.system(size: 36))
                        .foregroundStyle(Color.alchePrimary)

                    Text(category.displayName)
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)

                    Text("\(biomarkers.count) markers tracked")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
                .padding(.top, AlcheSpacing.md)

                // Summary
                HStack(spacing: AlcheSpacing.md) {
                    StatusPill(count: biomarkers.filter { $0.status == .optimal }.count, label: "Optimal", color: .alcheSage)
                    StatusPill(count: biomarkers.filter { $0.status == .normal }.count, label: "Normal", color: .alchePrimaryText)
                    StatusPill(count: biomarkers.filter { $0.status == .attention }.count, label: "Attention", color: .alcheAmber)
                }

                // Individual markers
                ForEach(biomarkers) { marker in
                    NavigationLink {
                        BiomarkerDetailView(biomarker: marker)
                    } label: {
                        MarkerRow(marker: marker)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Status Pill

private struct StatusPill: View {
    let count: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: AlcheSpacing.xs) {
            Text("\(count)")
                .font(.alcheHeading)
                .foregroundStyle(color)
            Text(label)
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheSecondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AlcheSpacing.sm)
        .background(color.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
    }
}

// MARK: - Marker Row

private struct MarkerRow: View {
    let marker: Biomarker

    var body: some View {
        AlcheCard {
            HStack(spacing: AlcheSpacing.md) {
                // Status indicator
                Circle()
                    .fill(statusColor)
                    .frame(width: 10, height: 10)

                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text(marker.displayName)
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alcheEditorialBlack)

                    Text(marker.status.displayName)
                        .font(.alcheCaption)
                        .foregroundStyle(statusColor)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(marker.value, specifier: "%.1f")")
                        .font(.alcheMono)
                        .foregroundStyle(Color.alchePrimaryText)
                    Text(marker.unit)
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                }

                // Range indicator
                if let pct = marker.percentInRange {
                    RangeBar(percent: pct, status: marker.status)
                        .frame(width: 40)
                }

                Image(systemName: "chevron.right")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
            }
        }
    }

    private var statusColor: Color {
        switch marker.status {
        case .optimal: .alcheSage
        case .normal: .alchePrimaryText
        case .attention: .alcheAmber
        case .concern: .alchePrimary
        }
    }
}

// MARK: - Range Bar

private struct RangeBar: View {
    let percent: Double
    let status: BiomarkerStatus

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.alcheWarmGray)
                    .frame(height: 4)

                RoundedRectangle(cornerRadius: 2)
                    .fill(barColor)
                    .frame(width: geometry.size.width * percent, height: 4)
            }
        }
        .frame(height: 4)
    }

    private var barColor: Color {
        switch status {
        case .optimal: .alcheSage
        case .normal: .alchePrimaryText
        case .attention: .alcheAmber
        case .concern: .alchePrimary
        }
    }
}

#Preview {
    NavigationStack {
        BiomarkerCategoryView(
            category: .nutrients,
            biomarkers: [.preview]
        )
    }
}
