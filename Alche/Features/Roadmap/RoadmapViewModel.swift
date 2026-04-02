import Foundation

@Observable
@MainActor
final class RoadmapViewModel {
    // MARK: - State

    var phases: [RoadmapPhase] = []
    var isLoading = false
    var errorMessage: String?

    private let service: RoadmapServiceProtocol = MockRoadmapService()
    private let projectId = UUID()

    // MARK: - Actions

    func loadPhases() async {
        isLoading = true

        do {
            phases = try await service.phases(projectId: projectId)
        } catch {
            errorMessage = "Could not load your longevity roadmap."
        }

        isLoading = false
    }

    // MARK: - Computed

    var isUsingMockData: Bool { true }

    var activePhase: RoadmapPhase? {
        phases.first { $0.status == .active }
    }

    var completedCount: Int {
        phases.filter { $0.status == .completed }.count
    }

    var totalCount: Int {
        phases.count
    }
}
