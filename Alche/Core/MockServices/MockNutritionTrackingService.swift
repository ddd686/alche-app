import Foundation

/// Mock implementation of NutritionTrackingServiceProtocol.
/// Persists macro logs and goals in UserDefaults.
/// Auto-creates a default MacroGoal on first access.
final class MockNutritionTrackingService: NutritionTrackingServiceProtocol {

    private let logsKey = "alche.mock.macroLogs"
    private let goalsKey = "alche.mock.macroGoals"

    func logMeal(_ entry: MacroLog) async throws -> MacroLog {
        try await Task.sleep(for: .seconds(Double.random(in: 0.2...0.5)))

        var logs = loadLogs(userId: entry.userId)
        logs.insert(entry, at: 0)
        saveLogs(logs, userId: entry.userId)
        return entry
    }

    func todayLogs(userId: UUID) async throws -> [MacroLog] {
        let today = Calendar.current.startOfDay(for: Date())
        return loadLogs(userId: userId).filter {
            Calendar.current.isDate($0.date, inSameDayAs: today)
        }.sorted { $0.loggedAt > $1.loggedAt }
    }

    func logs(userId: UUID, from: Date, to: Date) async throws -> [MacroLog] {
        loadLogs(userId: userId).filter {
            $0.date >= from && $0.date <= to
        }.sorted { $0.loggedAt > $1.loggedAt }
    }

    func deleteLog(id: UUID) async throws {
        try await Task.sleep(for: .seconds(Double.random(in: 0.2...0.3)))

        // Search all users' logs (in mock, we iterate keys)
        // Simplified: delete from all stored logs
        let defaults = UserDefaults.standard
        let allKeys = defaults.dictionaryRepresentation().keys.filter { $0.hasPrefix(logsKey) }
        for key in allKeys {
            guard let data = defaults.data(forKey: key),
                  var logs = try? JSONDecoder().decode([MacroLog].self, from: data) else { continue }
            if let index = logs.firstIndex(where: { $0.id == id }) {
                let userId = logs[index].userId
                logs.remove(at: index)
                if let encoded = try? JSONEncoder().encode(logs) {
                    defaults.set(encoded, forKey: "\(logsKey).\(userId.uuidString)")
                }
                return
            }
        }
    }

    func dailySummary(userId: UUID, date: Date) async throws -> DailyMacroSummary {
        let dayLogs = loadLogs(userId: userId).filter {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
        let goal = loadGoal(userId: userId)
        return DailyMacroSummary(date: date, entries: dayLogs, goal: goal)
    }

    func macroGoal(userId: UUID) async throws -> MacroGoal? {
        loadGoal(userId: userId)
    }

    func updateMacroGoal(_ goal: MacroGoal) async throws -> MacroGoal {
        try await Task.sleep(for: .seconds(Double.random(in: 0.2...0.4)))
        saveGoal(goal, userId: goal.userId)
        return goal
    }

    // MARK: - Persistence

    private func loadLogs(userId: UUID) -> [MacroLog] {
        let key = "\(logsKey).\(userId.uuidString)"
        guard let data = UserDefaults.standard.data(forKey: key),
              let logs = try? JSONDecoder().decode([MacroLog].self, from: data) else {
            return []
        }
        return logs
    }

    private func saveLogs(_ logs: [MacroLog], userId: UUID) {
        let key = "\(logsKey).\(userId.uuidString)"
        // Keep last 200 entries
        let trimmed = Array(logs.prefix(200))
        if let data = try? JSONEncoder().encode(trimmed) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func loadGoal(userId: UUID) -> MacroGoal? {
        let key = "\(goalsKey).\(userId.uuidString)"
        guard let data = UserDefaults.standard.data(forKey: key),
              let goal = try? JSONDecoder().decode(MacroGoal.self, from: data) else {
            // Auto-create default goal on first access
            let defaultGoal = MacroGoal(
                id: UUID(),
                userId: userId,
                dailyCalories: 2000,
                dailyProteinGrams: 130,
                dailyCarbsGrams: 220,
                dailyFatGrams: 65,
                isActive: true,
                createdAt: Date()
            )
            saveGoal(defaultGoal, userId: userId)
            return defaultGoal
        }
        return goal
    }

    private func saveGoal(_ goal: MacroGoal, userId: UUID) {
        let key = "\(goalsKey).\(userId.uuidString)"
        if let data = try? JSONEncoder().encode(goal) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
