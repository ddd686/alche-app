import Foundation

enum TwinRegion: String, Codable, Sendable, CaseIterable {
    case skin
    case cardiovascular
    case metabolic
    case immune
    case hormonal
    case musculoskeletal
    case cognitive

    var displayName: String {
        switch self {
        case .skin: "Skin & Glow"
        case .cardiovascular: "Heart & Circulation"
        case .metabolic: "Metabolism"
        case .immune: "Immune System"
        case .hormonal: "Hormonal Balance"
        case .musculoskeletal: "Muscles & Joints"
        case .cognitive: "Mind & Focus"
        }
    }

    var linkedCategories: [BiomarkerCategory] {
        switch self {
        case .skin: [.nutrients]
        case .cardiovascular: [.cardiovascular]
        case .metabolic: [.metabolic]
        case .immune: [.inflammation, .nutrients]
        case .hormonal: [.hormones]
        case .musculoskeletal: [.inflammation, .nutrients]
        case .cognitive: [.hormones, .nutrients]
        }
    }
}

enum RegionStatus: String, Codable, Sendable {
    case thriving
    case balanced
    case attention
    case concern

    var colorName: String {
        switch self {
        case .thriving: "sage"
        case .balanced: "sage"
        case .attention: "amber"
        case .concern: "terra"
        }
    }
}

struct RegionState: Codable, Sendable, Hashable {
    var region: TwinRegion
    var status: RegionStatus
    var score: Int
    var linkedCategories: [BiomarkerCategory]
}

struct FutureProjection: Codable, Sendable, Hashable {
    var region: TwinRegion
    var currentScore: Int
    var projectedScore: Int
    var timeframeWeeks: Int
    var protocolFollowed: Bool

    var improvement: Int {
        projectedScore - currentScore
    }
}

struct DigitalTwinState: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    let biomarkerProfileId: UUID
    var regionStates: [RegionState]
    var futureProjection: [FutureProjection]?
    var isMock: Bool
    let generatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case biomarkerProfileId = "biomarker_profile_id"
        case regionStates = "region_states"
        case futureProjection = "future_projection"
        case isMock = "is_mock"
        case generatedAt = "generated_at"
    }

    var overallScore: Int {
        guard !regionStates.isEmpty else { return 0 }
        return regionStates.reduce(0) { $0 + $1.score } / regionStates.count
    }

    var attentionRegions: [RegionState] {
        regionStates.filter { $0.status == .attention || $0.status == .concern }
    }

    var thrivingRegions: [RegionState] {
        regionStates.filter { $0.status == .thriving }
    }
}

extension DigitalTwinState {
    static let preview = DigitalTwinState(
        id: UUID(),
        userId: UUID(),
        biomarkerProfileId: UUID(),
        regionStates: [
            RegionState(region: .skin, status: .balanced, score: 72, linkedCategories: [.nutrients]),
            RegionState(region: .cardiovascular, status: .thriving, score: 85, linkedCategories: [.cardiovascular]),
            RegionState(region: .metabolic, status: .balanced, score: 78, linkedCategories: [.metabolic]),
            RegionState(region: .immune, status: .attention, score: 64, linkedCategories: [.inflammation, .nutrients]),
            RegionState(region: .hormonal, status: .balanced, score: 74, linkedCategories: [.hormones]),
            RegionState(region: .musculoskeletal, status: .thriving, score: 82, linkedCategories: [.inflammation, .nutrients]),
            RegionState(region: .cognitive, status: .balanced, score: 76, linkedCategories: [.hormones, .nutrients]),
        ],
        futureProjection: [
            FutureProjection(region: .immune, currentScore: 64, projectedScore: 78, timeframeWeeks: 12, protocolFollowed: true),
            FutureProjection(region: .skin, currentScore: 72, projectedScore: 82, timeframeWeeks: 8, protocolFollowed: true),
        ],
        isMock: true,
        generatedAt: Date()
    )
}
