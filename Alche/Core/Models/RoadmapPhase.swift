import Foundation

struct RoadmapPhase: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let projectId: UUID
    var phaseNumber: Int
    var title: String
    var subtitle: String
    var weekRange: String
    var status: PhaseStatus
    var primaryLabel: String
    var primaryValue: String
    var secondaryLabel: String
    var secondaryValue: String
    var progress: Double

    enum CodingKeys: String, CodingKey {
        case id
        case projectId = "project_id"
        case phaseNumber = "phase_number"
        case title
        case subtitle
        case weekRange = "week_range"
        case status
        case primaryLabel = "primary_label"
        case primaryValue = "primary_value"
        case secondaryLabel = "secondary_label"
        case secondaryValue = "secondary_value"
        case progress
    }
}

enum PhaseStatus: String, Codable, Sendable, Hashable {
    case completed
    case active
    case locked
}

// MARK: - Preview Data

extension RoadmapPhase {
    static let preview = RoadmapPhase(
        id: UUID(),
        projectId: UUID(),
        phaseNumber: 1,
        title: "Inflammation Shield",
        subtitle: "Systemic reset targeting cytokine markers. Introducing adaptogenic compounds.",
        weekRange: "Weeks 1-4",
        status: .completed,
        primaryLabel: "Goal",
        primaryValue: "CRP < 1.0",
        secondaryLabel: "Protocol",
        secondaryValue: "Curcumin+",
        progress: 1.0
    )

    static let allPreviews: [RoadmapPhase] = [
        RoadmapPhase(
            id: UUID(),
            projectId: UUID(),
            phaseNumber: 1,
            title: "Inflammation Shield",
            subtitle: "Systemic reset targeting cytokine markers. Introducing adaptogenic compounds.",
            weekRange: "Weeks 1-4",
            status: .completed,
            primaryLabel: "Goal",
            primaryValue: "CRP < 1.0",
            secondaryLabel: "Protocol",
            secondaryValue: "Curcumin+",
            progress: 1.0
        ),
        RoadmapPhase(
            id: UUID(),
            projectId: UUID(),
            phaseNumber: 2,
            title: "Cellular Repair",
            subtitle: "Autophagy activation sequence initiated. Mitochondrial support protocols active.",
            weekRange: "Weeks 5-8",
            status: .active,
            primaryLabel: "Focus",
            primaryValue: "NAD+ Boost",
            secondaryLabel: "Status",
            secondaryValue: "Active",
            progress: 0.45
        ),
        RoadmapPhase(
            id: UUID(),
            projectId: UUID(),
            phaseNumber: 3,
            title: "Genomic Stability",
            subtitle: "DNA methylation analysis required to unlock.",
            weekRange: "Weeks 9-12",
            status: .locked,
            primaryLabel: "Focus",
            primaryValue: "Telomere Support",
            secondaryLabel: "Status",
            secondaryValue: "Locked",
            progress: 0.0
        ),
    ]
}
