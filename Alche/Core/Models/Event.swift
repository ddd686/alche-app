import Foundation

enum EventType: String, Codable, Sendable {
    case salon
    case workshop
    case community

    var displayName: String {
        switch self {
        case .salon: "Alche Salon"
        case .workshop: "Workshop"
        case .community: "Community"
        }
    }
}

enum RSVPStatus: String, Codable, Sendable {
    case confirmed
    case waitlisted
    case cancelled
}

struct Event: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    var title: String
    var description: String?
    var eventDate: Date
    var location: String?
    var capacity: Int?
    var rsvpCount: Int
    var imageURL: String?
    var eventType: EventType?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case eventDate = "event_date"
        case location
        case capacity
        case rsvpCount = "rsvp_count"
        case imageURL = "image_url"
        case eventType = "event_type"
        case createdAt = "created_at"
    }

    var spotsRemaining: Int? {
        guard let capacity else { return nil }
        return max(0, capacity - rsvpCount)
    }

    var isFull: Bool {
        guard let capacity else { return false }
        return rsvpCount >= capacity
    }

    var isUpcoming: Bool {
        eventDate > Date()
    }
}

struct RSVP: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    let eventId: UUID
    var status: RSVPStatus
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case eventId = "event_id"
        case status
        case createdAt = "created_at"
    }
}

extension Event {
    static let preview = Event(
        id: UUID(),
        title: "Winter Light: An Evening on Sleep",
        description: "Join us for an intimate conversation about the science of sleep, circadian rhythm, and how light exposure shapes your rest. Featuring a sleep-optimised smoothie tasting.",
        eventDate: Date().addingTimeInterval(86400 * 3),
        location: "Alche, Berlin Mitte",
        capacity: 30,
        rsvpCount: 22,
        imageURL: nil,
        eventType: .salon,
        createdAt: Date()
    )
}
