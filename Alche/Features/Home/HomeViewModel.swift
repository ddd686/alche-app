import Foundation

@Observable
@MainActor
final class HomeViewModel {
    // MARK: - State

    var nextBooking: Booking?
    var nextDoctorSession: DoctorSession?
    var todayProtocol: HealthProtocol?
    var todayLogs: [ProtocolLog] = []
    var todayCheckin: DailyCheckin?
    var latestGlowScan: GlowScanResult?
    var membership: Membership?
    var macroSummary: DailyMacroSummary?
    var isLoading = false
    var greeting: String = ""

    // MARK: - Services

    private let nutritionService: NutritionTrackingServiceProtocol = MockNutritionTrackingService()
    private let doctorSessionService: DoctorSessionServiceProtocol = MockDoctorSessionService()

    // Placeholder userId — matches MacroDashboardViewModel
    private let userId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    // MARK: - Actions

    func loadDashboard() async {
        isLoading = true

        // TODO: Wire to real services
        try? await Task.sleep(for: .seconds(0.5))

        greeting = generateGreeting()
        nextBooking = Booking.preview
        todayProtocol = HealthProtocol.preview
        membership = Membership.preview

        // Load today's macro summary
        do {
            macroSummary = try await nutritionService.dailySummary(userId: userId, date: Date())
        } catch {
            macroSummary = nil
        }

        // Load next doctor session
        do {
            let upcoming = try await doctorSessionService.upcomingSessions(userId: userId)
            nextDoctorSession = upcoming.first
        } catch {
            nextDoctorSession = nil
        }

        isLoading = false
    }

    // MARK: - Helpers

    private func generateGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Hello"
        }
    }

    var completedSteps: Int {
        todayLogs.filter(\.completed).count
    }

    var totalSteps: Int {
        todayProtocol?.steps.count ?? 0
    }

    var protocolProgress: Double {
        guard totalSteps > 0 else { return 0 }
        return Double(completedSteps) / Double(totalSteps)
    }

    var slotsRemainingToday: Int {
        // TODO: Wire to real BookingService
        Int.random(in: 2...6)
    }

    /// Returns the practitioner name for the next doctor session.
    var nextDoctorSessionPractitionerName: String {
        guard let session = nextDoctorSession else { return "" }
        return Practitioner.allPreviews.first(where: { $0.id == session.practitionerId })?.name ?? "Practitioner"
    }

    /// Returns the session type name for the next doctor session.
    var nextDoctorSessionTypeName: String {
        guard let session = nextDoctorSession else { return "" }
        return SessionType.allPreviews.first(where: { $0.id == session.sessionTypeId })?.name ?? "Session"
    }
}
