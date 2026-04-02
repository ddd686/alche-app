import XCTest
@testable import Alche

@MainActor
final class RoadmapTests: XCTestCase {

    // MARK: - Model Tests

    func testRoadmapPhaseConformsToProtocols() {
        let phase = RoadmapPhase.preview
        XCTAssertNotNil(phase.id)
        XCTAssertEqual(phase.phaseNumber, 1)
        XCTAssertEqual(phase.status, .completed)
    }

    func testPhaseStatusRawValues() {
        XCTAssertEqual(PhaseStatus.completed.rawValue, "completed")
        XCTAssertEqual(PhaseStatus.active.rawValue, "active")
        XCTAssertEqual(PhaseStatus.locked.rawValue, "locked")
    }

    func testAllPreviewsHasThreePhases() {
        let phases = RoadmapPhase.allPreviews
        XCTAssertEqual(phases.count, 3)
        XCTAssertEqual(phases[0].status, .completed)
        XCTAssertEqual(phases[1].status, .active)
        XCTAssertEqual(phases[2].status, .locked)
    }

    func testPhaseNumberOrdering() {
        let phases = RoadmapPhase.allPreviews
        for (index, phase) in phases.enumerated() {
            XCTAssertEqual(phase.phaseNumber, index + 1)
        }
    }

    func testCompletedPhaseHasFullProgress() {
        let completed = RoadmapPhase.allPreviews.first { $0.status == .completed }
        XCTAssertNotNil(completed)
        XCTAssertEqual(completed?.progress, 1.0)
    }

    func testLockedPhaseHasZeroProgress() {
        let locked = RoadmapPhase.allPreviews.first { $0.status == .locked }
        XCTAssertNotNil(locked)
        XCTAssertEqual(locked?.progress, 0.0)
    }

    func testPhaseHashable() {
        let phase1 = RoadmapPhase.allPreviews[0]
        let phase2 = RoadmapPhase.allPreviews[1]
        var set = Set<RoadmapPhase>()
        set.insert(phase1)
        set.insert(phase2)
        XCTAssertEqual(set.count, 2)
    }

    func testPhaseCodable() throws {
        let phase = RoadmapPhase.preview
        let data = try JSONEncoder().encode(phase)
        let decoded = try JSONDecoder().decode(RoadmapPhase.self, from: data)
        XCTAssertEqual(decoded.id, phase.id)
        XCTAssertEqual(decoded.title, phase.title)
        XCTAssertEqual(decoded.status, phase.status)
        XCTAssertEqual(decoded.progress, phase.progress)
    }

    func testPhaseCodingKeysSnakeCase() throws {
        let phase = RoadmapPhase.preview
        let data = try JSONEncoder().encode(phase)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        XCTAssertNotNil(json?["phase_number"])
        XCTAssertNotNil(json?["project_id"])
        XCTAssertNotNil(json?["week_range"])
        XCTAssertNotNil(json?["primary_label"])
        XCTAssertNotNil(json?["primary_value"])
        XCTAssertNotNil(json?["secondary_label"])
        XCTAssertNotNil(json?["secondary_value"])
    }

    // MARK: - ViewModel Tests

    func testViewModelInitialState() {
        let vm = RoadmapViewModel()
        XCTAssertTrue(vm.phases.isEmpty)
        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.errorMessage)
        XCTAssertTrue(vm.isUsingMockData)
    }

    func testViewModelLoadsPhases() async {
        let vm = RoadmapViewModel()
        await vm.loadPhases()
        XCTAssertEqual(vm.phases.count, 3)
        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.errorMessage)
    }

    func testViewModelActivePhase() async {
        let vm = RoadmapViewModel()
        await vm.loadPhases()
        let active = vm.activePhase
        XCTAssertNotNil(active)
        XCTAssertEqual(active?.status, .active)
        XCTAssertEqual(active?.title, "Cellular Repair")
    }

    func testViewModelCompletedCount() async {
        let vm = RoadmapViewModel()
        await vm.loadPhases()
        XCTAssertEqual(vm.completedCount, 1)
    }

    func testViewModelTotalCount() async {
        let vm = RoadmapViewModel()
        await vm.loadPhases()
        XCTAssertEqual(vm.totalCount, 3)
    }

    // MARK: - Service Tests

    func testMockServiceReturnsPhases() async throws {
        let service = MockRoadmapService()
        let phases = try await service.phases(projectId: UUID())
        XCTAssertEqual(phases.count, 3)
    }

    func testMockServicePhaseOrder() async throws {
        let service = MockRoadmapService()
        let phases = try await service.phases(projectId: UUID())
        XCTAssertEqual(phases[0].phaseNumber, 1)
        XCTAssertEqual(phases[1].phaseNumber, 2)
        XCTAssertEqual(phases[2].phaseNumber, 3)
    }
}
