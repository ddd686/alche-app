import Foundation

// MARK: - DoctorSession

struct DoctorSession: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    let practitionerId: UUID
    let sessionTypeId: UUID
    let availabilitySlotId: UUID
    var scheduledDate: Date
    var startTime: Date
    var endTime: Date
    var status: SessionStatus
    var isComplimentary: Bool
    var priceCents: Int
    var stripePaymentIntentId: String?
    var cancellationReason: String?
    var cancelledAt: Date?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case practitionerId = "practitioner_id"
        case sessionTypeId = "session_type_id"
        case availabilitySlotId = "availability_slot_id"
        case scheduledDate = "scheduled_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case status
        case isComplimentary = "is_complimentary"
        case priceCents = "price_cents"
        case stripePaymentIntentId = "stripe_payment_intent_id"
        case cancellationReason = "cancellation_reason"
        case cancelledAt = "cancelled_at"
        case createdAt = "created_at"
    }

    var isUpcoming: Bool {
        scheduledDate > Date() && status == .confirmed
    }

    var canCancel: Bool {
        isUpcoming && startTime > Date().addingTimeInterval(24 * 3600)
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter.string(from: scheduledDate)
    }

    var formattedShortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: scheduledDate)
    }

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: startTime)) \u{2013} \(formatter.string(from: endTime))"
    }

    var formattedPrice: String {
        if isComplimentary {
            return "Complimentary"
        }
        let euros = Double(priceCents) / 100.0
        return String(format: "\u{20AC}%.0f", euros)
    }

    var durationMinutes: Int {
        Int(endTime.timeIntervalSince(startTime) / 60)
    }
}

// MARK: - ComplimentarySessionAllowance

struct ComplimentarySessionAllowance: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    var periodStart: Date
    var periodEnd: Date
    var totalAllowed: Int
    var used: Int
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case periodStart = "period_start"
        case periodEnd = "period_end"
        case totalAllowed = "total_allowed"
        case used
        case createdAt = "created_at"
    }

    var remaining: Int {
        max(0, totalAllowed - used)
    }

    var hasAvailable: Bool {
        remaining > 0
    }

    var formattedPeriod: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: periodStart)
    }
}

// MARK: - Preview Data

extension DoctorSession {
    static let previewUpcoming: DoctorSession = {
        let calendar = Calendar.current
        let futureDate = calendar.date(byAdding: .day, value: 3, to: Date())!
        let scheduledDate = calendar.startOfDay(for: futureDate)
        let startTime = calendar.date(bySettingHour: 10, minute: 30, second: 0, of: futureDate)!
        let endTime = calendar.date(bySettingHour: 11, minute: 0, second: 0, of: futureDate)!

        return DoctorSession(
            id: UUID(uuidString: "C1000001-0000-0000-0000-000000000001")!,
            userId: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            practitionerId: Practitioner.previewHoffmann.id,
            sessionTypeId: SessionType.previewFollowUp.id,
            availabilitySlotId: UUID(),
            scheduledDate: scheduledDate,
            startTime: startTime,
            endTime: endTime,
            status: .confirmed,
            isComplimentary: false,
            priceCents: 7900,
            stripePaymentIntentId: "pi_mock_001",
            cancellationReason: nil,
            cancelledAt: nil,
            createdAt: Date().addingTimeInterval(-86400)
        )
    }()

    static let previewPastReeves: DoctorSession = {
        let calendar = Calendar.current
        let pastDate = calendar.date(byAdding: .day, value: -21, to: Date())!
        let scheduledDate = calendar.startOfDay(for: pastDate)
        let startTime = calendar.date(bySettingHour: 14, minute: 0, second: 0, of: pastDate)!
        let endTime = calendar.date(bySettingHour: 15, minute: 0, second: 0, of: pastDate)!

        return DoctorSession(
            id: UUID(uuidString: "C1000001-0000-0000-0000-000000000002")!,
            userId: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            practitionerId: Practitioner.previewReeves.id,
            sessionTypeId: SessionType.previewInitialConsultation.id,
            availabilitySlotId: UUID(),
            scheduledDate: scheduledDate,
            startTime: startTime,
            endTime: endTime,
            status: .completed,
            isComplimentary: false,
            priceCents: 12900,
            stripePaymentIntentId: "pi_mock_002",
            cancellationReason: nil,
            cancelledAt: nil,
            createdAt: pastDate.addingTimeInterval(-86400 * 3)
        )
    }()

    static let previewPastHoffmann: DoctorSession = {
        let calendar = Calendar.current
        let pastDate = calendar.date(byAdding: .day, value: -42, to: Date())!
        let scheduledDate = calendar.startOfDay(for: pastDate)
        let startTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: pastDate)!
        let endTime = calendar.date(bySettingHour: 9, minute: 30, second: 0, of: pastDate)!

        return DoctorSession(
            id: UUID(uuidString: "C1000001-0000-0000-0000-000000000003")!,
            userId: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            practitionerId: Practitioner.previewHoffmann.id,
            sessionTypeId: SessionType.previewFollowUp.id,
            availabilitySlotId: UUID(),
            scheduledDate: scheduledDate,
            startTime: startTime,
            endTime: endTime,
            status: .completed,
            isComplimentary: true,
            priceCents: 0,
            stripePaymentIntentId: nil,
            cancellationReason: nil,
            cancelledAt: nil,
            createdAt: pastDate.addingTimeInterval(-86400 * 5)
        )
    }()

    static let preview = previewUpcoming

    static let allPreviews: [DoctorSession] = [
        previewUpcoming,
        previewPastReeves,
        previewPastHoffmann
    ]
}

extension ComplimentarySessionAllowance {
    static let preview: ComplimentarySessionAllowance = {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month], from: now)
        let periodStart = calendar.date(from: components)!
        var endComponents = components
        endComponents.month = (endComponents.month ?? 1) + 1
        endComponents.day = 0
        let periodEnd = calendar.date(from: endComponents) ?? calendar.date(byAdding: .month, value: 1, to: periodStart)!

        return ComplimentarySessionAllowance(
            id: UUID(),
            userId: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            periodStart: periodStart,
            periodEnd: periodEnd,
            totalAllowed: 1,
            used: 0,
            createdAt: periodStart
        )
    }()

    static let allPreviews: [ComplimentarySessionAllowance] = [preview]
}
