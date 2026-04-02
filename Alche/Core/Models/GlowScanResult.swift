import Foundation

struct GlowScanResult: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    var imageURL: String?
    var overallScore: Int
    var hydrationScore: Int
    var radianceScore: Int
    var textureScore: Int
    var underEyeScore: Int
    var elasticityScore: Int
    var isMock: Bool
    var recommendations: [ScanRecommendation]?
    let scannedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case imageURL = "image_url"
        case overallScore = "overall_score"
        case hydrationScore = "hydration_score"
        case radianceScore = "radiance_score"
        case textureScore = "texture_score"
        case underEyeScore = "under_eye_score"
        case elasticityScore = "elasticity_score"
        case isMock = "is_mock"
        case recommendations
        case scannedAt = "scanned_at"
    }

    var categories: [GlowCategory] {
        [
            GlowCategory(name: "Hydration", score: hydrationScore, description: "How well-hydrated your skin looks"),
            GlowCategory(name: "Radiance", score: radianceScore, description: "Your skin's natural luminosity"),
            GlowCategory(name: "Texture", score: textureScore, description: "Smoothness and evenness"),
            GlowCategory(name: "Under-Eye", score: underEyeScore, description: "Under-eye area appearance"),
            GlowCategory(name: "Elasticity", score: elasticityScore, description: "Skin firmness and bounce"),
        ]
    }
}

struct GlowCategory: Sendable, Hashable {
    let name: String
    let score: Int
    let description: String

    var status: String {
        switch score {
        case 80...100: "Looking great"
        case 65..<80: "Good, with room to glow"
        case 50..<65: "Worth some attention"
        default: "Could use some love"
        }
    }
}

struct ScanRecommendation: Codable, Sendable, Hashable {
    var productId: UUID?
    var protocolId: UUID?
    var reason: String

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case protocolId = "protocol_id"
        case reason
    }
}

extension GlowScanResult {
    static let preview = GlowScanResult(
        id: UUID(),
        userId: UUID(),
        imageURL: nil,
        overallScore: 74,
        hydrationScore: 68,
        radianceScore: 78,
        textureScore: 82,
        underEyeScore: 65,
        elasticityScore: 76,
        isMock: true,
        recommendations: [
            ScanRecommendation(productId: nil, protocolId: nil, reason: "Your skin looks like it could use a hydration boost. Try our Glow smoothie after your next LED session.")
        ],
        scannedAt: Date()
    )
}
