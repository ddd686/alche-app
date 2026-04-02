import Foundation

enum MembershipTier: String, Codable, Sendable, CaseIterable {
    case free
    case core
    case pro
    case premium

    var displayName: String {
        switch self {
        case .free: "Explorer"
        case .core: "Core"
        case .pro: "Pro"
        case .premium: "Premium"
        }
    }

    var monthlyPriceCents: Int {
        switch self {
        case .free: 0
        case .core: 1900
        case .pro: 4900
        case .premium: 9900
        }
    }

    var ledCreditsPerMonth: Int {
        switch self {
        case .free: 0
        case .core: 2
        case .pro: 8
        case .premium: 30
        }
    }
}

enum MembershipStatus: String, Codable, Sendable {
    case active
    case paused
    case cancelled
    case trial
}

struct Membership: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    var tier: MembershipTier
    var status: MembershipStatus
    var creditsRemaining: Int
    var stripeSubscriptionId: String?
    var appleTransactionId: String?
    var isFoundingMember: Bool
    let startedAt: Date
    var expiresAt: Date?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case tier
        case status
        case creditsRemaining = "credits_remaining"
        case stripeSubscriptionId = "stripe_subscription_id"
        case appleTransactionId = "apple_transaction_id"
        case isFoundingMember = "is_founding_member"
        case startedAt = "started_at"
        case expiresAt = "expires_at"
        case createdAt = "created_at"
    }
}

extension Membership {
    static let preview = Membership(
        id: UUID(),
        userId: UUID(),
        tier: .core,
        status: .active,
        creditsRemaining: 4,
        stripeSubscriptionId: nil,
        appleTransactionId: nil,
        isFoundingMember: true,
        startedAt: Date(),
        expiresAt: nil,
        createdAt: Date()
    )
}
