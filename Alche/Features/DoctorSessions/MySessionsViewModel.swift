import Foundation

/// ViewModel for the My Sessions screen.
/// Loads upcoming and past doctor sessions, handles cancellation with
/// 24-hour policy enforcement, and provides session lookup helpers.
@Observable
@MainActor
final class MySessionsViewModel {

    // MARK: - State

    var upcomingSessions: [DoctorSession] = []
    var pastSessions: [DoctorSession] = []
    var isLoading = false
    var errorMessage: String?
    var showCancelAlert = false
    var sessionToCancel: DoctorSession?
    var cancellationReason: String = ""
    var isCancelling = false
    var showCancelSuccess = false

    // MARK: - Service

    private let service: DoctorSessionServiceProtocol = MockDoctorSessionService()

    // MARK: - Demo user ID (will be replaced with real auth)
    private let userId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    // MARK: - Computed

    /// Whether there are no sessions at all.
    var isEmpty: Bool {
        !isLoading && upcomingSessions.isEmpty && pastSessions.isEmpty
    }

    /// Whether there are no upcoming sessions.
    var hasNoUpcoming: Bool {
        !isLoading && upcomingSessions.isEmpty
    }

    /// Count of upcoming sessions (for integration points like Profile).
    var upcomingCount: Int {
        upcomingSessions.count
    }

    /// The next upcoming session (for Home card integration).
    var nextSession: DoctorSession? {
        upcomingSessions.first
    }

    // MARK: - Actions

    /// Loads both upcoming and past sessions.
    func loadSessions() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            async let upcoming = service.upcomingSessions(userId: userId)
            async let past = service.pastSessions(userId: userId)

            upcomingSessions = try await upcoming
            pastSessions = try await past
        } catch {
            errorMessage = "Unable to load sessions. Please try again."
        }

        isLoading = false
    }

    /// Initiates the cancellation flow for a session.
    /// Validates the 24-hour cancellation policy before showing the alert.
    func requestCancellation(for session: DoctorSession) {
        guard session.canCancel else {
            errorMessage = "Sessions can only be cancelled at least 24 hours before the scheduled time."
            return
        }
        sessionToCancel = session
        cancellationReason = ""
        showCancelAlert = true
    }

    /// Cancels the session currently marked for cancellation.
    /// Enforces the 24-hour cancellation policy.
    func confirmCancellation() async {
        guard let session = sessionToCancel else { return }

        guard session.canCancel else {
            errorMessage = "Sessions can only be cancelled at least 24 hours before the scheduled time."
            showCancelAlert = false
            sessionToCancel = nil
            return
        }

        isCancelling = true
        errorMessage = nil

        do {
            let reason = cancellationReason.isEmpty ? nil : cancellationReason
            try await service.cancelSession(sessionId: session.id, reason: reason)

            // Move session from upcoming to past with updated status
            if let index = upcomingSessions.firstIndex(where: { $0.id == session.id }) {
                var cancelledSession = upcomingSessions.remove(at: index)
                cancelledSession.status = .cancelledByMember
                cancelledSession.cancellationReason = reason
                cancelledSession.cancelledAt = Date()
                pastSessions.insert(cancelledSession, at: 0)
            }

            showCancelSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isCancelling = false
        showCancelAlert = false
        sessionToCancel = nil
    }

    /// Dismisses the cancellation alert without cancelling.
    func dismissCancellation() {
        showCancelAlert = false
        sessionToCancel = nil
        cancellationReason = ""
    }

    /// Refreshes all session data.
    func refresh() async {
        await loadSessions()
    }

    // MARK: - Lookup Helpers

    /// Finds the practitioner name for a given session.
    /// Uses the cached practitioners from the service.
    func practitionerName(for session: DoctorSession) -> String {
        Practitioner.allPreviews.first(where: { $0.id == session.practitionerId })?.name ?? "Practitioner"
    }

    /// Finds the session type name for a given session.
    func sessionTypeName(for session: DoctorSession) -> String {
        // Default session type names based on known IDs
        let allTypes: [(UUID, String)] = Practitioner.allPreviews.flatMap { practitioner in
            SessionType.allPreviews.map { ($0.id, $0.name) }
        }
        return allTypes.first(where: { $0.0 == session.sessionTypeId })?.1 ?? "Session"
    }
}
