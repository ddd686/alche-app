import Foundation

// MARK: - Dish Enums

enum DishCategory: String, Codable, Sendable, CaseIterable {
    case starter
    case main
    case side
    case dessert
    case drink

    var displayName: String {
        switch self {
        case .starter: "Starter"
        case .main: "Main"
        case .side: "Side"
        case .dessert: "Dessert"
        case .drink: "Drink"
        }
    }
}

enum Allergen: String, Codable, Sendable, CaseIterable {
    case gluten
    case dairy
    case nuts
    case soy
    case eggs
    case shellfish
    case sesame

    var displayName: String {
        switch self {
        case .gluten: "Gluten"
        case .dairy: "Dairy"
        case .nuts: "Nuts"
        case .soy: "Soy"
        case .eggs: "Eggs"
        case .shellfish: "Shellfish"
        case .sesame: "Sesame"
        }
    }

    var icon: String {
        switch self {
        case .gluten: "leaf.fill"
        case .dairy: "drop.fill"
        case .nuts: "tree.fill"
        case .soy: "leaf.arrow.circlepath"
        case .eggs: "oval.fill"
        case .shellfish: "fish.fill"
        case .sesame: "circle.grid.3x3.fill"
        }
    }
}

// MARK: - RestaurantDish Model

struct RestaurantDish: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let restaurantId: UUID
    var name: String
    var description: String?
    var category: DishCategory
    var priceCents: Int
    var imageURL: String?
    var available: Bool
    var isSignatureDish: Bool
    var sortOrder: Int
    var version: Int
    var lastAnalyzedAt: Date
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case restaurantId = "restaurant_id"
        case name
        case description
        case category
        case priceCents = "price_cents"
        case imageURL = "image_url"
        case available
        case isSignatureDish = "is_signature_dish"
        case sortOrder = "sort_order"
        case version
        case lastAnalyzedAt = "last_analyzed_at"
        case createdAt = "created_at"
    }

    var formattedPrice: String {
        let euros = Double(priceCents) / 100.0
        return String(format: "%.2f", euros)
    }
}

// MARK: - NutritionalProfile Model

struct NutritionalProfile: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let dishId: UUID
    var calories: Int
    var proteinGrams: Double
    var carbsGrams: Double
    var fatGrams: Double
    var fiberGrams: Double
    var ingredients: [String]
    var allergens: [Allergen]
    var micronutrients: [String: String]?
    var analysisMethod: String
    var analyzedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case dishId = "dish_id"
        case calories
        case proteinGrams = "protein_grams"
        case carbsGrams = "carbs_grams"
        case fatGrams = "fat_grams"
        case fiberGrams = "fiber_grams"
        case ingredients
        case allergens
        case micronutrients
        case analysisMethod = "analysis_method"
        case analyzedAt = "analyzed_at"
    }

    // MARK: - Computed Helpers

    var formattedCalories: String {
        "\(calories) kcal"
    }

    var formattedProtein: String {
        "\(Int(proteinGrams))g"
    }

    var formattedCarbs: String {
        "\(Int(carbsGrams))g"
    }

    var formattedFat: String {
        "\(Int(fatGrams))g"
    }

    var formattedFiber: String {
        "\(Int(fiberGrams))g"
    }

    /// Macro percentages based on caloric contribution (protein 4cal/g, carbs 4cal/g, fat 9cal/g).
    var macroPercentages: (protein: Double, carbs: Double, fat: Double) {
        let proteinCal = proteinGrams * 4.0
        let carbsCal = carbsGrams * 4.0
        let fatCal = fatGrams * 9.0
        let total = proteinCal + carbsCal + fatCal
        guard total > 0 else { return (0, 0, 0) }
        return (
            protein: proteinCal / total * 100,
            carbs: carbsCal / total * 100,
            fat: fatCal / total * 100
        )
    }
}

// MARK: - Preview Data

extension RestaurantDish {
    /// Preview dish linked to Green Bowl Berlin (preview restaurant).
    static let preview = RestaurantDish(
        id: UUID(uuidString: "B2000001-0000-0000-0000-000000000001")!,
        restaurantId: UUID(uuidString: "A1000001-0000-0000-0000-000000000001")!,
        name: "Salmon Poke Bowl",
        description: "Fresh Atlantic salmon on a bed of sushi rice with edamame, avocado, pickled ginger, and sesame-soy dressing.",
        category: .main,
        priceCents: 1490,
        imageURL: nil,
        available: true,
        isSignatureDish: true,
        sortOrder: 0,
        version: 1,
        lastAnalyzedAt: Date().addingTimeInterval(-86400 * 10),
        createdAt: Date().addingTimeInterval(-86400 * 90)
    )

    static let allPreviews: [RestaurantDish] = [
        .preview,
        RestaurantDish(
            id: UUID(uuidString: "B2000001-0000-0000-0000-000000000002")!,
            restaurantId: UUID(uuidString: "A1000001-0000-0000-0000-000000000001")!,
            name: "Mediterranean Grain Bowl",
            description: "Ancient grains with roasted vegetables, feta, olives, and lemon-tahini dressing.",
            category: .main,
            priceCents: 1290,
            imageURL: nil,
            available: true,
            isSignatureDish: false,
            sortOrder: 1,
            version: 1,
            lastAnalyzedAt: Date().addingTimeInterval(-86400 * 10),
            createdAt: Date().addingTimeInterval(-86400 * 90)
        ),
        RestaurantDish(
            id: UUID(uuidString: "B2000001-0000-0000-0000-000000000003")!,
            restaurantId: UUID(uuidString: "A1000001-0000-0000-0000-000000000002")!,
            name: "Grilled Chicken Plate",
            description: "Free-range chicken thigh, chargrilled and served with hummus, tabbouleh, and warm pita.",
            category: .main,
            priceCents: 1590,
            imageURL: nil,
            available: true,
            isSignatureDish: true,
            sortOrder: 0,
            version: 1,
            lastAnalyzedAt: Date().addingTimeInterval(-86400 * 12),
            createdAt: Date().addingTimeInterval(-86400 * 60)
        ),
    ]
}

extension NutritionalProfile {
    /// Preview profile linked to the Salmon Poke Bowl preview dish.
    static let preview = NutritionalProfile(
        id: UUID(uuidString: "C3000001-0000-0000-0000-000000000001")!,
        dishId: UUID(uuidString: "B2000001-0000-0000-0000-000000000001")!,
        calories: 520,
        proteinGrams: 38,
        carbsGrams: 48,
        fatGrams: 18,
        fiberGrams: 6,
        ingredients: ["Salmon", "Sushi rice", "Edamame", "Avocado", "Pickled ginger", "Sesame seeds", "Soy sauce", "Rice vinegar"],
        allergens: [.soy, .sesame, .shellfish],
        micronutrients: ["Omega-3": "1.2g", "Vitamin D": "15% DV", "Iron": "12% DV"],
        analysisMethod: "alche independent analysis",
        analyzedAt: Date().addingTimeInterval(-86400 * 10)
    )

    static let allPreviews: [NutritionalProfile] = [
        .preview,
        NutritionalProfile(
            id: UUID(uuidString: "C3000001-0000-0000-0000-000000000002")!,
            dishId: UUID(uuidString: "B2000001-0000-0000-0000-000000000002")!,
            calories: 480,
            proteinGrams: 22,
            carbsGrams: 62,
            fatGrams: 14,
            fiberGrams: 8,
            ingredients: ["Farro", "Quinoa", "Roasted peppers", "Feta", "Kalamata olives", "Cucumber", "Tahini", "Lemon"],
            allergens: [.dairy, .gluten, .sesame],
            micronutrients: ["Fiber": "32% DV", "Iron": "18% DV", "Vitamin A": "22% DV"],
            analysisMethod: "alche independent analysis",
            analyzedAt: Date().addingTimeInterval(-86400 * 10)
        ),
        NutritionalProfile(
            id: UUID(uuidString: "C3000001-0000-0000-0000-000000000003")!,
            dishId: UUID(uuidString: "B2000001-0000-0000-0000-000000000003")!,
            calories: 580,
            proteinGrams: 42,
            carbsGrams: 35,
            fatGrams: 26,
            fiberGrams: 5,
            ingredients: ["Chicken thigh", "Hummus", "Tabbouleh", "Pita bread", "Olive oil", "Garlic", "Sumac"],
            allergens: [.gluten, .sesame],
            micronutrients: ["Protein": "84% DV", "B12": "25% DV", "Zinc": "20% DV"],
            analysisMethod: "alche independent analysis",
            analyzedAt: Date().addingTimeInterval(-86400 * 12)
        ),
    ]
}
