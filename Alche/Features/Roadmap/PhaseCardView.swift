import SwiftUI

struct PhaseCardView: View {
    let phase: RoadmapPhase

    var body: some View {
        Group {
            switch phase.status {
            case .completed, .active:
                activeOrCompletedCard
            case .locked:
                lockedCard
            }
        }
    }

    // MARK: - Completed / Active Card

    private var activeOrCompletedCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header row: badge + week range, dashed bottom border
            HStack {
                phaseBadge

                Spacer()

                Text(phase.weekRange.uppercased())
                    .font(.alcheOverline)
                    .tracking(1.5)
                    .foregroundStyle(Color.alcheBlueprintGray)
            }
            .padding(.bottom, AlcheSpacing.sm)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                    .frame(height: 1)
                    .foregroundStyle(Color.alcheBlueprintGray.opacity(0.3))
            }
            .padding(.bottom, AlcheSpacing.sm + 4)

            // Title
            Text(phase.title)
                .font(.alcheDisplayS)
                .foregroundStyle(Color.alcheBlueprintPrimary)

            // Subtitle
            Text(phase.subtitle.uppercased())
                .font(.alcheOverline)
                .tracking(1.0)
                .foregroundStyle(Color.alcheBlueprintGray)
                .lineSpacing(4)
                .padding(.top, AlcheSpacing.xs)
                .padding(.bottom, AlcheSpacing.md)

            // Data row
            HStack(alignment: .top, spacing: 0) {
                dataColumn(label: phase.primaryLabel, value: phase.primaryValue)

                Spacer()

                dataColumn(
                    label: phase.secondaryLabel,
                    value: phase.secondaryValue,
                    isHighlighted: phase.status == .active && phase.secondaryLabel.lowercased() == "status"
                )
            }
            .padding(.top, AlcheSpacing.sm)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Color.alcheBlueprintGray.opacity(0.1))
                    .frame(height: 1)
            }

            // Progress bar + status
            HStack(spacing: AlcheSpacing.sm) {
                // Progress track
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.alcheBlueprintGray.opacity(0.15))
                            .frame(height: 4)

                        Rectangle()
                            .fill(Color.alcheBlueprintPrimary)
                            .frame(width: geo.size.width * phase.progress, height: 4)
                    }
                }
                .frame(height: 4)

                HStack(spacing: AlcheSpacing.xs) {
                    Text(statusLabel.uppercased())
                        .font(.alcheMonoBold)
                        .tracking(0.8)
                        .foregroundStyle(Color.alcheBlueprintPrimary)

                    if phase.status == .completed {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.alcheBlueprintPrimary)
                    }
                }
                .fixedSize()
            }
            .padding(.top, AlcheSpacing.md)
        }
        .padding(AlcheSpacing.lg)
        .background(Color.alcheWhite)
        .overlay(
            Rectangle()
                .stroke(Color.alcheBlueprintPrimary, lineWidth: 1)
        )
        .alcheShadow(.medium)
    }

    // MARK: - Locked Card

    private var lockedCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header: badge + lock icon
            HStack {
                phaseBadge

                Spacer()

                Image(systemName: "lock")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.alcheBlueprintGray)
            }
            .padding(.bottom, AlcheSpacing.sm)

            // Title
            Text(phase.title)
                .font(.alcheDisplayS)
                .foregroundStyle(Color.alcheBlueprintGray)
                .padding(.bottom, AlcheSpacing.xs)

            // Subtitle
            Text(phase.subtitle.uppercased())
                .font(.alcheOverline)
                .tracking(1.0)
                .foregroundStyle(Color.alcheBlueprintGray)
                .lineSpacing(4)
        }
        .padding(AlcheSpacing.lg)
        .background(Color.clear)
        .overlay(
            Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
                .foregroundStyle(Color.alcheBlueprintPrimary)
        )
        .opacity(0.6)
    }

    // MARK: - Subviews

    private var phaseBadge: some View {
        Text("PHASE \(String(format: "%02d", phase.phaseNumber))")
            .font(.alcheMonoBold)
            .tracking(1.5)
            .foregroundStyle(badgeForeground)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(badgeBackground)
            .overlay(
                phase.status != .completed
                    ? Rectangle()
                        .stroke(badgeBorderColor, lineWidth: 1)
                    : nil
            )
    }

    @ViewBuilder
    private func dataColumn(label: String, value: String, isHighlighted: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text(label.uppercased())
                .font(.alcheOverlineTiny)
                .tracking(0.8)
                .foregroundStyle(Color.alcheBlueprintGray.opacity(0.6))

            Text(value)
                .font(.alcheSubheading)
                .foregroundStyle(isHighlighted ? Color.alcheSuccess : Color.alcheBlueprintPrimary)
        }
    }

    // MARK: - Styling

    private var badgeForeground: Color {
        switch phase.status {
        case .completed: Color.alcheWhite
        case .active: Color.alcheBlueprintPrimary
        case .locked: Color.alcheBlueprintGray
        }
    }

    private var badgeBackground: Color {
        switch phase.status {
        case .completed: Color.alcheBlueprintPrimary
        case .active: Color.clear
        case .locked: Color.clear
        }
    }

    private var badgeBorderColor: Color {
        switch phase.status {
        case .completed: Color.clear
        case .active: Color.alcheBlueprintPrimary
        case .locked: Color.alcheBlueprintGray.opacity(0.3)
        }
    }

    private var statusLabel: String {
        switch phase.status {
        case .completed: "Completed"
        case .active: "In Progress"
        case .locked: "Locked"
        }
    }
}

// MARK: - Preview

#Preview("Phase Cards") {
    ScrollView {
        VStack(spacing: AlcheSpacing.xl) {
            ForEach(RoadmapPhase.allPreviews) { phase in
                PhaseCardView(phase: phase)
            }
        }
        .padding(AlcheSpacing.lg)
    }
    .background(Color.alcheBlueprintBg)
}
