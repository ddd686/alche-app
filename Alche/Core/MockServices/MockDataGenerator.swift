import Foundation

/// Shared mock data engine.
/// Uses seeded randomness so each user gets consistent, reproducible data.
/// Scores trend slightly upward over time to reward engagement.
final class MockDataGenerator: Sendable {

    static let shared = MockDataGenerator()

    private init() {}

    // MARK: - Seeded Randomness

    /// Returns a deterministic random number seeded by the user's ID and an offset.
    /// This ensures the same user always sees the same mock data.
    func seededRandom(userId: UUID, offset: Int, min: Int, max: Int) -> Int {
        let seed = userId.hashValue &+ offset
        var rng = SeededRNG(seed: UInt64(bitPattern: Int64(seed)))
        let range = max - min + 1
        guard range > 0 else { return min }
        return min + Int(rng.next() % UInt64(range))
    }

    func seededDouble(userId: UUID, offset: Int, min: Double, max: Double) -> Double {
        let intVal = seededRandom(userId: userId, offset: offset, min: 0, max: 10000)
        return min + (max - min) * (Double(intVal) / 10000.0)
    }

    // MARK: - Trend Logic

    /// Adds a slight upward trend based on days since first use.
    /// Scores improve ~1-2 points per week, capped at a ceiling.
    func trendAdjustment(daysSinceCreation: Int, baseScore: Int, ceiling: Int = 92) -> Int {
        let weeklyGain = 1.5
        let weeks = Double(daysSinceCreation) / 7.0
        let bonus = Int(weeks * weeklyGain)
        return min(baseScore + bonus, ceiling)
    }

    /// Weekly variance: +/- 5% to make trends look natural.
    func weeklyVariance(userId: UUID, weekNumber: Int, baseScore: Int) -> Int {
        let variance = seededRandom(userId: userId, offset: weekNumber * 1000, min: -5, max: 5)
        let adjusted = baseScore + (baseScore * variance / 100)
        return max(0, min(100, adjusted))
    }

    // MARK: - Date Helpers

    func daysSince(_ date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
    }

    func currentWeekNumber() -> Int {
        Calendar.current.component(.weekOfYear, from: Date())
    }
}

// MARK: - Seeded RNG

/// Simple xorshift64 PRNG for deterministic "random" numbers.
struct SeededRNG: RandomNumberGenerator {
    var state: UInt64

    init(seed: UInt64) {
        state = seed == 0 ? 1 : seed
    }

    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}
