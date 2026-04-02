import Foundation

@Observable
@MainActor
final class BiomarkerViewModel {
    // MARK: - State

    var profile: BiomarkerProfile?
    var biomarkers: [Biomarker] = []
    var selectedCategory: BiomarkerCategory?
    var isLoading = false
    var errorMessage: String?

    private let service: BiomarkerServiceProtocol = MockBiomarkerService()
    private let userId = UUID() // TODO: Wire to real auth

    // MARK: - Actions

    func loadDashboard() async {
        isLoading = true

        do {
            profile = try await service.currentProfile(userId: userId)

            if profile == nil {
                // Generate initial profile for new users
                profile = try await service.generateInitialProfile(userId: userId, chronologicalAge: 33)
            }

            if let profileId = profile?.id {
                biomarkers = try await service.biomarkers(profileId: profileId)
            }
        } catch {
            errorMessage = "Could not load your biomarker data."
        }

        isLoading = false
    }

    func loadCategory(_ category: BiomarkerCategory) async {
        guard let profileId = profile?.id else { return }

        do {
            let filtered = try await service.biomarkers(profileId: profileId, category: category)
            biomarkers = filtered
        } catch {
            errorMessage = "Could not load biomarkers for \(category.displayName)."
        }
    }

    // MARK: - Computed

    var isUsingMockData: Bool {
        profile?.isMock ?? true
    }

    var categorySummaries: [CategorySummary] {
        BiomarkerCategory.allCases.map { category in
            let markers = biomarkers.filter { $0.category == category }
            let avgStatus = dominantStatus(markers)
            let score = categoryScore(markers)
            return CategorySummary(
                category: category,
                markerCount: markers.count,
                dominantStatus: avgStatus,
                score: score
            )
        }
    }

    var attentionMarkers: [Biomarker] {
        biomarkers.filter { $0.status == .attention || $0.status == .concern }
    }

    var optimalMarkers: [Biomarker] {
        biomarkers.filter { $0.status == .optimal }
    }

    struct CategorySummary: Identifiable {
        let category: BiomarkerCategory
        let markerCount: Int
        let dominantStatus: BiomarkerStatus
        let score: Int

        var id: String { category.rawValue }
    }

    // MARK: - Helpers

    private func dominantStatus(_ markers: [Biomarker]) -> BiomarkerStatus {
        guard !markers.isEmpty else { return .normal }

        if markers.contains(where: { $0.status == .concern }) { return .concern }
        if markers.contains(where: { $0.status == .attention }) { return .attention }
        if markers.allSatisfy({ $0.status == .optimal }) { return .optimal }
        return .normal
    }

    private func categoryScore(_ markers: [Biomarker]) -> Int {
        guard !markers.isEmpty else { return 75 }

        let scores = markers.map { marker -> Int in
            switch marker.status {
            case .optimal: return 90
            case .normal: return 75
            case .attention: return 55
            case .concern: return 35
            }
        }
        return scores.reduce(0, +) / scores.count
    }
}
