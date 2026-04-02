import Foundation

enum ProductCategory: String, Codable, Sendable, CaseIterable {
    case glow
    case recovery
    case energy
    case sleep
    case gut

    var displayName: String {
        switch self {
        case .glow: "Glow"
        case .recovery: "Recovery"
        case .energy: "Energy"
        case .sleep: "Sleep"
        case .gut: "Gut"
        }
    }
}

enum ProductType: String, Codable, Sendable {
    case blend
    case singleIngredient = "single_ingredient"
    case capsule

    var displayName: String {
        switch self {
        case .blend: "Blend"
        case .singleIngredient: "Single Ingredient"
        case .capsule: "Capsule"
        }
    }
}

enum FulfillmentOption: String, Codable, Sendable, CaseIterable {
    case pickup
    case shipping

    var displayName: String {
        switch self {
        case .pickup: "In-store pickup"
        case .shipping: "Shipping"
        }
    }
}

struct Product: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    var name: String
    var description: String?
    var productType: ProductType
    var category: ProductCategory
    var ingredients: [String]
    var priceCents: Int
    var memberPriceCents: Int
    var imageURL: String?
    var weight: String?
    var inStock: Bool
    var sortOrder: Int
    var fulfillmentOptions: [FulfillmentOption]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case productType = "product_type"
        case category
        case ingredients
        case priceCents = "price_cents"
        case memberPriceCents = "member_price_cents"
        case imageURL = "image_url"
        case weight
        case inStock = "in_stock"
        case sortOrder = "sort_order"
        case fulfillmentOptions = "fulfillment_options"
    }

    var formattedPrice: String {
        let euros = Double(priceCents) / 100.0
        return String(format: "%.2f", euros)
    }

    var formattedMemberPrice: String {
        let euros = Double(memberPriceCents) / 100.0
        return String(format: "%.2f", euros)
    }

    var discountPercentage: Int {
        guard priceCents > 0 else { return 0 }
        return Int(round(Double(priceCents - memberPriceCents) / Double(priceCents) * 100))
    }

    var savingsPercent: Int? {
        let pct = discountPercentage
        return pct > 0 ? pct : nil
    }
}

extension Product {
    static let allPreviews: [Product] = [
        .preview,
        Product(
            id: UUID(),
            name: "Recovery Complex",
            description: "Supports post-exercise recovery with turmeric, tart cherry, and magnesium glycinate.",
            productType: .capsule,
            category: .recovery,
            ingredients: ["Turmeric", "Tart cherry", "Magnesium glycinate"],
            priceCents: 2900,
            memberPriceCents: 2465,
            imageURL: nil,
            weight: "60 capsules",
            inStock: true,
            sortOrder: 1,
            fulfillmentOptions: [.pickup, .shipping]
        ),
        Product(
            id: UUID(),
            name: "Sleep Ritual Blend",
            description: "A calming evening blend with magnesium, L-theanine, and passionflower to support restful sleep.",
            productType: .blend,
            category: .sleep,
            ingredients: ["Magnesium", "L-theanine", "Passionflower", "Tart cherry"],
            priceCents: 3400,
            memberPriceCents: 2890,
            imageURL: nil,
            weight: "150g",
            inStock: true,
            sortOrder: 2,
            fulfillmentOptions: [.pickup, .shipping]
        ),
        Product(
            id: UUID(),
            name: "Gut Balance",
            description: "Supports digestive wellness with prebiotics, probiotics, and L-glutamine.",
            productType: .blend,
            category: .gut,
            ingredients: ["Prebiotic fiber", "Probiotics", "L-glutamine", "Ginger"],
            priceCents: 3200,
            memberPriceCents: 2720,
            imageURL: nil,
            weight: "200g",
            inStock: true,
            sortOrder: 3,
            fulfillmentOptions: [.pickup, .shipping]
        ),
        Product(
            id: UUID(),
            name: "Energy Greens",
            description: "Whole-food energy support with matcha, spirulina, and adaptogenic herbs.",
            productType: .blend,
            category: .energy,
            ingredients: ["Matcha", "Spirulina", "Ashwagandha", "B-vitamins"],
            priceCents: 3600,
            memberPriceCents: 3060,
            imageURL: nil,
            weight: "180g",
            inStock: false,
            sortOrder: 4,
            fulfillmentOptions: [.pickup, .shipping]
        ),
    ]

    static let preview = Product(
        id: UUID(),
        name: "Daily Glow Blend",
        description: "A carefully formulated blend to support radiant skin from within. Marine collagen, hyaluronic acid, vitamin C, and astaxanthin.",
        productType: .blend,
        category: .glow,
        ingredients: ["Marine collagen", "Hyaluronic acid", "Vitamin C", "Astaxanthin"],
        priceCents: 3900,
        memberPriceCents: 3315,
        imageURL: nil,
        weight: "180g",
        inStock: true,
        sortOrder: 0,
        fulfillmentOptions: [.pickup, .shipping]
    )
}
