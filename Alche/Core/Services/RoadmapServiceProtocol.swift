import Foundation

protocol RoadmapServiceProtocol: Sendable {
    func phases(projectId: UUID) async throws -> [RoadmapPhase]
    func phase(id: UUID) async throws -> RoadmapPhase
}
