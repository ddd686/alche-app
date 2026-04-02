import Foundation
import UIKit

@Observable
@MainActor
final class GlowScanViewModel {
    // MARK: - State

    var scanHistory: [GlowScanResult] = []
    var latestResult: GlowScanResult?
    var isAnalyzing = false
    var isLoadingHistory = false
    var showCamera = false
    var showResults = false
    var errorMessage: String?

    // Processing animation
    var analysisProgress: Double = 0
    var analysisStage: String = ""

    private let service: GlowScanServiceProtocol = MockGlowScanService()
    private let userId = UUID() // TODO: Wire to real auth

    // MARK: - Actions

    func loadHistory() async {
        isLoadingHistory = true
        do {
            scanHistory = try await service.getHistory(userId: userId)
            latestResult = scanHistory.first
        } catch {
            errorMessage = "Could not load your scan history."
        }
        isLoadingHistory = false
    }

    func analyzeSkin(image: UIImage) async {
        isAnalyzing = true
        errorMessage = nil
        analysisProgress = 0

        // Animate the progress stages
        let stages = [
            (0.2, "Preparing your photo..."),
            (0.4, "Analysing skin texture..."),
            (0.6, "Checking hydration markers..."),
            (0.8, "Evaluating radiance..."),
            (0.95, "Generating your Glow Score..."),
        ]

        Task {
            for (progress, stage) in stages {
                try? await Task.sleep(for: .seconds(0.5))
                analysisProgress = progress
                analysisStage = stage
            }
        }

        do {
            let result = try await service.analyzeSkin(image: image, userId: userId)
            latestResult = result
            scanHistory.insert(result, at: 0)
            analysisProgress = 1.0
            analysisStage = "Done"

            try? await Task.sleep(for: .seconds(0.3))
            showResults = true
        } catch {
            errorMessage = "Something went wrong with the analysis. Please try again."
        }

        isAnalyzing = false
    }

    // MARK: - Computed

    var isUsingMockData: Bool {
        latestResult?.isMock ?? true
    }

    var hasScans: Bool {
        !scanHistory.isEmpty
    }

    var overallTrend: TrendDirection {
        guard scanHistory.count >= 2 else { return .stable }
        let recent = scanHistory.prefix(3).map(\.overallScore)
        let older = scanHistory.dropFirst(3).prefix(3).map(\.overallScore)
        guard !older.isEmpty else { return .stable }

        let recentAvg = Double(recent.reduce(0, +)) / Double(recent.count)
        let olderAvg = Double(older.reduce(0, +)) / Double(older.count)

        if recentAvg - olderAvg > 2 { return .up }
        if olderAvg - recentAvg > 2 { return .down }
        return .stable
    }

    enum TrendDirection {
        case up, down, stable

        var icon: String {
            switch self {
            case .up: "arrow.up.right"
            case .down: "arrow.down.right"
            case .stable: "arrow.right"
            }
        }

        var label: String {
            switch self {
            case .up: "Improving"
            case .down: "Declining"
            case .stable: "Steady"
            }
        }
    }
}
