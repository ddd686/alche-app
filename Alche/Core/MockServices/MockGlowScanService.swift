import Foundation
import UIKit

/// Mock implementation of GlowScanServiceProtocol.
/// Simulates skin analysis with seeded-random scores in the 62-85 range.
/// Scores trend slightly upward over time and have weekly variance.
final class MockGlowScanService: GlowScanServiceProtocol {

    private let generator = MockDataGenerator.shared
    private let userDefaultsKey = "alche.mock.glowScans"

    func analyzeSkin(image: UIImage, userId: UUID) async throws -> GlowScanResult {
        // Simulate processing delay (2-3.5 seconds)
        let delay = generator.seededDouble(
            userId: userId,
            offset: Int(Date().timeIntervalSince1970),
            min: 2.0,
            max: 3.5
        )
        try await Task.sleep(for: .seconds(delay))

        let scanCount = loadHistory(userId: userId).count
        let weekNumber = generator.currentWeekNumber()

        let baseHydration = generator.seededRandom(userId: userId, offset: 10, min: 62, max: 78)
        let baseRadiance = generator.seededRandom(userId: userId, offset: 20, min: 65, max: 82)
        let baseTexture = generator.seededRandom(userId: userId, offset: 30, min: 68, max: 85)
        let baseUnderEye = generator.seededRandom(userId: userId, offset: 40, min: 58, max: 75)
        let baseElasticity = generator.seededRandom(userId: userId, offset: 50, min: 64, max: 80)

        // Apply trend (slight improvement over scans)
        let trendBonus = min(scanCount, 10)

        let hydration = generator.weeklyVariance(userId: userId, weekNumber: weekNumber, baseScore: baseHydration + trendBonus)
        let radiance = generator.weeklyVariance(userId: userId, weekNumber: weekNumber + 1, baseScore: baseRadiance + trendBonus)
        let texture = generator.weeklyVariance(userId: userId, weekNumber: weekNumber + 2, baseScore: baseTexture + trendBonus)
        let underEye = generator.weeklyVariance(userId: userId, weekNumber: weekNumber + 3, baseScore: baseUnderEye + trendBonus)
        let elasticity = generator.weeklyVariance(userId: userId, weekNumber: weekNumber + 4, baseScore: baseElasticity + trendBonus)

        let overall = (hydration + radiance + texture + underEye + elasticity) / 5

        let result = GlowScanResult(
            id: UUID(),
            userId: userId,
            imageURL: nil,
            overallScore: overall,
            hydrationScore: hydration,
            radianceScore: radiance,
            textureScore: texture,
            underEyeScore: underEye,
            elasticityScore: elasticity,
            isMock: true,
            recommendations: generateRecommendations(
                hydration: hydration,
                radiance: radiance,
                texture: texture,
                underEye: underEye,
                elasticity: elasticity
            ),
            scannedAt: Date()
        )

        saveResult(result, userId: userId)
        return result
    }

    func getHistory(userId: UUID) async throws -> [GlowScanResult] {
        loadHistory(userId: userId)
    }

    func latestScan(userId: UUID) async throws -> GlowScanResult? {
        loadHistory(userId: userId).first
    }

    // MARK: - Recommendations

    private func generateRecommendations(
        hydration: Int, radiance: Int, texture: Int, underEye: Int, elasticity: Int
    ) -> [ScanRecommendation] {
        var recs: [ScanRecommendation] = []

        if hydration < 70 {
            recs.append(ScanRecommendation(
                productId: nil, protocolId: nil,
                reason: "Your skin looks like it could use a hydration boost. Try our Glow smoothie with a collagen boost after your next session."
            ))
        }
        if radiance < 70 {
            recs.append(ScanRecommendation(
                productId: nil, protocolId: nil,
                reason: "Your radiance score suggests a LED Glow session could help. Light supports your skin's natural renewal."
            ))
        }
        if underEye < 65 {
            recs.append(ScanRecommendation(
                productId: nil, protocolId: nil,
                reason: "Your under-eye area looks like it could benefit from more rest. Check out the Sleep Protocol for an evening wind-down routine."
            ))
        }
        if elasticity < 68 {
            recs.append(ScanRecommendation(
                productId: nil, protocolId: nil,
                reason: "For firmness, collagen supplementation and regular LED sessions can support your skin's elasticity over time."
            ))
        }

        if recs.isEmpty {
            recs.append(ScanRecommendation(
                productId: nil, protocolId: nil,
                reason: "Your skin is looking well-balanced. Keep up your current routine and book a Glow session to maintain your results."
            ))
        }

        return recs
    }

    // MARK: - Persistence (UserDefaults)

    private func loadHistory(userId: UUID) -> [GlowScanResult] {
        let key = "\(userDefaultsKey).\(userId.uuidString)"
        guard let data = UserDefaults.standard.data(forKey: key),
              let results = try? JSONDecoder().decode([GlowScanResult].self, from: data) else {
            return []
        }
        return results.sorted { $0.scannedAt > $1.scannedAt }
    }

    private func saveResult(_ result: GlowScanResult, userId: UUID) {
        let key = "\(userDefaultsKey).\(userId.uuidString)"
        var history = loadHistory(userId: userId)
        history.insert(result, at: 0)
        // Keep last 20 scans
        if history.count > 20 { history = Array(history.prefix(20)) }
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
