import SwiftUI

struct PractitionerDetailView: View {
    let practitioner: Practitioner
    @State private var sessionTypes: [SessionType] = []
    @State private var complimentaryAllowance: ComplimentarySessionAllowance?
    @State private var isLoading = false

    private let service: DoctorSessionServiceProtocol = MockDoctorSessionService()

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                // Photo placeholder
                AlcheAvatar(
                    initials: practitionerInitials,
                    size: 120
                )
                .padding(.top, AlcheSpacing.md)

                // Name + title
                VStack(spacing: AlcheSpacing.xs) {
                    Text(practitioner.name)
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)

                    Text(practitioner.title)
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheSecondaryText)
                }

                // Rating + review count
                if let rating = practitioner.rating {
                    HStack(spacing: AlcheSpacing.sm) {
                        RatingStarsView(rating: rating, size: 16)

                        Text(String(format: "%.1f", rating))
                            .font(.alcheBodyMedium)
                            .foregroundStyle(Color.alchePrimaryText)

                        Text("\(practitioner.reviewCount) reviews")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                }

                // About
                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("ABOUT")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(0.8)

                    Text(practitioner.bio)
                        .font(.alcheBody)
                        .foregroundStyle(Color.alchePrimaryText)
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, AlcheSpacing.lg)

                // Specialties
                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("SPECIALTIES")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(0.8)

                    HStack(spacing: AlcheSpacing.sm) {
                        ForEach(practitioner.specialties, id: \.self) { specialty in
                            AlcheTag(text: specialty.displayName, color: .alcheSage)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, AlcheSpacing.lg)

                // Languages
                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("LANGUAGES")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(0.8)

                    HStack(spacing: AlcheSpacing.sm) {
                        ForEach(practitioner.languages, id: \.self) { language in
                            HStack(spacing: AlcheSpacing.xs) {
                                Image(systemName: "globe")
                                    .font(.alcheOverline)
                                    .foregroundStyle(Color.alcheSecondaryText)
                                Text(language)
                                    .font(.alcheBody)
                                    .foregroundStyle(Color.alchePrimaryText)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, AlcheSpacing.lg)

                // Session Types
                VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                    Text("SESSION TYPES")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(0.8)
                        .padding(.horizontal, AlcheSpacing.lg)

                    if isLoading {
                        ProgressView()
                            .tint(Color.alchePrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AlcheSpacing.lg)
                    } else {
                        ForEach(sessionTypes) { sessionType in
                            SessionTypeCard(
                                sessionType: sessionType,
                                practitioner: practitioner,
                                canUseComplimentary: complimentaryAllowance?.hasAvailable == true
                            )
                            .padding(.horizontal, AlcheSpacing.lg)
                        }
                    }
                }

                // Disclaimer
                Text("Sessions are for wellness guidance and lifestyle optimization. They do not constitute medical advice, diagnosis, or treatment.")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AlcheSpacing.xl)
                    .padding(.top, AlcheSpacing.md)

                DataSourceIndicator(isMock: true)
                    .padding(.bottom, AlcheSpacing.lg)
            }
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationTitle(practitioner.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadData()
        }
    }

    private func loadData() async {
        isLoading = true
        do {
            sessionTypes = try await service.sessionTypes(practitionerId: practitioner.id)
            let userId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
            complimentaryAllowance = try await service.complimentaryAllowance(userId: userId, month: Date())
        } catch {
            // Silently handle -- show empty session types
        }
        isLoading = false
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

// MARK: - Session Type Card

private struct SessionTypeCard: View {
    let sessionType: SessionType
    let practitioner: Practitioner
    let canUseComplimentary: Bool

    var body: some View {
        AlcheCard(shadow: .subtle) {
            VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                HStack {
                    VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                        Text(sessionType.name)
                            .font(.alcheBodyMedium)
                            .foregroundStyle(Color.alcheEditorialBlack)

                        HStack(spacing: AlcheSpacing.sm) {
                            HStack(spacing: AlcheSpacing.xs) {
                                Image(systemName: "clock")
                                    .font(.alcheOverline)
                                Text(sessionType.formattedDuration)
                                    .font(.alcheCaption)
                            }
                            .foregroundStyle(Color.alcheSecondaryText)

                            Text(sessionType.formattedPrice)
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alchePrimary)
                        }
                    }

                    Spacer()

                    NavigationLink {
                        SessionBookingView(practitioner: practitioner, preselectedSessionType: sessionType)
                    } label: {
                        if canUseComplimentary {
                            Text("Included")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSage)
                                .padding(.horizontal, AlcheSpacing.md)
                                .padding(.vertical, AlcheSpacing.sm)
                                .background(Color.alcheSage.opacity(0.1))
                                .clipShape(Capsule())
                        } else {
                            Text("Book")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheWhite)
                                .padding(.horizontal, AlcheSpacing.md)
                                .padding(.vertical, AlcheSpacing.sm)
                                .background(Color.alchePrimary)
                                .clipShape(Capsule())
                        }
                    }
                    .buttonStyle(.plain)
                }

                if let description = sessionType.description {
                    Text(description)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .lineSpacing(2)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PractitionerDetailView(practitioner: .preview)
    }
}
