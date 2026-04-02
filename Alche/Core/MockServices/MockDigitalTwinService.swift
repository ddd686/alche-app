import Foundation

/// Mock implementation of DigitalTwinServiceProtocol.
/// Derives visualization state from mock biomarker data.
/// Healthy areas pulse in sage green, attention areas glow in amber.
final class MockDigitalTwinService: DigitalTwinServiceProtocol {

    private let generator = MockDataGenerator.shared
    private let biomarkerService = MockBiomarkerService()
    private let userDefaultsKey = "alche.mock.digitalTwin"

    func currentState(userId: UUID) async throws -> DigitalTwinState? {
        loadState(userId: userId)
    }

    func generateState(userId: UUID, biomarkerProfileId: UUID) async throws -> DigitalTwinState {
        // Simulate processing
        try await Task.sleep(for: .seconds(1.0))

        let biomarkers = try await biomarkerService.biomarkers(profileId: biomarkerProfileId)

        let regionStates = TwinRegion.allCases.map { region in
            regionState(for: region, from: biomarkers, userId: userId)
        }

        let projections = generateProjections(from: regionStates)

        let state = DigitalTwinState(
            id: UUID(),
            userId: userId,
            biomarkerProfileId: biomarkerProfileId,
            regionStates: regionStates,
            futureProjection: projections,
            isMock: true,
            generatedAt: Date()
        )

        saveState(state, userId: userId)
        return state
    }

    func futureProjection(userId: UUID, weeks: Int) async throws -> [FutureProjection] {
        guard let state = loadState(userId: userId) else { return [] }

        return state.regionStates
            .filter { $0.status == .attention || $0.status == .concern }
            .map { region in
                let improvement = generator.seededRandom(
                    userId: userId,
                    offset: region.region.hashValue + weeks,
                    min: 8,
                    max: 18
                )
                return FutureProjection(
                    region: region.region,
                    currentScore: region.score,
                    projectedScore: min(region.score + improvement, 92),
                    timeframeWeeks: weeks,
                    protocolFollowed: true
                )
            }
    }

    // MARK: - Region Score Derivation

    private func regionState(for region: TwinRegion, from biomarkers: [Biomarker], userId: UUID) -> RegionState {
        let linkedCategories = region.linkedCategories
        let relevantMarkers = biomarkers.filter { linkedCategories.contains($0.category) }

        let score: Int
        if relevantMarkers.isEmpty {
            score = generator.seededRandom(userId: userId, offset: region.hashValue, min: 68, max: 82)
        } else {
            // Derive score from marker statuses
            let statusScores = relevantMarkers.map { marker -> Int in
                switch marker.status {
                case .optimal: return generator.seededRandom(userId: userId, offset: marker.hashValue, min: 82, max: 92)
                case .normal: return generator.seededRandom(userId: userId, offset: marker.hashValue, min: 70, max: 82)
                case .attention: return generator.seededRandom(userId: userId, offset: marker.hashValue, min: 55, max: 70)
                case .concern: return generator.seededRandom(userId: userId, offset: marker.hashValue, min: 40, max: 58)
                }
            }
            score = statusScores.reduce(0, +) / statusScores.count
        }

        let status: RegionStatus
        switch score {
        case 80...100: status = .thriving
        case 68..<80: status = .balanced
        case 55..<68: status = .attention
        default: status = .concern
        }

        return RegionState(
            region: region,
            status: status,
            score: score,
            linkedCategories: linkedCategories
        )
    }

    // MARK: - Projections

    private func generateProjections(from regions: [RegionState]) -> [FutureProjection] {
        regions
            .filter { $0.status == .attention || $0.status == .concern }
            .map { region in
                let improvement = min(92 - region.score, 18)
                return FutureProjection(
                    region: region.region,
                    currentScore: region.score,
                    projectedScore: region.score + improvement,
                    timeframeWeeks: 12,
                    protocolFollowed: true
                )
            }
    }

    // MARK: - Persistence

    private func loadState(userId: UUID) -> DigitalTwinState? {
        let key = "\(userDefaultsKey).\(userId.uuidString)"
        guard let data = UserDefaults.standard.data(forKey: key),
              let state = try? JSONDecoder().decode(DigitalTwinState.self, from: data) else {
            return nil
        }
        return state
    }

    private func saveState(_ state: DigitalTwinState, userId: UUID) {
        let key = "\(userDefaultsKey).\(userId.uuidString)"
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
