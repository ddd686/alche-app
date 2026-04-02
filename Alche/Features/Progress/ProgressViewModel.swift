import Foundation

@Observable
@MainActor
final class ProgressViewModel {
    // MARK: - State

    var checkins: [DailyCheckin] = []
    var selectedMetric: Metric = .energy
    var selectedRange: DateRange = .twoWeeks
    var isLoading = false

    enum Metric: String, CaseIterable {
        case energy = "Energy"
        case sleep = "Sleep"
        case mood = "Mood"
        case overall = "Overall"
    }

    enum DateRange: String, CaseIterable {
        case oneWeek = "7d"
        case twoWeeks = "14d"
        case thirtyDays = "30d"
    }

    // MARK: - Computed

    var filteredCheckins: [DailyCheckin] {
        let days: Int
        switch selectedRange {
        case .oneWeek: days = 7
        case .twoWeeks: days = 14
        case .thirtyDays: days = 30
        }

        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return checkins
            .filter { $0.date >= cutoff }
            .sorted { $0.date < $1.date }
    }

    var chartData: [(date: Date, value: Double)] {
        filteredCheckins.map { checkin in
            let value: Double
            switch selectedMetric {
            case .energy: value = Double(checkin.energy)
            case .sleep: value = Double(checkin.sleepQuality)
            case .mood: value = Double(checkin.mood)
            case .overall: value = checkin.averageScore
            }
            return (date: checkin.date, value: value)
        }
    }

    var currentAverage: Double {
        guard !filteredCheckins.isEmpty else { return 0 }
        let values = filteredCheckins.map { checkin -> Double in
            switch selectedMetric {
            case .energy: return Double(checkin.energy)
            case .sleep: return Double(checkin.sleepQuality)
            case .mood: return Double(checkin.mood)
            case .overall: return checkin.averageScore
            }
        }
        return values.reduce(0, +) / Double(values.count)
    }

    var trend: Trend {
        let data = chartData
        guard data.count >= 4 else { return .neutral }

        let midpoint = data.count / 2
        let firstHalf = data[..<midpoint]
        let secondHalf = data[midpoint...]

        let firstAvg = firstHalf.map(\.value).reduce(0, +) / Double(firstHalf.count)
        let secondAvg = secondHalf.map(\.value).reduce(0, +) / Double(secondHalf.count)

        let diff = secondAvg - firstAvg
        if diff > 0.3 { return .up }
        if diff < -0.3 { return .down }
        return .neutral
    }

    enum Trend {
        case up, down, neutral

        var icon: String {
            switch self {
            case .up: "arrow.up.right"
            case .down: "arrow.down.right"
            case .neutral: "arrow.right"
            }
        }

        var label: String {
            switch self {
            case .up: "Improving"
            case .down: "Declining"
            case .neutral: "Steady"
            }
        }
    }

    var streakDays: Int {
        let sorted = checkins.sorted { $0.date > $1.date }
        var streak = 0
        var expectedDate = Calendar.current.startOfDay(for: Date())

        for checkin in sorted {
            let checkinDay = Calendar.current.startOfDay(for: checkin.date)
            if checkinDay == expectedDate {
                streak += 1
                expectedDate = Calendar.current.date(byAdding: .day, value: -1, to: expectedDate) ?? expectedDate
            } else if checkinDay < expectedDate {
                break
            }
        }
        return streak
    }

    // MARK: - Actions

    func loadProgress() async {
        isLoading = true

        // TODO: Wire to ProtocolServiceProtocol.checkinHistory
        try? await Task.sleep(for: .seconds(0.4))

        checkins = Self.generateSampleCheckins()

        isLoading = false
    }

    // MARK: - Sample Data

    private static func generateSampleCheckins() -> [DailyCheckin] {
        (0..<30).map { dayOffset in
            let date = Calendar.current.date(byAdding: .day, value: -dayOffset, to: Date()) ?? Date()
            // Slight upward trend over time
            let trendBoost = Double(30 - dayOffset) * 0.02
            return DailyCheckin(
                id: UUID(),
                userId: UUID(),
                date: date,
                energy: clampedRandom(base: 3.2 + trendBoost),
                sleepQuality: clampedRandom(base: 3.0 + trendBoost),
                mood: clampedRandom(base: 3.5 + trendBoost),
                notes: dayOffset == 0 ? "Post-LED session, feeling energised" : nil,
                createdAt: date
            )
        }
    }

    private static func clampedRandom(base: Double) -> Int {
        let value = base + Double.random(in: -1.0...1.0)
        return max(1, min(5, Int(value.rounded())))
    }
}
