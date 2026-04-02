import Foundation

protocol BiomarkerServiceProtocol: Sendable {
    func currentProfile(userId: UUID) async throws -> BiomarkerProfile?
    func profileHistory(userId: UUID) async throws -> [BiomarkerProfile]
    func biomarkers(profileId: UUID) async throws -> [Biomarker]
    func biomarkers(profileId: UUID, category: BiomarkerCategory) async throws -> [Biomarker]
    func generateInitialProfile(userId: UUID, chronologicalAge: Int) async throws -> BiomarkerProfile
}
