import Foundation

enum BiomarkerCategory: String, Codable, Sendable, CaseIterable {
    case inflammation
    case metabolic
    case hormones
    case nutrients
    case cardiovascular

    var displayName: String {
        switch self {
        case .inflammation: "Inflammation"
        case .metabolic: "Metabolic Health"
        case .hormones: "Hormones"
        case .nutrients: "Nutrients"
        case .cardiovascular: "Cardiovascular"
        }
    }

    var icon: String {
        switch self {
        case .inflammation: "flame"
        case .metabolic: "bolt.heart"
        case .hormones: "waveform.path.ecg"
        case .nutrients: "leaf"
        case .cardiovascular: "heart"
        }
    }
}

enum BiomarkerStatus: String, Codable, Sendable {
    case optimal
    case normal
    case attention
    case concern

    var displayName: String {
        switch self {
        case .optimal: "Optimal"
        case .normal: "Normal"
        case .attention: "Needs attention"
        case .concern: "Worth looking into"
        }
    }
}

enum BiomarkerSource: String, Codable, Sendable {
    case mock
    case manual
    case lykon
    case cerascreen
    case labImport = "lab_import"
}

struct BiomarkerProfile: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    var biologicalAge: Double
    var chronologicalAge: Int
    var overallScore: Int
    var isMock: Bool
    var source: BiomarkerSource
    let recordedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case biologicalAge = "biological_age"
        case chronologicalAge = "chronological_age"
        case overallScore = "overall_score"
        case isMock = "is_mock"
        case source
        case recordedAt = "recorded_at"
    }

    var ageDifference: Double {
        Double(chronologicalAge) - biologicalAge
    }

    var ageDifferenceFormatted: String {
        let diff = ageDifference
        if diff > 0 {
            return String(format: "%.1f years younger", diff)
        } else if diff < 0 {
            return String(format: "%.1f years older", abs(diff))
        }
        return "Right on track"
    }
}

extension BiomarkerProfile {
    static let preview = BiomarkerProfile(
        id: UUID(),
        userId: UUID(),
        biologicalAge: 29.5,
        chronologicalAge: 33,
        overallScore: 76,
        isMock: true,
        source: .mock,
        recordedAt: Date()
    )
}
