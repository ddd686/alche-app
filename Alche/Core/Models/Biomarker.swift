import Foundation

struct Biomarker: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let profileId: UUID
    var category: BiomarkerCategory
    var markerName: String
    var value: Double
    var unit: String
    var referenceMin: Double?
    var referenceMax: Double?
    var status: BiomarkerStatus
    var displayName: String
    var whatItMeans: String?
    var recommendation: String?
    var linkedProtocolId: UUID?
    var linkedProductId: UUID?

    enum CodingKeys: String, CodingKey {
        case id
        case profileId = "profile_id"
        case category
        case markerName = "marker_name"
        case value
        case unit
        case referenceMin = "reference_min"
        case referenceMax = "reference_max"
        case status
        case displayName = "display_name"
        case whatItMeans = "what_it_means"
        case recommendation
        case linkedProtocolId = "linked_protocol_id"
        case linkedProductId = "linked_product_id"
    }

    var isInRange: Bool {
        guard let min = referenceMin, let max = referenceMax else { return true }
        return value >= min && value <= max
    }

    var percentInRange: Double? {
        guard let min = referenceMin, let max = referenceMax, max > min else { return nil }
        let clamped = Swift.min(Swift.max(value, min), max)
        return (clamped - min) / (max - min)
    }
}

extension Biomarker {
    static let preview = Biomarker(
        id: UUID(),
        profileId: UUID(),
        category: .nutrients,
        markerName: "25-hydroxyvitamin D",
        value: 22.0,
        unit: "ng/mL",
        referenceMin: 30.0,
        referenceMax: 80.0,
        status: .attention,
        displayName: "Vitamin D",
        whatItMeans: "Your vitamin D looks a little low, which is common in Berlin, especially during winter. It supports bone health, immune function, and mood.",
        recommendation: "Consider a daily vitamin D3 supplement (2000-4000 IU) with a fat-containing meal. Our Energy blend includes vitamin D.",
        linkedProtocolId: nil,
        linkedProductId: nil
    )
}
