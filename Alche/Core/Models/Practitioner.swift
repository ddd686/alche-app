import Foundation
import SwiftUI

// MARK: - Practitioner Specialty

enum PractitionerSpecialty: String, Codable, Sendable, CaseIterable, Hashable {
    case longevityWellness
    case nutritionalGuidance
    case sleepOptimization
    case stressManagement
    case movementRecovery
    case skinWellness

    var displayName: String {
        switch self {
        case .longevityWellness: "Longevity Wellness"
        case .nutritionalGuidance: "Nutritional Guidance"
        case .sleepOptimization: "Sleep Optimization"
        case .stressManagement: "Stress Management"
        case .movementRecovery: "Movement & Recovery"
        case .skinWellness: "Skin Wellness"
        }
    }

    var icon: String {
        switch self {
        case .longevityWellness: "heart.circle"
        case .nutritionalGuidance: "leaf.circle"
        case .sleepOptimization: "moon.circle"
        case .stressManagement: "brain.head.profile"
        case .movementRecovery: "figure.walk.circle"
        case .skinWellness: "sparkles"
        }
    }
}

// MARK: - Session Status

enum SessionStatus: String, Codable, Sendable, Hashable {
    case confirmed
    case completed
    case cancelledByMember = "cancelled_by_member"
    case cancelledByPractitioner = "cancelled_by_practitioner"
    case noShow = "no_show"

    var displayName: String {
        switch self {
        case .confirmed: "Confirmed"
        case .completed: "Completed"
        case .cancelledByMember: "Cancelled"
        case .cancelledByPractitioner: "Cancelled by Practitioner"
        case .noShow: "No Show"
        }
    }

    var color: Color {
        switch self {
        case .confirmed: Color.alcheSage
        case .completed: Color.alchePrimary
        case .cancelledByMember: Color.alcheEditorialAccent
        case .cancelledByPractitioner: Color.alcheEditorialAccent
        case .noShow: Color.alcheEditorialMuted
        }
    }
}

// MARK: - Session Duration

enum SessionDuration: Int, Codable, Sendable, Hashable {
    case thirtyMinutes = 30
    case sixtyMinutes = 60

    var displayName: String {
        switch self {
        case .thirtyMinutes: "30 min"
        case .sixtyMinutes: "60 min"
        }
    }
}

// MARK: - Practitioner

struct Practitioner: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    var name: String
    var title: String
    var bio: String
    var photoURL: String?
    var specialties: [PractitionerSpecialty]
    var languages: [String]
    var rating: Double?
    var reviewCount: Int
    var isActive: Bool
    var sortOrder: Int
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case bio
        case photoURL = "photo_url"
        case specialties
        case languages
        case rating
        case reviewCount = "review_count"
        case isActive = "is_active"
        case sortOrder = "sort_order"
        case createdAt = "created_at"
    }

    var formattedRating: String {
        guard let rating else { return "New" }
        return String(format: "%.1f", rating)
    }

    var primarySpecialty: PractitionerSpecialty {
        specialties.first ?? .longevityWellness
    }
}

// MARK: - SessionType

struct SessionType: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let practitionerId: UUID
    var name: String
    var durationMinutes: Int
    var priceCents: Int
    var description: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case practitionerId = "practitioner_id"
        case name
        case durationMinutes = "duration_minutes"
        case priceCents = "price_cents"
        case description
        case createdAt = "created_at"
    }

    var formattedPrice: String {
        let euros = Double(priceCents) / 100.0
        return String(format: "\u{20AC}%.0f", euros)
    }

    var formattedDuration: String {
        "\(durationMinutes) min"
    }

    var isComplimentaryEligible: Bool {
        priceCents > 0
    }
}

// MARK: - Preview Data

extension Practitioner {
    static let previewHoffmann = Practitioner(
        id: UUID(uuidString: "A0000001-0001-0001-0001-000000000001")!,
        name: "Dr. Lena Hoffmann",
        title: "Longevity Wellness Practitioner",
        bio: "Integrative wellness practitioner with 12 years of experience in longevity protocols and circadian health. Based in Berlin Mitte, Lena combines evidence-based lifestyle design with a deep understanding of sleep architecture and recovery science. She helps members build sustainable routines that support long-term vitality.",
        photoURL: nil,
        specialties: [.longevityWellness, .sleepOptimization],
        languages: ["German", "English"],
        rating: 4.9,
        reviewCount: 127,
        isActive: true,
        sortOrder: 0,
        createdAt: Date().addingTimeInterval(-86400 * 180)
    )

    static let previewReeves = Practitioner(
        id: UUID(uuidString: "A0000001-0001-0001-0001-000000000002")!,
        name: "Dr. Marco Reeves",
        title: "Functional Nutrition Specialist",
        bio: "Specializing in functional nutrition and stress resilience. Former research fellow at King's College London, now practicing in Berlin. Marco supports members in optimizing their nutritional strategies and building adaptive stress responses through evidence-based protocols and personalized guidance.",
        photoURL: nil,
        specialties: [.nutritionalGuidance, .stressManagement],
        languages: ["English"],
        rating: 4.7,
        reviewCount: 89,
        isActive: true,
        sortOrder: 1,
        createdAt: Date().addingTimeInterval(-86400 * 150)
    )

    static let previewPatel = Practitioner(
        id: UUID(uuidString: "A0000001-0001-0001-0001-000000000003")!,
        name: "Dr. Anika Patel",
        title: "Movement & Skin Wellness Advisor",
        bio: "Movement specialist and skin wellness advisor focused on recovery protocols and appearance-based wellness tracking. Anika brings a holistic approach to physical resilience, helping members integrate movement, recovery, and skin health into their daily longevity practice at alche Berlin.",
        photoURL: nil,
        specialties: [.skinWellness, .movementRecovery],
        languages: ["English", "German"],
        rating: 4.8,
        reviewCount: 103,
        isActive: true,
        sortOrder: 2,
        createdAt: Date().addingTimeInterval(-86400 * 120)
    )

    static let previewWeber = Practitioner(
        id: UUID(uuidString: "A0000001-0001-0001-0001-000000000004")!,
        name: "Dr. Jonas Weber",
        title: "Holistic Wellness Practitioner",
        bio: "Holistic wellness practitioner combining nutritional science with longevity-focused lifestyle design. Born and raised in Kreuzberg, Jonas brings a grounded, Berlin-native perspective to wellness guidance. He supports members in making sustainable changes that align nutrition, movement, and rest.",
        photoURL: nil,
        specialties: [.longevityWellness, .nutritionalGuidance],
        languages: ["German", "English"],
        rating: 4.6,
        reviewCount: 72,
        isActive: true,
        sortOrder: 3,
        createdAt: Date().addingTimeInterval(-86400 * 90)
    )

    static let preview = previewHoffmann

    static let allPreviews: [Practitioner] = [
        previewHoffmann,
        previewReeves,
        previewPatel,
        previewWeber,
    ]
}

extension SessionType {
    static let previewInitialConsultation = SessionType(
        id: UUID(uuidString: "B0000001-0001-0001-0001-000000000001")!,
        practitionerId: Practitioner.previewHoffmann.id,
        name: "Initial Consultation",
        durationMinutes: 60,
        priceCents: 12900,
        description: "A comprehensive first session to review your wellness goals, current protocols, and Glow Scan trends. Together, we build a personalized longevity roadmap.",
        createdAt: Date().addingTimeInterval(-86400 * 180)
    )

    static let previewFollowUp = SessionType(
        id: UUID(uuidString: "B0000001-0001-0001-0001-000000000002")!,
        practitionerId: Practitioner.previewHoffmann.id,
        name: "Follow-Up Session",
        durationMinutes: 30,
        priceCents: 7900,
        description: "A focused check-in to review your progress, adjust protocols, and address any questions since your last visit.",
        createdAt: Date().addingTimeInterval(-86400 * 180)
    )

    static let previewProtocolReview = SessionType(
        id: UUID(uuidString: "B0000001-0001-0001-0001-000000000003")!,
        practitionerId: Practitioner.previewHoffmann.id,
        name: "Protocol Review",
        durationMinutes: 30,
        priceCents: 7900,
        description: "A detailed review of your current daily protocols with data-informed adjustments to support your longevity journey.",
        createdAt: Date().addingTimeInterval(-86400 * 180)
    )

    static let previewDeepDive = SessionType(
        id: UUID(uuidString: "B0000001-0001-0001-0001-000000000004")!,
        practitionerId: Practitioner.previewHoffmann.id,
        name: "Deep Dive Consultation",
        durationMinutes: 60,
        priceCents: 15900,
        description: "An extended session for members who want a thorough deep dive into their biomarkers, lifestyle patterns, and long-term optimization strategy.",
        createdAt: Date().addingTimeInterval(-86400 * 180)
    )

    static let preview = previewInitialConsultation

    static let allPreviews: [SessionType] = [
        previewInitialConsultation,
        previewFollowUp,
        previewProtocolReview,
        previewDeepDive,
    ]
}
