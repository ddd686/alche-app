import Foundation

protocol EventServiceProtocol: Sendable {
    func upcomingEvents() async throws -> [Event]
    func event(id: UUID) async throws -> Event
    func rsvp(eventId: UUID, userId: UUID) async throws -> RSVP
    func cancelRSVP(eventId: UUID, userId: UUID) async throws
    func userRSVPs(userId: UUID) async throws -> [RSVP]
    func isUserRSVPd(eventId: UUID, userId: UUID) async throws -> Bool
}
