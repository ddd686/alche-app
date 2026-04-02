import Foundation

struct DailyCheckin: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    var date: Date
    var energy: Int
    var sleepQuality: Int
    var mood: Int
    var notes: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case date
        case energy
        case sleepQuality = "sleep_quality"
        case mood
        case notes
        case createdAt = "created_at"
    }

    var averageScore: Double {
        Double(energy + sleepQuality + mood) / 3.0
    }
}

extension DailyCheckin {
    static let preview = DailyCheckin(
        id: UUID(),
        userId: UUID(),
        date: Date(),
        energy: 4,
        sleepQuality: 3,
        mood: 4,
        notes: "Feeling good after yesterday's LED session",
        createdAt: Date()
    )
}
