import Foundation

@Observable
@MainActor
final class SupplementRecommendationViewModel {
    var supplements: [Supplement] = []
    var isLoading = false
    var errorMessage: String?
    var selectedGoals: Set<WellnessGoal> = []
    var supplementMappings: [SupplementMapping] = []

    private let goalService: GoalServiceProtocol = MockGoalService()

    // MARK: - Foundation supplement IDs (shared across most goals)

    private static let foundationIds: Set<String> = [
        "magnesium-glycinate",
        "omega-3",
        "vitamin-d3",
        "b-complex",
    ]

    // MARK: - Computed Properties

    var foundationSupplements: [Supplement] {
        supplements.filter { Self.foundationIds.contains($0.id) }
    }

    var goalSpecificSupplements: [Supplement] {
        supplements.filter { !Self.foundationIds.contains($0.id) }
    }

    var applicableStackingRules: [DoseStackingRules.StackRule] {
        DoseStackingRules.rules.filter { rule in
            let overlap = Set(rule.goalsServed).intersection(selectedGoals)
            return overlap.count > 1
        }
    }

    var applicableTimingConflicts: [(String, String, String)] {
        let supplementNames = Set(supplements.map(\.name))
        return DoseStackingRules.timingConflicts.filter { conflict in
            supplementNames.contains(conflict.0) && supplementNames.contains(conflict.1)
        }
    }

    // MARK: - Load

    func load() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // Default to all goals if none selected (demo mode)
            let goals = selectedGoals.isEmpty
                ? Set([WellnessGoal.deepRecovery, .stressResilience, .cellularVitality])
                : selectedGoals
            selectedGoals = goals

            supplementMappings = try await goalService.supplementMappings(for: goals)
            supplements = try await goalService.resolvedSupplements(for: goals)
        } catch {
            errorMessage = "Failed to load supplement recommendations"
        }
    }

    func loadWithGoals(_ goals: Set<WellnessGoal>) async {
        selectedGoals = goals
        await load()
    }
}
