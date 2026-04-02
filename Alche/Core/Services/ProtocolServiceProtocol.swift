import Foundation

protocol ProtocolServiceProtocol: Sendable {
    func allProtocols() async throws -> [HealthProtocol]
    func protocols(goal: ProtocolGoal) async throws -> [HealthProtocol]
    func healthProtocol(id: UUID) async throws -> HealthProtocol
    func logStep(userId: UUID, protocolId: UUID, stepIndex: Int, completed: Bool) async throws -> ProtocolLog
    func todayLogs(userId: UUID) async throws -> [ProtocolLog]
    func logHistory(userId: UUID, protocolId: UUID) async throws -> [ProtocolLog]
    func dailyCheckin(userId: UUID, energy: Int, sleepQuality: Int, mood: Int, notes: String?) async throws -> DailyCheckin
    func checkinHistory(userId: UUID, from: Date, to: Date) async throws -> [DailyCheckin]
    func todayCheckin(userId: UUID) async throws -> DailyCheckin?
}
