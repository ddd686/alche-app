import Foundation

protocol NutritionTrackingServiceProtocol: Sendable {
    func logMeal(_ entry: MacroLog) async throws -> MacroLog
    func todayLogs(userId: UUID) async throws -> [MacroLog]
    func logs(userId: UUID, from: Date, to: Date) async throws -> [MacroLog]
    func deleteLog(id: UUID) async throws
    func dailySummary(userId: UUID, date: Date) async throws -> DailyMacroSummary
    func macroGoal(userId: UUID) async throws -> MacroGoal?
    func updateMacroGoal(_ goal: MacroGoal) async throws -> MacroGoal
}
