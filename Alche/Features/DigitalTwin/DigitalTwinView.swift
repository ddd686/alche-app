import SwiftUI

struct DigitalTwinView: View {
    @State private var viewModel = DigitalTwinViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                // Data source indicator
                DataSourceIndicator(isMock: viewModel.isUsingMockData)

                // Header
                VStack(spacing: AlcheSpacing.sm) {
                    Text("Digital Twin")
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)

                    Text("A holistic view of your wellness across all dimensions")
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .multilineTextAlignment(.center)
                }

                if viewModel.isLoading {
                    VStack(spacing: AlcheSpacing.md) {
                        ProgressView()
                            .tint(Color.alchePrimary)
                        Text("Building your Digital Twin...")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                    .padding(.vertical, AlcheSpacing.xxl)
                } else if let state = viewModel.twinState {
                    // Body map visualization
                    BodyMapVisualization(
                        regionStates: state.regionStates,
                        showFuture: viewModel.showFutureToggle,
                        futureProjections: viewModel.futureProjections
                    ) { region in
                        viewModel.selectRegion(region)
                    }
                    .frame(height: 360)

                    // Future toggle
                    if !viewModel.futureProjections.isEmpty {
                        HStack {
                            Text("Show future projection")
                                .font(.alcheBody)
                                .foregroundStyle(Color.alchePrimaryText)

                            Spacer()

                            Toggle("", isOn: $viewModel.showFutureToggle)
                                .tint(Color.alcheSage)
                        }
                        .padding(.horizontal, AlcheSpacing.lg)
                    }

                    // Region summary
                    VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                        // Thriving
                        if !viewModel.thrivingRegions.isEmpty {
                            VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                                Text("THRIVING")
                                    .font(.alcheOverline)
                                    .foregroundStyle(Color.alcheSage)
                                    .tracking(0.8)

                                ForEach(viewModel.thrivingRegions, id: \.region) { region in
                                    RegionSummaryRow(region: region) {
                                        viewModel.selectRegion(region)
                                    }
                                }
                            }
                        }

                        // Needs attention
                        if !viewModel.attentionRegions.isEmpty {
                            VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                                Text("NEEDS ATTENTION")
                                    .font(.alcheOverline)
                                    .foregroundStyle(Color.alcheAmber)
                                    .tracking(0.8)

                                ForEach(viewModel.attentionRegions, id: \.region) { region in
                                    RegionSummaryRow(region: region) {
                                        viewModel.selectRegion(region)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)

                    // Future projections
                    if !viewModel.futureProjections.isEmpty {
                        FutureProjectionView(projections: viewModel.futureProjections)
                            .padding(.horizontal, AlcheSpacing.lg)
                    }
                } else {
                    AlcheEmptyStateView(
                        icon: "person.and.background.dotted",
                        title: "Your Digital Twin awaits",
                        message: "Complete a biomarker profile to generate your personalised wellness map.",
                        actionTitle: "View Biomarkers"
                    ) {
                        // TODO: Navigate to biomarkers
                    }
                }

                // Inline data source
                DataSourceIndicator(isMock: viewModel.isUsingMockData, style: .inline)
                    .padding(.horizontal, AlcheSpacing.lg)
            }
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Digital Twin")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showRegionDetail) {
            if let region = viewModel.selectedRegion {
                RegionDetailSheet(
                    region: region,
                    projection: viewModel.projection(for: region.region)
                )
            }
        }
        .task {
            await viewModel.loadTwinState()
        }
    }
}

// MARK: - Region Summary Row

private struct RegionSummaryRow: View {
    let region: RegionState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            AlcheCard {
                HStack(spacing: AlcheSpacing.md) {
                    Circle()
                        .fill(statusColor.opacity(0.6))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Text("\(region.score)")
                                .font(.alcheCaption)
                                .foregroundStyle(.white)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text(region.region.displayName)
                            .font(.alcheSubheading)
                            .foregroundStyle(Color.alcheEditorialBlack)

                        Text(region.linkedCategories.map(\.displayName).joined(separator: ", "))
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var statusColor: Color {
        switch region.status {
        case .thriving: .alcheSage
        case .balanced: .alcheSage.opacity(0.7)
        case .attention: .alcheAmber
        case .concern: .alchePrimary
        }
    }
}

#Preview {
    NavigationStack {
        DigitalTwinView()
    }
}
