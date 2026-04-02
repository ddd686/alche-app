import SwiftUI

// MARK: - Blueprint Grid Background

private struct BlueprintGridBackground: View {
    let spacing: CGFloat = 24

    var body: some View {
        Canvas { context, size in
            let gridColor = Color(red: 0.863, green: 0.863, blue: 0.851).opacity(0.4)
            // Vertical lines
            var x: CGFloat = 0
            while x <= size.width {
                context.stroke(
                    Path { path in
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                    },
                    with: .color(gridColor),
                    lineWidth: 1
                )
                x += spacing
            }
            // Horizontal lines
            var y: CGFloat = 0
            while y <= size.height {
                context.stroke(
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                    },
                    with: .color(gridColor),
                    lineWidth: 1
                )
                y += spacing
            }
        }
    }
}

// MARK: - Roadmap View

struct RoadmapView: View {
    @State private var viewModel = RoadmapViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Header
                headerSection

                // Timeline + Phase Cards
                if viewModel.isLoading {
                    ProgressView()
                        .tint(Color.alcheBlueprintPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, AlcheSpacing.xxl)
                } else if let error = viewModel.errorMessage {
                    errorView(error)
                } else {
                    timelineSection
                }

                // Bottom metadata bar
                metadataBar
                    .padding(.top, AlcheSpacing.xl)

                // Data source
                DataSourceIndicator(isMock: viewModel.isUsingMockData)
                    .padding(.top, AlcheSpacing.md)
                    .padding(.bottom, AlcheSpacing.lg)
            }
        }
        .background(
            ZStack {
                Color.alcheBlueprintBg
                BlueprintGridBackground()
            }
            .ignoresSafeArea()
        )
        .navigationBarHidden(true)
        .task {
            await viewModel.loadPhases()
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 0) {
            // Top nav: back | alche | bell
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.alcheBlueprintPrimary)
                }

                Spacer()

                Text("alche")
                    .font(.alcheDisplayS)
                    .foregroundStyle(Color.alcheBlueprintPrimary)

                Spacer()

                Button {
                    // Notifications
                } label: {
                    Image(systemName: "bell")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.alcheBlueprintPrimary)
                }
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.top, AlcheSpacing.xl)
            .padding(.bottom, AlcheSpacing.lg)

            // Project + Roadmap heading + version badge
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text("PROJECT: LONGEVITY / Roadmap")
                        .font(.alcheOverline)
                        .textCase(.uppercase)
                        .tracking(1.5)
                        .foregroundStyle(Color.alcheBlueprintGray)

                    Text("Roadmap")
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alcheBlueprintPrimary)
                }

                Spacer()

                versionBadge
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.bottom, AlcheSpacing.md)

            // Bottom border
            Rectangle()
                .fill(Color.alcheBlueprintPrimary)
                .frame(height: 1)
        }
        .background(Color.alcheBlueprintBg.opacity(0.95))
    }

    private var versionBadge: some View {
        Text("VER 5.0")
            .font(.alcheMonoBold)
            .tracking(0.5)
            .foregroundStyle(Color.alcheBlueprintPrimary)
            .padding(.horizontal, AlcheSpacing.sm)
            .padding(.vertical, AlcheSpacing.xs)
            .background(Color.alcheWhite)
            .overlay(
                Rectangle()
                    .stroke(Color.alcheBlueprintPrimary, lineWidth: 1)
            )
    }

    // MARK: - Timeline

    private var timelineSection: some View {
        // Container: vertical line on the left, cards to the right
        VStack(spacing: 0) {
            ForEach(Array(viewModel.phases.enumerated()), id: \.element.id) { index, phase in
                HStack(alignment: .top, spacing: AlcheSpacing.md) {
                    TimelineNodeView(
                        status: phase.status,
                        isFirst: index == 0,
                        isLast: index == viewModel.phases.count - 1
                    )
                    .frame(width: 21)

                    PhaseCardView(phase: phase)
                }
                .padding(.bottom, index < viewModel.phases.count - 1 ? AlcheSpacing.xxl : 0)
            }
        }
        .padding(.leading, AlcheSpacing.lg)
        .padding(.trailing, AlcheSpacing.lg)
        .padding(.top, AlcheSpacing.xl)
    }

    // MARK: - Metadata Bar

    private var metadataBar: some View {
        HStack {
            metadataItem(label: "Grid Ref", value: "A-142")
            Spacer()
            metadataItem(label: "Lat", value: "34.05")
            Spacer()
            HStack(alignment: .bottom, spacing: AlcheSpacing.xs) {
                metadataItem(label: "Sync", value: "Auto")
                Circle()
                    .fill(Color.alcheSuccess)
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.horizontal, AlcheSpacing.lg)
        .padding(.vertical, AlcheSpacing.xl)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.alcheBlueprintPrimary)
                .frame(height: 1)
        }
        .background(Color.alcheWhite.opacity(0.5))
    }

    private func metadataItem(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label.uppercased())
                .font(.alcheOverlineTiny)
                .tracking(0.5)
                .foregroundStyle(Color.alcheBlueprintGray.opacity(0.5))

            Text(value)
                .font(.alcheMonoBold)
                .tracking(0.5)
                .foregroundStyle(Color.alcheBlueprintPrimary)
        }
    }

    // MARK: - Error

    private func errorView(_ message: String) -> some View {
        VStack(spacing: AlcheSpacing.md) {
            Image(systemName: "exclamationmark.triangle")
                .font(.alcheDisplayL)
                .foregroundStyle(Color.alcheBlueprintGray)
            Text(message)
                .font(.alcheBody)
                .foregroundStyle(Color.alcheBlueprintGray)
                .multilineTextAlignment(.center)
            AlcheButton("Retry", style: .secondary) {
                Task { await viewModel.loadPhases() }
            }
        }
        .padding(AlcheSpacing.xxl)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        RoadmapView()
    }
}
