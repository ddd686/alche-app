import Foundation

enum SmoothieGoal: String, Codable, Sendable, CaseIterable {
    case glow
    case recovery
    case calm
    case gut
    case energy
    case seasonal

    var displayName: String {
        switch self {
        case .glow: "Glow"
        case .recovery: "Recovery"
        case .calm: "Calm"
        case .gut: "Gut"
        case .energy: "Energy"
        case .seasonal: "Seasonal"
        }
    }

    var tagline: String {
        switch self {
        case .glow: "For radiance from within"
        case .recovery: "For rest and renewal"
        case .calm: "For a quieter mind"
        case .gut: "For daily balance"
        case .energy: "For sustained vitality"
        case .seasonal: "What the season calls for"
        }
    }
}

enum BoostType: String, Codable, Sendable, CaseIterable {
    case collagen
    case adaptogens
    case protein
    case greens
    case immunity

    var displayName: String {
        switch self {
        case .collagen: "Collagen"
        case .adaptogens: "Adaptogens"
        case .protein: "Protein"
        case .greens: "Greens"
        case .immunity: "Immunity"
        }
    }

    var priceCents: Int { 200 }
}

struct MenuItem: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    var name: String
    var description: String?
    var ingredients: [String]
    var allergens: [String]
    var nutritionalInfo: [String: String]?
    var goalTags: [SmoothieGoal]
    var priceCents: Int
    var imageURL: String?
    var available: Bool
    var sortOrder: Int
    var boostsAvailable: [BoostType]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case ingredients
        case allergens
        case nutritionalInfo = "nutritional_info"
        case goalTags = "goal_tags"
        case priceCents = "price_cents"
        case imageURL = "image_url"
        case available
        case sortOrder = "sort_order"
        case boostsAvailable = "boosts_available"
    }

    var category: SmoothieGoal {
        goalTags.first ?? .seasonal
    }

    var formattedPrice: String {
        let euros = Double(priceCents) / 100.0
        return String(format: "%.2f", euros)
    }
}

extension MenuItem {
    static let preview = MenuItem(
        id: UUID(),
        name: "Golden Glow",
        description: "Mango, turmeric, ginger, coconut milk, a touch of black pepper",
        ingredients: ["Mango", "Turmeric", "Ginger", "Coconut milk", "Black pepper"],
        allergens: [],
        nutritionalInfo: ["calories": "180", "protein": "4g"],
        goalTags: [.glow],
        priceCents: 890,
        imageURL: nil,
        available: true,
        sortOrder: 0,
        boostsAvailable: [.collagen, .adaptogens, .protein]
    )
}
