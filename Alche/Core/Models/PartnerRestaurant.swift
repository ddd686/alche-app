import Foundation

// MARK: - Restaurant Enums

enum CuisineType: String, Codable, Sendable, CaseIterable {
    case mediterranean
    case asian
    case german
    case fusion
    case vegan
    case raw
    case bowls

    var displayName: String {
        switch self {
        case .mediterranean: "Mediterranean"
        case .asian: "Asian"
        case .german: "German"
        case .fusion: "Fusion"
        case .vegan: "Vegan"
        case .raw: "Raw"
        case .bowls: "Bowls"
        }
    }
}

enum PriceRange: String, Codable, Sendable {
    case budget
    case moderate
    case premium

    var displayName: String {
        switch self {
        case .budget: "\u{20AC}"
        case .moderate: "\u{20AC}\u{20AC}"
        case .premium: "\u{20AC}\u{20AC}\u{20AC}"
        }
    }

    var symbol: String { displayName }
}

enum PartnershipStatus: String, Codable, Sendable {
    case active
    case pending
    case paused
}

// MARK: - PartnerRestaurant Model

struct PartnerRestaurant: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    var name: String
    var description: String?
    var cuisineType: CuisineType
    var address: String
    var district: String
    var latitude: Double?
    var longitude: Double?
    var partnershipStatus: PartnershipStatus
    var logoURL: String?
    var imageURL: String?
    var priceRange: PriceRange
    var isVerified: Bool
    var menuLastUpdated: Date
    var sortOrder: Int
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case cuisineType = "cuisine_type"
        case address
        case district
        case latitude
        case longitude
        case partnershipStatus = "partnership_status"
        case logoURL = "logo_url"
        case imageURL = "image_url"
        case priceRange = "price_range"
        case isVerified = "is_verified"
        case menuLastUpdated = "menu_last_updated"
        case sortOrder = "sort_order"
        case createdAt = "created_at"
    }

    /// Whether the restaurant is currently active and visible to members.
    var isActive: Bool { partnershipStatus == .active }
}

// MARK: - Preview Data

extension PartnerRestaurant {
    static let preview = PartnerRestaurant(
        id: UUID(uuidString: "A1000001-0000-0000-0000-000000000001")!,
        name: "Green Bowl Berlin",
        description: "Fresh, vibrant bowls crafted from locally sourced ingredients. Every bowl is designed to nourish and energize, with a focus on balanced macros and clean eating.",
        cuisineType: .bowls,
        address: "Torstrasse 125, 10119 Berlin",
        district: "Mitte",
        latitude: 52.5295,
        longitude: 13.3986,
        partnershipStatus: .active,
        logoURL: nil,
        imageURL: nil,
        priceRange: .moderate,
        isVerified: true,
        menuLastUpdated: Date().addingTimeInterval(-86400 * 3),
        sortOrder: 0,
        createdAt: Date().addingTimeInterval(-86400 * 90)
    )

    static let allPreviews: [PartnerRestaurant] = [
        .preview,
        PartnerRestaurant(
            id: UUID(uuidString: "A1000001-0000-0000-0000-000000000002")!,
            name: "Nouri Kitchen",
            description: "A modern Mediterranean kitchen in the heart of Kreuzberg. House-made hummus, slow-grilled proteins, and sun-drenched flavors with precise nutritional balance.",
            cuisineType: .mediterranean,
            address: "Oranienstrasse 34, 10999 Berlin",
            district: "Kreuzberg",
            latitude: 52.5015,
            longitude: 13.4215,
            partnershipStatus: .active,
            logoURL: nil,
            imageURL: nil,
            priceRange: .moderate,
            isVerified: true,
            menuLastUpdated: Date().addingTimeInterval(-86400 * 5),
            sortOrder: 1,
            createdAt: Date().addingTimeInterval(-86400 * 60)
        ),
        PartnerRestaurant(
            id: UUID(uuidString: "A1000001-0000-0000-0000-000000000003")!,
            name: "The Raw Bar",
            description: "Berlin's pioneering raw and vegan kitchen. Everything is plant-based, unprocessed, and prepared below 48 degrees to preserve enzymes and nutrients.",
            cuisineType: .raw,
            address: "Kastanienallee 82, 10435 Berlin",
            district: "Prenzlauer Berg",
            latitude: 52.5388,
            longitude: 13.4132,
            partnershipStatus: .active,
            logoURL: nil,
            imageURL: nil,
            priceRange: .budget,
            isVerified: true,
            menuLastUpdated: Date().addingTimeInterval(-86400 * 7),
            sortOrder: 2,
            createdAt: Date().addingTimeInterval(-86400 * 45)
        ),
        PartnerRestaurant(
            id: UUID(uuidString: "A1000001-0000-0000-0000-000000000004")!,
            name: "Sage & Salt",
            description: "Elevated fusion dining where East meets West. Seasonal ingredients, precise technique, and a menu designed for those who value both flavor and function.",
            cuisineType: .fusion,
            address: "Simon-Dach-Strasse 18, 10245 Berlin",
            district: "Friedrichshain",
            latitude: 52.5101,
            longitude: 13.4543,
            partnershipStatus: .active,
            logoURL: nil,
            imageURL: nil,
            priceRange: .premium,
            isVerified: true,
            menuLastUpdated: Date().addingTimeInterval(-86400 * 2),
            sortOrder: 3,
            createdAt: Date().addingTimeInterval(-86400 * 30)
        ),
    ]
}
