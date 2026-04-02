import Foundation

protocol GoalServiceProtocol: Sendable {
    func allGoals() async throws -> [WellnessGoal]
    func subGoals(for goal: WellnessGoal) async throws -> [WellnessSubGoal]
    func supplementMappings(for goals: Set<WellnessGoal>) async throws -> [SupplementMapping]
    func resolvedSupplements(for goals: Set<WellnessGoal>) async throws -> [Supplement]
    func saveUserGoals(userId: UUID, goals: Set<WellnessGoal>) async throws
    func userGoals(userId: UUID) async throws -> Set<WellnessGoal>
}
