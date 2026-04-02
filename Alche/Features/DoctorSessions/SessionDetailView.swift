import SwiftUI

struct SessionDetailView: View {
    let session: DoctorSession
    @State private var showCancelAlert = false
    @State private var cancellationReason = ""
    @State private var isCancelling = false
    @State private var showCancelSuccess = false
    @State private var errorMessage: String?

    private let service: DoctorSessionServiceProtocol = MockDoctorSessionService()

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                // Status icon
                VStack(spacing: AlcheSpacing.sm) {
                    Image(systemName: statusIcon)
                        .font(.system(size: 48))
                        .foregroundStyle(session.status.color)

                    Text(session.status.displayName)
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)
                }
                .padding(.top, AlcheSpacing.lg)

                // Practitioner card
                AlcheCard(shadow: .medium) {
                    HStack(spacing: AlcheSpacing.md) {
                        AlcheAvatar(
                            initials: practitionerInitials,
                            size: 56
                        )

                        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                            Text(practitionerName)
                                .font(.alcheBodyMedium)
                                .foregroundStyle(Color.alcheEditorialBlack)

                            HStack(spacing: AlcheSpacing.xs) {
                                ForEach(practitionerSpecialties, id: \.self) { specialty in
                                    AlcheTag(text: specialty.displayName, color: .alcheSage)
                                }
                            }
                        }

                        Spacer()
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Session details
                AlcheCard {
                    VStack(spacing: AlcheSpacing.md) {
                        DetailRow(icon: "calendar", label: "Date", value: session.formattedDate)

                        Divider().background(Color.alcheWarmGray)

                        DetailRow(icon: "clock", label: "Time", value: session.formattedTime)

                        Divider().background(Color.alcheWarmGray)

                        DetailRow(icon: "timer", label: "Duration", value: "\(session.durationMinutes) min")

                        Divider().background(Color.alcheWarmGray)

                        DetailRow(icon: "stethoscope", label: "Type", value: sessionTypeName)

                        if session.isComplimentary {
                            Divider().background(Color.alcheWarmGray)

                            HStack {
                                HStack(spacing: AlcheSpacing.sm) {
                                    Image(systemName: "star.circle.fill")
                                        .font(.alcheBody)
                                        .foregroundStyle(Color.alchePrimary)
                                        .frame(width: 24)

                                    Text("Included in Membership")
                                        .font(.alcheBody)
                                        .foregroundStyle(Color.alchePrimary)
                                }

                                Spacer()
                            }
                        } else {
                            Divider().background(Color.alcheWarmGray)

                            DetailRow(icon: "eurosign.circle", label: "Price", value: session.formattedPrice)
                        }
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Cancellation info (for past cancelled sessions)
                if let reason = session.cancellationReason, !reason.isEmpty {
                    AlcheCard {
                        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                            Text("CANCELLATION REASON")
                                .font(.alcheOverline)
                                .foregroundStyle(Color.alcheSecondaryText)
                                .tracking(0.8)

                            Text(reason)
                                .font(.alcheBody)
                                .foregroundStyle(Color.alchePrimaryText)
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }

                // Cancel button (for upcoming sessions)
                if session.isUpcoming && session.canCancel {
                    Button {
                        showCancelAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "xmark.circle")
                            Text("Cancel Session")
                        }
                        .font(.alcheBodyMedium)
                        .foregroundStyle(Color.alcheError)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.alcheError.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                } else if session.isUpcoming && !session.canCancel {
                    HStack(spacing: AlcheSpacing.sm) {
                        Image(systemName: "info.circle")
                            .font(.alcheCaption)
                        Text("Sessions can only be cancelled at least 24 hours before the scheduled time.")
                            .font(.alcheCaption)
                    }
                    .foregroundStyle(Color.alcheSecondaryText)
                    .padding(.horizontal, AlcheSpacing.xl)
                }

                // Error
                if let error = errorMessage {
                    Text(error)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheError)
                        .padding(.horizontal, AlcheSpacing.lg)
                }

                DataSourceIndicator(isMock: true)
                    .padding(.top, AlcheSpacing.md)
            }
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Session Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Cancel Session", isPresented: $showCancelAlert) {
            TextField("Reason (optional)", text: $cancellationReason)
            Button("Keep Session", role: .cancel) {}
            Button("Cancel Session", role: .destructive) {
                Task {
                    await cancelSession()
                }
            }
        } message: {
            Text("Are you sure you want to cancel this session?")
        }
        .alert("Session Cancelled", isPresented: $showCancelSuccess) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your session has been cancelled successfully.")
        }
    }

    // MARK: - Cancel Action

    private func cancelSession() async {
        isCancelling = true
        errorMessage = nil

        do {
            let reason = cancellationReason.isEmpty ? nil : cancellationReason
            try await service.cancelSession(sessionId: session.id, reason: reason)
            showCancelSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isCancelling = false
    }

    // MARK: - Helpers

    private var statusIcon: String {
        switch session.status {
        case .confirmed: "calendar.badge.checkmark"
        case .completed: "checkmark.circle.fill"
        case .cancelledByMember, .cancelledByPractitioner: "xmark.circle.fill"
        case .noShow: "exclamationmark.circle.fill"
        }
    }

    private var practitioner: Practitioner? {
        Practitioner.allPreviews.first(where: { $0.id == session.practitionerId })
    }

    private var practitionerName: String {
        practitioner?.name ?? "Practitioner"
    }

    private var practitionerInitials: String {
        guard let practitioner else { return "?" }
        let parts = practitioner.name
            .replacingOccurrences(of: "Dr. ", with: "")
            .split(separator: " ")
        let first = parts.first?.prefix(1) ?? ""
        let last = parts.count > 1 ? parts.last?.prefix(1) ?? "" : ""
        return "\(first)\(last)"
    }

    private var practitionerSpecialties: [PractitionerSpecialty] {
        practitioner?.specialties ?? []
    }

    private var sessionTypeName: String {
        SessionType.allPreviews.first(where: { $0.id == session.sessionTypeId })?.name ?? "Session"
    }
}

// MARK: - Detail Row

private struct DetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            HStack(spacing: AlcheSpacing.sm) {
                Image(systemName: icon)
                    .font(.alcheBody)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .frame(width: 24)

                Text(label)
                    .font(.alcheBody)
                    .foregroundStyle(Color.alcheSecondaryText)
            }

            Spacer()

            Text(value)
                .font(.alcheBodyMedium)
                .foregroundStyle(Color.alcheEditorialBlack)
        }
    }
}

#Preview {
    NavigationStack {
        SessionDetailView(session: .preview)
    }
}
