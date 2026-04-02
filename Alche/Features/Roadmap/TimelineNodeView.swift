import SwiftUI

struct TimelineNodeView: View {
    let status: PhaseStatus
    let isFirst: Bool
    let isLast: Bool

    @State private var isPulsing = false

    var body: some View {
        VStack(spacing: 0) {
            // Top connector line
            if !isFirst {
                Rectangle()
                    .fill(Color.alcheBlueprintPrimary)
                    .frame(width: 1)
            } else {
                Color.clear
                    .frame(width: 1)
            }

            // Node: outer ring + inner dot
            ZStack {
                // Pulsing ring for active
                if status == .active {
                    Circle()
                        .stroke(Color.alcheBlueprintPrimary.opacity(0.3), lineWidth: 1)
                        .frame(width: 21, height: 21)
                        .scaleEffect(isPulsing ? 1.6 : 1.0)
                        .opacity(isPulsing ? 0.0 : 0.75)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: isPulsing)
                }

                // Outer circle
                Circle()
                    .fill(outerFill)
                    .frame(width: 21, height: 21)
                    .overlay(
                        Circle()
                            .stroke(Color.alcheBlueprintPrimary, lineWidth: 1)
                    )

                // Inner dot
                innerDot
            }
            .onAppear {
                if status == .active {
                    isPulsing = true
                }
            }

            // Bottom connector line
            if !isLast {
                Rectangle()
                    .fill(Color.alcheBlueprintPrimary)
                    .frame(width: 1)
            } else {
                Color.clear
                    .frame(width: 1)
            }
        }
    }

    // MARK: - Inner Dot

    @ViewBuilder
    private var innerDot: some View {
        switch status {
        case .completed:
            // Filled small dot
            Circle()
                .fill(Color.alcheBlueprintPrimary)
                .frame(width: 8, height: 8)

        case .active:
            // Filled small dot (same as completed but with pulse ring)
            Circle()
                .fill(Color.alcheBlueprintPrimary)
                .frame(width: 8, height: 8)

        case .locked:
            // Hollow small dot
            Circle()
                .stroke(Color.alcheBlueprintPrimary, lineWidth: 1)
                .frame(width: 6, height: 6)
        }
    }

    // MARK: - Styling

    private var outerFill: Color {
        switch status {
        case .completed: Color.alcheWhite
        case .active: Color.alcheWhite
        case .locked: Color.alcheBlueprintBg
        }
    }
}

// MARK: - Preview

#Preview("Timeline Nodes") {
    HStack(spacing: AlcheSpacing.lg) {
        VStack(spacing: 0) {
            TimelineNodeView(status: .completed, isFirst: true, isLast: false)
                .frame(height: 140)
            TimelineNodeView(status: .active, isFirst: false, isLast: false)
                .frame(height: 140)
            TimelineNodeView(status: .locked, isFirst: false, isLast: true)
                .frame(height: 140)
        }
    }
    .padding(AlcheSpacing.lg)
    .background(Color.alcheBlueprintBg)
}
