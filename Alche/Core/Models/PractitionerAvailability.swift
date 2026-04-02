import Foundation

struct PractitionerAvailability: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let practitionerId: UUID
    var date: Date
    var startTime: Date
    var endTime: Date
    var isBooked: Bool
    var sessionTypeId: UUID?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case practitionerId = "practitioner_id"
        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case isBooked = "is_booked"
        case sessionTypeId = "session_type_id"
        case createdAt = "created_at"
    }

    var formattedTimeRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: startTime)) \u{2013} \(formatter.string(from: endTime))"
    }

    var formattedStartTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: startTime)
    }

    var isAvailable: Bool {
        !isBooked
    }

    var durationMinutes: Int {
        Int(endTime.timeIntervalSince(startTime) / 60)
    }
}

// MARK: - Preview Data

extension PractitionerAvailability {
    static let preview: PractitionerAvailability = {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let start = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: tomorrow)!
        let end = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: tomorrow)!

        return PractitionerAvailability(
            id: UUID(),
            practitionerId: Practitioner.previewHoffmann.id,
            date: tomorrow,
            startTime: start,
            endTime: end,
            isBooked: false,
            sessionTypeId: nil,
            createdAt: Date()
        )
    }()

    static let allPreviews: [PractitionerAvailability] = [preview]
}
