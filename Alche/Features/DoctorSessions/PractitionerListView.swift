import SwiftUI

struct PractitionerListView: View {
    @State private var viewModel = PractitionerListViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                // Specialty filter pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AlcheSpacing.sm) {
                        SpecialtyFilterPill(
                            title: "All",
                            isSelected: viewModel.selectedSpecialty == nil
                        ) {
                            viewModel.selectSpecialty(nil)
                        }

                        ForEach(viewModel.availableSpecialties, id: \.self) { specialty in
                            SpecialtyFilterPill(
                                title: specialty.displayName,
                                isSelected: viewModel.selectedSpecialty == specialty
                            ) {
                                viewModel.selectSpecialty(specialty)
                            }
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }

                // Content
                if viewModel.isLoading {
                    VStack(spacing: AlcheSpacing.md) {
                        ProgressView()
                            .tint(Color.alchePrimary)
                        Text("Loading practitioners...")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, AlcheSpacing.xl)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: AlcheSpacing.md) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 32))
                            .foregroundStyle(Color.alcheAmber)
                        Text(errorMessage)
                            .font(.alcheBody)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .multilineTextAlignment(.center)
                        AlcheButton("Retry", style: .secondary) {
                            Task { await viewModel.refresh() }
                        }
                        .frame(maxWidth: 160)
                    }
                    .padding(AlcheSpacing.xl)
                } else if viewModel.isEmpty {
                    AlcheEmptyStateView(
                        icon: "stethoscope",
                        title: "No practitioners found",
                        message: "No practitioners match your selected specialty. Try a different filter or check back soon."
                    )
                } else {
                    LazyVStack(spacing: AlcheSpacing.md) {
                        ForEach(viewModel.filteredPractitioners) { practitioner in
                            NavigationLink {
                                PractitionerDetailView(practitioner: practitioner)
                            } label: {
                                PractitionerCard(practitioner: practitioner)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }

                DataSourceIndicator(isMock: true)
                    .padding(.top, AlcheSpacing.md)
            }
            .padding(.top, AlcheSpacing.md)
            .padding(.bottom, AlcheSpacing.xl)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Wellness Practitioners")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadPractitioners()
        }
    }
}

// MARK: - Specialty Filter Pill

private struct SpecialtyFilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.alcheCaption)
                .foregroundStyle(isSelected ? Color.alcheWhite : Color.alchePrimaryText)
                .padding(.horizontal, AlcheSpacing.md)
                .padding(.vertical, AlcheSpacing.sm)
                .background(isSelected ? Color.alchePrimary : Color.alcheWarmGray.opacity(0.5))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Practitioner Card

private struct PractitionerCard: View {
    let practitioner: Practitioner

    var body: some View {
        HStack(spacing: AlcheSpacing.md) {
            // Photo placeholder with initials
            AlcheAvatar(
                initials: practitionerInitials,
                size: 64
            )

            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                Text(practitioner.name)
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alcheEditorialBlack)

                Text(practitioner.title)
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)

                // Specialty tags
                HStack(spacing: AlcheSpacing.xs) {
                    ForEach(practitioner.specialties, id: \.self) { specialty in
                        AlcheTag(text: specialty.displayName, color: .alcheSage)
                    }
                }

                // Rating stars + review count
                HStack(spacing: AlcheSpacing.xs) {
                    RatingStarsView(rating: practitioner.rating ?? 0)

                    Text(practitioner.formattedRating)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheEditorialBlack)

                    Text("(\(practitioner.reviewCount))")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheSecondaryText)
        }
        .padding(AlcheSpacing.md)
        .background(Color.alcheSurface)
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
    }

    private var practitionerInitials: String {
        let parts = practitioner.name
            .replacingOccurrences(of: "Dr. ", with: "")
            .split(separator: " ")
        let first = parts.first?.prefix(1) ?? ""
        let last = parts.count > 1 ? parts.last?.prefix(1) ?? "" : ""
        return "\(first)\(last)"
    }
}

// MARK: - Rating Stars View

struct RatingStarsView: View {
    let rating: Double
    var size: CGFloat = 12

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                starImage(for: index)
                    .font(.system(size: size))
                    .foregroundStyle(Color.alcheAmber)
            }
        }
    }

    private func starImage(for index: Int) -> Image {
        let threshold = Double(index) + 1.0
        if rating >= threshold {
            return Image(systemName: "star.fill")
        } else if rating >= threshold - 0.5 {
            return Image(systemName: "star.leadinghalf.filled")
        } else {
            return Image(systemName: "star")
        }
    }
}

#Preview {
    NavigationStack {
        PractitionerListView()
    }
}
