import SwiftUI

struct MySessionsView: View {
    @State private var viewModel = MySessionsViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(Color.alchePrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AlcheSpacing.xxl)
                } else if viewModel.isEmpty {
                    AlcheEmptyStateView(
                        icon: "stethoscope",
                        title: "No sessions yet",
                        message: "Book your first wellness session with one of our longevity practitioners.",
                        actionTitle: "Browse Practitioners"
                    ) {
                        // Navigation handled via NavigationLink in parent
                    }
                } else {
                    // Upcoming sessions
                    VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                        Text("UPCOMING")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)
                            .padding(.horizontal, AlcheSpacing.lg)

                        if viewModel.hasNoUpcoming {
                            HStack(spacing: AlcheSpacing.sm) {
                                Image(systemName: "calendar")
                                    .font(.alcheBody)
                                    .foregroundStyle(Color.alcheSecondaryText.opacity(0.4))
                                Text("No upcoming sessions")
                                    .font(.alcheBody)
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AlcheSpacing.lg)
                        } else {
                            ForEach(viewModel.upcomingSessions) { session in
                                NavigationLink {
                                    SessionDetailView(session: session)
                                } label: {
                                    SessionCard(
                                        session: session,
                                        practitionerName: viewModel.practitionerName(for: session),
                                        sessionTypeName: viewModel.sessionTypeName(for: session),
                                        isMuted: false
                                    )
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal, AlcheSpacing.lg)
                            }
                        }
                    }

                    // Past sessions
                    if !viewModel.pastSessions.isEmpty {
                        VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                            Text("PAST")
                                .font(.alcheOverline)
                                .foregroundStyle(Color.alcheSecondaryText)
                                .tracking(0.8)
                                .padding(.horizontal, AlcheSpacing.lg)

                            ForEach(viewModel.pastSessions) { session in
                                NavigationLink {
                                    SessionDetailView(session: session)
                                } label: {
                                    SessionCard(
                                        session: session,
                                        practitionerName: viewModel.practitionerName(for: session),
                                        sessionTypeName: viewModel.sessionTypeName(for: session),
                                        isMuted: true
                                    )
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal, AlcheSpacing.lg)
                            }
                        }
                    }
                }

                // Error
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheError)
                        .padding(.horizontal, AlcheSpacing.lg)
                }

                DataSourceIndicator(isMock: true)
                    .padding(.top, AlcheSpacing.md)
            }
            .padding(.top, AlcheSpacing.md)
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationTitle("My Sessions")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadSessions()
        }
        .alert("Cancel Session", isPresented: $viewModel.showCancelAlert) {
            Button("Keep Session", role: .cancel) {
                viewModel.dismissCancellation()
            }
            Button("Cancel Session", role: .destructive) {
                Task {
                    await viewModel.confirmCancellation()
                }
            }
        } message: {
            Text("Are you sure you want to cancel this session? Cancellations must be made at least 24 hours before the scheduled time.")
        }
        .alert("Session Cancelled", isPresented: $viewModel.showCancelSuccess) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your session has been cancelled successfully.")
        }
    }
}

// MARK: - Session Card

private struct SessionCard: View {
    let session: DoctorSession
    let practitionerName: String
    let sessionTypeName: String
    let isMuted: Bool

    var body: some View {
        AlcheCard(shadow: isMuted ? .subtle : .medium) {
            HStack(spacing: AlcheSpacing.md) {
                // Status dot
                Circle()
                    .fill(session.status.color)
                    .frame(width: 10, height: 10)

                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text(practitionerName)
                        .font(.alcheBodyMedium)
                        .foregroundStyle(isMuted ? Color.alcheSecondaryText : Color.alcheEditorialBlack)

                    Text(sessionTypeName)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)

                    HStack(spacing: AlcheSpacing.sm) {
                        Text(session.formattedShortDate)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)

                        Text(session.formattedTime)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }

                    HStack(spacing: AlcheSpacing.sm) {
                        AlcheTag(
                            text: session.status.displayName,
                            color: session.status.color
                        )

                        if session.isComplimentary {
                            AlcheTag(
                                text: "Complimentary",
                                color: .alchePrimary
                            )
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

#Preview {
    NavigationStack {
        MySessionsView()
    }
}
