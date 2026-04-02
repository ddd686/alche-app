import SwiftUI

struct BiomarkerDashboardView: View {
    @State private var viewModel = BiomarkerViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                // Data source indicator
                DataSourceIndicator(isMock: viewModel.isUsingMockData)

                // Biological age card
                if let profile = viewModel.profile {
                    BiologicalAgeCard(profile: profile)
                }

                // Attention markers
                if !viewModel.attentionMarkers.isEmpty {
                    VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                        Text("NEEDS ATTENTION")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        ForEach(viewModel.attentionMarkers) { marker in
                            NavigationLink {
                                BiomarkerDetailView(biomarker: marker)
                            } label: {
                                AttentionMarkerRow(marker: marker)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // Category overview
                VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                    Text("CATEGORIES")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(0.8)

                    ForEach(viewModel.categorySummaries) { summary in
                        NavigationLink {
                            BiomarkerCategoryView(
                                category: summary.category,
                                biomarkers: viewModel.biomarkers.filter { $0.category == summary.category }
                            )
                        } label: {
                            CategoryRow(summary: summary)
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Connect CTA
                AlcheCard {
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("See your real results")
                            .font(.alcheSubheading)
                            .foregroundStyle(Color.alcheEditorialBlack)

                        Text("Connect a blood panel to replace sample data with your actual biomarkers.")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)

                        AlcheButton("Connect blood panel", style: .secondary, icon: "link") {
                            // TODO: Coming soon flow — waitlist signup
                        }
                    }
                }

                // Inline data source note
                DataSourceIndicator(isMock: viewModel.isUsingMockData, style: .inline)
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Biomarkers")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadDashboard()
        }
    }
}

// MARK: - Attention Marker Row

private struct AttentionMarkerRow: View {
    let marker: Biomarker

    var body: some View {
        AlcheCard {
            HStack(spacing: AlcheSpacing.md) {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundStyle(Color.alcheAmber)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text(marker.displayName)
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alcheEditorialBlack)

                    HStack(spacing: AlcheSpacing.sm) {
                        Text("\(marker.value, specifier: "%.1f") \(marker.unit)")
                            .font(.alcheMono)
                            .foregroundStyle(Color.alcheAmber)

                        if let min = marker.referenceMin, let max = marker.referenceMax {
                            Text("(ref: \(min, specifier: "%.0f")-\(max, specifier: "%.0f"))")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                        }
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
            }
        }
    }
}

// MARK: - Category Row

private struct CategoryRow: View {
    let summary: BiomarkerViewModel.CategorySummary

    var body: some View {
        AlcheCard {
            HStack(spacing: AlcheSpacing.md) {
                Image(systemName: summary.category.icon)
                    .font(.alcheSubheading)
                    .foregroundStyle(statusColor)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text(summary.category.displayName)
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alcheEditorialBlack)

                    Text("\(summary.markerCount) markers • \(summary.dominantStatus.displayName)")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }

                Spacer()

                Text("\(summary.score)")
                    .font(.alcheHeading)
                    .foregroundStyle(statusColor)

                Image(systemName: "chevron.right")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
            }
        }
    }

    private var statusColor: Color {
        switch summary.dominantStatus {
        case .optimal: .alcheSage
        case .normal: .alchePrimaryText
        case .attention: .alcheAmber
        case .concern: .alchePrimary
        }
    }
}

#Preview {
    NavigationStack {
        BiomarkerDashboardView()
    }
}
