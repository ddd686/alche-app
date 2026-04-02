import Foundation

protocol DigitalTwinServiceProtocol: Sendable {
    func currentState(userId: UUID) async throws -> DigitalTwinState?
    func generateState(userId: UUID, biomarkerProfileId: UUID) async throws -> DigitalTwinState
    func futureProjection(userId: UUID, weeks: Int) async throws -> [FutureProjection]
}
