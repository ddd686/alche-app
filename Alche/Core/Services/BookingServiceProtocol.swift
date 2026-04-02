import Foundation

struct BookingSlot: Sendable, Hashable {
    let start: Date
    let end: Date
    let sessionType: LEDSessionType
    let available: Bool
    let remainingCapacity: Int
}

protocol BookingServiceProtocol: Sendable {
    func availableSlots(date: Date, serviceType: ServiceType) async throws -> [BookingSlot]
    func createBooking(slot: BookingSlot, userId: UUID, smoothiePreorderId: UUID?) async throws -> Booking
    func cancelBooking(id: UUID) async throws
    func checkIn(bookingId: UUID, qrCode: String) async throws -> Booking
    func upcomingBookings(userId: UUID) async throws -> [Booking]
    func pastBookings(userId: UUID) async throws -> [Booking]
    func booking(id: UUID) async throws -> Booking
}
