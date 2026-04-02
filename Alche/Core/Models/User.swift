import Foundation

struct AlcheUser: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    var displayName: String?
    var avatarURL: String?
    var locale: String
    var healthGoals: [String]
    var onboardingCompleted: Bool
    var referralCode: String?
    var referredBy: UUID?
    let createdAt: Date
    var updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case avatarURL = "avatar_url"
        case locale
        case healthGoals = "health_goals"
        case onboardingCompleted = "onboarding_completed"
        case referralCode = "referral_code"
        case referredBy = "referred_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

extension AlcheUser {
    static let preview = AlcheUser(
        id: UUID(),
        displayName: "Lena M.",
        avatarURL: nil,
        locale: "en",
        healthGoals: ["energy", "glow", "sleep"],
        onboardingCompleted: true,
        referralCode: "LENA2026",
        referredBy: nil,
        createdAt: Date(),
        updatedAt: Date()
    )
}
