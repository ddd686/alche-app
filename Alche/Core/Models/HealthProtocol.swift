import Foundation

enum ProtocolGoal: String, Codable, Sendable, CaseIterable {
    case sleep
    case energy
    case recovery
    case glow
    case calm
    case gut

    var displayName: String {
        switch self {
        case .sleep: "Sleep Better"
        case .energy: "More Energy"
        case .recovery: "Recovery"
        case .glow: "Glow"
        case .calm: "Calm"
        case .gut: "Gut Health"
        }
    }
}

enum StepCategory: String, Codable, Sendable {
    case supplement
    case nutrition
    case movement
    case light
    case mindfulness
    case sleep
    case hydration
}

struct ProtocolStep: Codable, Sendable, Hashable {
    var time: String
    var action: String
    var category: StepCategory
    var detail: String?
}

struct HealthProtocol: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    var name: String
    var description: String?
    var goalTag: ProtocolGoal?
    var steps: [ProtocolStep]
    var tierRequired: MembershipTier

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case goalTag = "goal_tag"
        case steps
        case tierRequired = "tier_required"
    }
}

struct ProtocolLog: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    let protocolId: UUID
    var stepIndex: Int
    var completed: Bool
    let loggedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case protocolId = "protocol_id"
        case stepIndex = "step_index"
        case completed
        case loggedAt = "logged_at"
    }
}

extension HealthProtocol {
    static let preview = HealthProtocol(
        id: UUID(),
        name: "The Sleep Protocol",
        description: "A gentle evening routine to support deeper, more restorative sleep.",
        goalTag: .sleep,
        steps: [
            ProtocolStep(time: "18:00", action: "Last caffeine cutoff", category: .nutrition),
            ProtocolStep(time: "19:00", action: "Evening magnesium glycinate (400mg)", category: .supplement),
            ProtocolStep(time: "20:00", action: "Dim lights, warm tones only", category: .light),
            ProtocolStep(time: "21:00", action: "10 minutes breathing or journaling", category: .mindfulness),
            ProtocolStep(time: "21:30", action: "Screens off, room at 18C", category: .sleep),
        ],
        tierRequired: .free
    )
}
