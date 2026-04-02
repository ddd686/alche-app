import Foundation
import UIKit

protocol GlowScanServiceProtocol: Sendable {
    func analyzeSkin(image: UIImage, userId: UUID) async throws -> GlowScanResult
    func getHistory(userId: UUID) async throws -> [GlowScanResult]
    func latestScan(userId: UUID) async throws -> GlowScanResult?
}
