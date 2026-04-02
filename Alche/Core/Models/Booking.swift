import Foundation

enum ServiceType: String, Codable, Sendable {
    case led
    case sauna
    case recovery

    var displayName: String {
        switch self {
        case .led: "LED Light"
        case .sauna: "Infrared Sauna"
        case .recovery: "Recovery"
        }
    }
}

enum LEDSessionType: String, Codable, Sendable, CaseIterable {
    case glow
    case recovery

    var displayName: String {
        switch self {
        case .glow: "Glow"
        case .recovery: "Recovery"
        }
    }

    var description: String {
        switch self {
        case .glow: "Skin-focused light experience for radiance and renewal"
        case .recovery: "Full-body light experience for muscle recovery and relaxation"
        }
    }
}

enum BookingStatus: String, Codable, Sendable {
    case confirmed
    case checkedIn = "checked_in"
    case completed
    case cancelled
    case noShow = "no_show"
}

struct Booking: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    var serviceType: ServiceType
    var sessionType: LEDSessionType?
    let slotStart: Date
    let slotEnd: Date
    var status: BookingStatus
    var qrCode: String?
    var creditsUsed: Int
    var smoothiePreorderId: UUID?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case serviceType = "service_type"
        case sessionType = "session_type"
        case slotStart = "slot_start"
        case slotEnd = "slot_end"
        case status
        case qrCode = "qr_code"
        case creditsUsed = "credits_used"
        case smoothiePreorderId = "smoothie_preorder_id"
        case createdAt = "created_at"
    }

    var isUpcoming: Bool {
        status == .confirmed && slotStart > Date()
    }

    var durationMinutes: Int {
        Int(slotEnd.timeIntervalSince(slotStart) / 60)
    }
}

extension Booking {
    static let preview = Booking(
        id: UUID(),
        userId: UUID(),
        serviceType: .led,
        sessionType: .glow,
        slotStart: Date().addingTimeInterval(3600),
        slotEnd: Date().addingTimeInterval(4500),
        status: .confirmed,
        qrCode: "ALCHE-\(UUID().uuidString.prefix(8))",
        creditsUsed: 1,
        smoothiePreorderId: nil,
        createdAt: Date()
    )
}
