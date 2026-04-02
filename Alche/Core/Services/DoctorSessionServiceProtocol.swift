import Foundation

protocol DoctorSessionServiceProtocol: Sendable {
    // Practitioners
    func allPractitioners() async throws -> [Practitioner]
    func practitioner(id: UUID) async throws -> Practitioner
    func sessionTypes(practitionerId: UUID) async throws -> [SessionType]

    // Availability
    func availability(practitionerId: UUID, from: Date, to: Date) async throws -> [PractitionerAvailability]

    // Booking
    func bookSession(
        userId: UUID,
        practitionerId: UUID,
        sessionTypeId: UUID,
        slotId: UUID,
        isComplimentary: Bool
    ) async throws -> DoctorSession

    func cancelSession(sessionId: UUID, reason: String?) async throws

    // User sessions
    func upcomingSessions(userId: UUID) async throws -> [DoctorSession]
    func pastSessions(userId: UUID) async throws -> [DoctorSession]

    // Complimentary tracking
    func complimentaryAllowance(userId: UUID, month: Date) async throws -> ComplimentarySessionAllowance
}
