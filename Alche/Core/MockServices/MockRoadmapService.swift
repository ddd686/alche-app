import Foundation

final class MockRoadmapService: RoadmapServiceProtocol, Sendable {
    func phases(projectId: UUID) async throws -> [RoadmapPhase] {
        try await Task.sleep(for: .seconds(Double.random(in: 0.3...0.6)))
        return Self.samplePhases
    }

    func phase(id: UUID) async throws -> RoadmapPhase {
        try await Task.sleep(for: .seconds(Double.random(in: 0.3...0.5)))
        guard let phase = Self.samplePhases.first(where: { $0.id == id }) else {
            throw APIError.notFound
        }
        return phase
    }
}

// MARK: - Sample Data

extension MockRoadmapService {
    private static let projectId = UUID()

    static let samplePhases: [RoadmapPhase] = [
        RoadmapPhase(
            id: UUID(),
            projectId: projectId,
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
            projectId: projectId,
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
            projectId: projectId,
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
