import Foundation

@Observable
@MainActor
final class DigitalTwinViewModel {
    // MARK: - State

    var twinState: DigitalTwinState?
    var futureProjections: [FutureProjection] = []
    var showFutureToggle = false
    var selectedRegion: RegionState?
    var showRegionDetail = false
    var isLoading = false
    var errorMessage: String?

    private let service: DigitalTwinServiceProtocol = MockDigitalTwinService()
    private let biomarkerService: BiomarkerServiceProtocol = MockBiomarkerService()
    private let userId = UUID() // TODO: Wire to real auth

    // MARK: - Actions

    func loadTwinState() async {
        isLoading = true

        do {
            twinState = try await service.currentState(userId: userId)

            if twinState == nil {
                // Generate initial state from biomarker profile
                var profile = try await biomarkerService.currentProfile(userId: userId)
                if profile == nil {
                    profile = try await biomarkerService.generateInitialProfile(userId: userId, chronologicalAge: 33)
                }
                if let profileId = profile?.id {
                    twinState = try await service.generateState(userId: userId, biomarkerProfileId: profileId)
                }
            }

            futureProjections = try await service.futureProjection(userId: userId, weeks: 12)
        } catch {
            errorMessage = "Could not load your Digital Twin."
        }

        isLoading = false
    }

    func selectRegion(_ region: RegionState) {
        selectedRegion = region
        showRegionDetail = true
    }

    func toggleFutureView() {
        showFutureToggle.toggle()
    }

    // MARK: - Computed

    var isUsingMockData: Bool {
        twinState?.isMock ?? true
    }

    var sortedRegions: [RegionState] {
        twinState?.regionStates.sorted { $0.score > $1.score } ?? []
    }

    var attentionRegions: [RegionState] {
        twinState?.attentionRegions ?? []
    }

    var thrivingRegions: [RegionState] {
        twinState?.thrivingRegions ?? []
    }

    var overallScore: Int {
        twinState?.overallScore ?? 0
    }

    func projection(for region: TwinRegion) -> FutureProjection? {
        futureProjections.first { $0.region == region }
    }
}
