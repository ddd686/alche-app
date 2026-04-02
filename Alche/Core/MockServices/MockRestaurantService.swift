import Foundation

/// Mock implementation of RestaurantServiceProtocol.
/// Hard-coded data for 4 Berlin partner restaurants with complete menu and nutritional profiles.
/// Read-only — nothing persisted to UserDefaults.
final class MockRestaurantService: RestaurantServiceProtocol {

    // MARK: - Protocol Methods

    func allRestaurants() async throws -> [PartnerRestaurant] {
        try await simulateDelay()
        return Self.restaurants.sorted { $0.sortOrder < $1.sortOrder }
    }

    func restaurants(cuisine: CuisineType) async throws -> [PartnerRestaurant] {
        try await simulateDelay()
        return Self.restaurants
            .filter { $0.cuisineType == cuisine }
            .sorted { $0.sortOrder < $1.sortOrder }
    }

    func restaurant(id: UUID) async throws -> PartnerRestaurant {
        try await simulateDelay()
        guard let restaurant = Self.restaurants.first(where: { $0.id == id }) else {
            throw APIError.notFound
        }
        return restaurant
    }

    func dishes(restaurantId: UUID) async throws -> [RestaurantDish] {
        try await simulateDelay()
        return Self.allDishes
            .filter { $0.restaurantId == restaurantId }
            .sorted { $0.sortOrder < $1.sortOrder }
    }

    func dish(id: UUID) async throws -> RestaurantDish {
        try await simulateDelay()
        guard let dish = Self.allDishes.first(where: { $0.id == id }) else {
            throw APIError.notFound
        }
        return dish
    }

    func nutritionalProfile(dishId: UUID) async throws -> NutritionalProfile {
        try await simulateDelay()
        guard let profile = Self.allProfiles.first(where: { $0.dishId == dishId }) else {
            throw APIError.notFound
        }
        return profile
    }

    // MARK: - Delay Simulation

    private func simulateDelay() async throws {
        try await Task.sleep(for: .seconds(Double.random(in: 0.3...0.8)))
    }

    // MARK: - Static Restaurant IDs

    private static let greenBowlId   = UUID(uuidString: "A1000001-0000-0000-0000-000000000001")!
    private static let nouriId        = UUID(uuidString: "A1000001-0000-0000-0000-000000000002")!
    private static let rawBarId       = UUID(uuidString: "A1000001-0000-0000-0000-000000000003")!
    private static let sageSaltId     = UUID(uuidString: "A1000001-0000-0000-0000-000000000004")!

    // MARK: - Restaurants

    static let restaurants: [PartnerRestaurant] = PartnerRestaurant.allPreviews

    // MARK: - Dish IDs

    // Green Bowl Berlin (7 dishes)
    private static let gb1 = UUID(uuidString: "B2000001-0000-0000-0000-000000000001")!
    private static let gb2 = UUID(uuidString: "B2000001-0000-0000-0000-000000000002")!
    private static let gb3 = UUID(uuidString: "B2000001-0000-0000-0000-000000000003")!
    private static let gb4 = UUID(uuidString: "B2000001-0000-0000-0000-000000000004")!
    private static let gb5 = UUID(uuidString: "B2000001-0000-0000-0000-000000000005")!
    private static let gb6 = UUID(uuidString: "B2000001-0000-0000-0000-000000000006")!
    private static let gb7 = UUID(uuidString: "B2000001-0000-0000-0000-000000000007")!

    // Nouri Kitchen (8 dishes)
    private static let nk1 = UUID(uuidString: "B2000002-0000-0000-0000-000000000001")!
    private static let nk2 = UUID(uuidString: "B2000002-0000-0000-0000-000000000002")!
    private static let nk3 = UUID(uuidString: "B2000002-0000-0000-0000-000000000003")!
    private static let nk4 = UUID(uuidString: "B2000002-0000-0000-0000-000000000004")!
    private static let nk5 = UUID(uuidString: "B2000002-0000-0000-0000-000000000005")!
    private static let nk6 = UUID(uuidString: "B2000002-0000-0000-0000-000000000006")!
    private static let nk7 = UUID(uuidString: "B2000002-0000-0000-0000-000000000007")!
    private static let nk8 = UUID(uuidString: "B2000002-0000-0000-0000-000000000008")!

    // The Raw Bar (6 dishes)
    private static let rb1 = UUID(uuidString: "B2000003-0000-0000-0000-000000000001")!
    private static let rb2 = UUID(uuidString: "B2000003-0000-0000-0000-000000000002")!
    private static let rb3 = UUID(uuidString: "B2000003-0000-0000-0000-000000000003")!
    private static let rb4 = UUID(uuidString: "B2000003-0000-0000-0000-000000000004")!
    private static let rb5 = UUID(uuidString: "B2000003-0000-0000-0000-000000000005")!
    private static let rb6 = UUID(uuidString: "B2000003-0000-0000-0000-000000000006")!

    // Sage & Salt (7 dishes)
    private static let ss1 = UUID(uuidString: "B2000004-0000-0000-0000-000000000001")!
    private static let ss2 = UUID(uuidString: "B2000004-0000-0000-0000-000000000002")!
    private static let ss3 = UUID(uuidString: "B2000004-0000-0000-0000-000000000003")!
    private static let ss4 = UUID(uuidString: "B2000004-0000-0000-0000-000000000004")!
    private static let ss5 = UUID(uuidString: "B2000004-0000-0000-0000-000000000005")!
    private static let ss6 = UUID(uuidString: "B2000004-0000-0000-0000-000000000006")!
    private static let ss7 = UUID(uuidString: "B2000004-0000-0000-0000-000000000007")!

    // MARK: - Nutritional Profile IDs

    private static let npGb1 = UUID(uuidString: "C3000001-0000-0000-0000-000000000001")!
    private static let npGb2 = UUID(uuidString: "C3000001-0000-0000-0000-000000000002")!
    private static let npGb3 = UUID(uuidString: "C3000001-0000-0000-0000-000000000003")!
    private static let npGb4 = UUID(uuidString: "C3000001-0000-0000-0000-000000000004")!
    private static let npGb5 = UUID(uuidString: "C3000001-0000-0000-0000-000000000005")!
    private static let npGb6 = UUID(uuidString: "C3000001-0000-0000-0000-000000000006")!
    private static let npGb7 = UUID(uuidString: "C3000001-0000-0000-0000-000000000007")!

    private static let npNk1 = UUID(uuidString: "C3000002-0000-0000-0000-000000000001")!
    private static let npNk2 = UUID(uuidString: "C3000002-0000-0000-0000-000000000002")!
    private static let npNk3 = UUID(uuidString: "C3000002-0000-0000-0000-000000000003")!
    private static let npNk4 = UUID(uuidString: "C3000002-0000-0000-0000-000000000004")!
    private static let npNk5 = UUID(uuidString: "C3000002-0000-0000-0000-000000000005")!
    private static let npNk6 = UUID(uuidString: "C3000002-0000-0000-0000-000000000006")!
    private static let npNk7 = UUID(uuidString: "C3000002-0000-0000-0000-000000000007")!
    private static let npNk8 = UUID(uuidString: "C3000002-0000-0000-0000-000000000008")!

    private static let npRb1 = UUID(uuidString: "C3000003-0000-0000-0000-000000000001")!
    private static let npRb2 = UUID(uuidString: "C3000003-0000-0000-0000-000000000002")!
    private static let npRb3 = UUID(uuidString: "C3000003-0000-0000-0000-000000000003")!
    private static let npRb4 = UUID(uuidString: "C3000003-0000-0000-0000-000000000004")!
    private static let npRb5 = UUID(uuidString: "C3000003-0000-0000-0000-000000000005")!
    private static let npRb6 = UUID(uuidString: "C3000003-0000-0000-0000-000000000006")!

    private static let npSs1 = UUID(uuidString: "C3000004-0000-0000-0000-000000000001")!
    private static let npSs2 = UUID(uuidString: "C3000004-0000-0000-0000-000000000002")!
    private static let npSs3 = UUID(uuidString: "C3000004-0000-0000-0000-000000000003")!
    private static let npSs4 = UUID(uuidString: "C3000004-0000-0000-0000-000000000004")!
    private static let npSs5 = UUID(uuidString: "C3000004-0000-0000-0000-000000000005")!
    private static let npSs6 = UUID(uuidString: "C3000004-0000-0000-0000-000000000006")!
    private static let npSs7 = UUID(uuidString: "C3000004-0000-0000-0000-000000000007")!

    // MARK: - Date Helpers

    private static let analyzedDate = Date().addingTimeInterval(-86400 * 10)
    private static let createdDate = Date().addingTimeInterval(-86400 * 90)

    // MARK: - All Dishes

    static let allDishes: [RestaurantDish] = greenBowlDishes + nouriDishes + rawBarDishes + sageSaltDishes

    // MARK: Green Bowl Berlin (7 dishes)

    static let greenBowlDishes: [RestaurantDish] = [
        RestaurantDish(
            id: gb1, restaurantId: greenBowlId,
            name: "Salmon Poke Bowl",
            description: "Fresh Atlantic salmon on a bed of sushi rice with edamame, avocado, pickled ginger, and sesame-soy dressing.",
            category: .main, priceCents: 1490, imageURL: nil,
            available: true, isSignatureDish: true, sortOrder: 0,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: gb2, restaurantId: greenBowlId,
            name: "Mediterranean Grain Bowl",
            description: "Ancient grains with roasted vegetables, feta, olives, and lemon-tahini dressing.",
            category: .main, priceCents: 1290, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 1,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: gb3, restaurantId: greenBowlId,
            name: "Chicken Teriyaki Bowl",
            description: "Grilled free-range chicken with teriyaki glaze, brown rice, steamed broccoli, and pickled carrots.",
            category: .main, priceCents: 1390, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 2,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: gb4, restaurantId: greenBowlId,
            name: "Vegan Buddha Bowl",
            description: "Roasted sweet potato, chickpeas, quinoa, avocado, kale, and tahini drizzle.",
            category: .main, priceCents: 1190, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 3,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: gb5, restaurantId: greenBowlId,
            name: "Acai Power Bowl",
            description: "Frozen acai blended with banana, topped with granola, coconut flakes, fresh berries, and honey.",
            category: .dessert, priceCents: 1090, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 4,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: gb6, restaurantId: greenBowlId,
            name: "Protein Recovery Bowl",
            description: "Double chicken, egg, brown rice, edamame, spinach, and miso-ginger dressing. Built for post-workout recovery.",
            category: .main, priceCents: 1690, imageURL: nil,
            available: true, isSignatureDish: true, sortOrder: 5,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: gb7, restaurantId: greenBowlId,
            name: "Green Detox Bowl",
            description: "Spirulina-infused quinoa with avocado, cucumber, sprouts, seaweed, and lime-wasabi dressing.",
            category: .main, priceCents: 1190, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 6,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
    ]

    // MARK: Nouri Kitchen (8 dishes)

    static let nouriDishes: [RestaurantDish] = [
        RestaurantDish(
            id: nk1, restaurantId: nouriId,
            name: "Grilled Chicken Plate",
            description: "Free-range chicken thigh, chargrilled and served with hummus, tabbouleh, and warm pita.",
            category: .main, priceCents: 1590, imageURL: nil,
            available: true, isSignatureDish: true, sortOrder: 0,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: nk2, restaurantId: nouriId,
            name: "Lamb Kofta Wrap",
            description: "Spiced lamb kofta in warm flatbread with garlic yogurt, pickled turnip, and fresh herbs.",
            category: .main, priceCents: 1490, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 1,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: nk3, restaurantId: nouriId,
            name: "Falafel Mezze Plate",
            description: "House-made falafel with hummus, baba ganoush, tabbouleh, pickles, and warm pita.",
            category: .main, priceCents: 1290, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 2,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: nk4, restaurantId: nouriId,
            name: "Grilled Sea Bass",
            description: "Whole sea bass filleted tableside, served with roasted vegetables and preserved lemon sauce.",
            category: .main, priceCents: 2190, imageURL: nil,
            available: true, isSignatureDish: true, sortOrder: 3,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: nk5, restaurantId: nouriId,
            name: "Shakshuka",
            description: "Poached eggs in spiced tomato and pepper sauce with crumbled feta and sourdough toast.",
            category: .main, priceCents: 1290, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 4,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: nk6, restaurantId: nouriId,
            name: "Halloumi Salad",
            description: "Grilled halloumi on a bed of rocket, roasted peppers, pomegranate seeds, and Za'atar dressing.",
            category: .starter, priceCents: 1190, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 5,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: nk7, restaurantId: nouriId,
            name: "Chicken Shawarma Bowl",
            description: "Slow-roasted shawarma chicken over basmati rice with garlic sauce, pickled onion, and fresh salad.",
            category: .main, priceCents: 1490, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 6,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: nk8, restaurantId: nouriId,
            name: "Hummus & Pita Plate",
            description: "Creamy house hummus topped with olive oil and paprika, served with warm pita and pickled vegetables.",
            category: .starter, priceCents: 890, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 7,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
    ]

    // MARK: The Raw Bar (6 dishes)

    static let rawBarDishes: [RestaurantDish] = [
        RestaurantDish(
            id: rb1, restaurantId: rawBarId,
            name: "Raw Pad Thai",
            description: "Spiralized zucchini noodles with almond-tamarind sauce, bean sprouts, crushed peanuts, and lime.",
            category: .main, priceCents: 1290, imageURL: nil,
            available: true, isSignatureDish: true, sortOrder: 0,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: rb2, restaurantId: rawBarId,
            name: "Zucchini Pasta",
            description: "Raw zucchini noodles with sun-dried tomato marinara, cashew parmesan, and fresh basil.",
            category: .main, priceCents: 1090, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 1,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: rb3, restaurantId: rawBarId,
            name: "Raw Tacos",
            description: "Jicama shells filled with walnut meat, cashew sour cream, pico de gallo, and avocado.",
            category: .main, priceCents: 1190, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 2,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: rb4, restaurantId: rawBarId,
            name: "Green Goddess Bowl",
            description: "Kale, spinach, hemp seeds, avocado, cucumber, and spirulina with green goddess dressing.",
            category: .main, priceCents: 1190, imageURL: nil,
            available: true, isSignatureDish: true, sortOrder: 3,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: rb5, restaurantId: rawBarId,
            name: "Raw Cheesecake",
            description: "Cashew and coconut cream cheesecake on a date-walnut crust with seasonal berry coulis.",
            category: .dessert, priceCents: 890, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 4,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: rb6, restaurantId: rawBarId,
            name: "Cold-Pressed Juice Flight",
            description: "Three cold-pressed juices: Green Vitality (kale, apple, ginger), Beet Glow (beet, carrot, turmeric), Citrus Burst (orange, lemon, cayenne).",
            category: .drink, priceCents: 1290, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 5,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
    ]

    // MARK: Sage & Salt (7 dishes)

    static let sageSaltDishes: [RestaurantDish] = [
        RestaurantDish(
            id: ss1, restaurantId: sageSaltId,
            name: "Miso Glazed Cod",
            description: "Black cod marinated in white miso for 48 hours, served with sauteed bok choy and jasmine rice.",
            category: .main, priceCents: 2690, imageURL: nil,
            available: true, isSignatureDish: true, sortOrder: 0,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: ss2, restaurantId: sageSaltId,
            name: "Wagyu Tataki",
            description: "Seared A5 wagyu tataki with ponzu, shaved daikon, microgreens, and truffle oil.",
            category: .starter, priceCents: 2890, imageURL: nil,
            available: true, isSignatureDish: true, sortOrder: 1,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: ss3, restaurantId: sageSaltId,
            name: "Truffle Mushroom Risotto",
            description: "Arborio rice slow-cooked with porcini, shiitake, and finished with black truffle and aged parmesan.",
            category: .main, priceCents: 2490, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 2,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: ss4, restaurantId: sageSaltId,
            name: "Seared Duck Breast",
            description: "Duck breast with cherry gastrique, sweet potato puree, and wilted greens.",
            category: .main, priceCents: 2790, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 3,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: ss5, restaurantId: sageSaltId,
            name: "Tuna Tartare",
            description: "Hand-cut yellowfin tuna with avocado mousse, crispy shallots, and yuzu-soy vinaigrette.",
            category: .starter, priceCents: 2190, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 4,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: ss6, restaurantId: sageSaltId,
            name: "Roasted Cauliflower Steak",
            description: "Whole cauliflower steak with romesco sauce, toasted almonds, capers, and herb oil.",
            category: .main, priceCents: 1990, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 5,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
        RestaurantDish(
            id: ss7, restaurantId: sageSaltId,
            name: "Lobster Linguine",
            description: "Fresh linguine with half lobster, cherry tomatoes, garlic, chili, and white wine bisque.",
            category: .main, priceCents: 3290, imageURL: nil,
            available: true, isSignatureDish: false, sortOrder: 6,
            version: 1, lastAnalyzedAt: analyzedDate, createdAt: createdDate
        ),
    ]

    // MARK: - All Nutritional Profiles

    static let allProfiles: [NutritionalProfile] = greenBowlProfiles + nouriProfiles + rawBarProfiles + sageSaltProfiles

    // MARK: Green Bowl Berlin Profiles

    static let greenBowlProfiles: [NutritionalProfile] = [
        NutritionalProfile(
            id: npGb1, dishId: gb1,
            calories: 520, proteinGrams: 38, carbsGrams: 48, fatGrams: 18, fiberGrams: 6,
            ingredients: ["Salmon", "Sushi rice", "Edamame", "Avocado", "Pickled ginger", "Sesame seeds", "Soy sauce", "Rice vinegar"],
            allergens: [.soy, .sesame, .shellfish],
            micronutrients: ["Omega-3": "1.2g", "Vitamin D": "15% DV", "Iron": "12% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npGb2, dishId: gb2,
            calories: 480, proteinGrams: 22, carbsGrams: 62, fatGrams: 14, fiberGrams: 8,
            ingredients: ["Farro", "Quinoa", "Roasted peppers", "Feta", "Kalamata olives", "Cucumber", "Tahini", "Lemon"],
            allergens: [.dairy, .gluten, .sesame],
            micronutrients: ["Fiber": "32% DV", "Iron": "18% DV", "Vitamin A": "22% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npGb3, dishId: gb3,
            calories: 560, proteinGrams: 35, carbsGrams: 55, fatGrams: 20, fiberGrams: 5,
            ingredients: ["Chicken breast", "Brown rice", "Broccoli", "Carrots", "Teriyaki sauce", "Sesame oil", "Ginger"],
            allergens: [.soy, .sesame, .gluten],
            micronutrients: ["Vitamin C": "25% DV", "B6": "20% DV", "Niacin": "30% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npGb4, dishId: gb4,
            calories: 420, proteinGrams: 16, carbsGrams: 58, fatGrams: 14, fiberGrams: 12,
            ingredients: ["Sweet potato", "Chickpeas", "Quinoa", "Avocado", "Kale", "Tahini", "Lemon"],
            allergens: [.sesame],
            micronutrients: ["Fiber": "48% DV", "Vitamin A": "120% DV", "Iron": "15% DV", "Vitamin K": "80% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npGb5, dishId: gb5,
            calories: 380, proteinGrams: 8, carbsGrams: 65, fatGrams: 12, fiberGrams: 7,
            ingredients: ["Acai puree", "Banana", "Granola", "Coconut flakes", "Blueberries", "Strawberries", "Honey"],
            allergens: [.nuts, .gluten],
            micronutrients: ["Antioxidants": "High", "Vitamin C": "35% DV", "Manganese": "20% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npGb6, dishId: gb6,
            calories: 590, proteinGrams: 45, carbsGrams: 42, fatGrams: 22, fiberGrams: 6,
            ingredients: ["Chicken breast", "Chicken thigh", "Egg", "Brown rice", "Edamame", "Spinach", "Miso", "Ginger"],
            allergens: [.soy, .eggs, .sesame],
            micronutrients: ["Protein": "90% DV", "Iron": "22% DV", "B12": "35% DV", "Zinc": "25% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npGb7, dishId: gb7,
            calories: 340, proteinGrams: 14, carbsGrams: 48, fatGrams: 10, fiberGrams: 9,
            ingredients: ["Quinoa", "Spirulina", "Avocado", "Cucumber", "Sprouts", "Seaweed", "Lime", "Wasabi"],
            allergens: [],
            micronutrients: ["Iron": "25% DV", "Vitamin K": "90% DV", "B12": "15% DV", "Iodine": "30% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
    ]

    // MARK: Nouri Kitchen Profiles

    static let nouriProfiles: [NutritionalProfile] = [
        NutritionalProfile(
            id: npNk1, dishId: nk1,
            calories: 580, proteinGrams: 42, carbsGrams: 35, fatGrams: 26, fiberGrams: 5,
            ingredients: ["Chicken thigh", "Hummus", "Tabbouleh", "Pita bread", "Olive oil", "Garlic", "Sumac"],
            allergens: [.gluten, .sesame],
            micronutrients: ["Protein": "84% DV", "B12": "25% DV", "Zinc": "20% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npNk2, dishId: nk2,
            calories: 640, proteinGrams: 32, carbsGrams: 52, fatGrams: 34, fiberGrams: 4,
            ingredients: ["Lamb mince", "Flatbread", "Yogurt", "Pickled turnip", "Parsley", "Mint", "Onion", "Cumin"],
            allergens: [.gluten, .dairy],
            micronutrients: ["Iron": "28% DV", "B12": "45% DV", "Zinc": "30% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npNk3, dishId: nk3,
            calories: 520, proteinGrams: 18, carbsGrams: 58, fatGrams: 24, fiberGrams: 10,
            ingredients: ["Chickpeas", "Tahini", "Eggplant", "Parsley", "Bulgur", "Pita", "Olive oil", "Lemon"],
            allergens: [.gluten, .sesame],
            micronutrients: ["Fiber": "40% DV", "Iron": "20% DV", "Folate": "30% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npNk4, dishId: nk4,
            calories: 480, proteinGrams: 38, carbsGrams: 22, fatGrams: 26, fiberGrams: 4,
            ingredients: ["Sea bass", "Zucchini", "Bell peppers", "Preserved lemon", "Olive oil", "Capers", "Dill"],
            allergens: [.shellfish],
            micronutrients: ["Omega-3": "1.8g", "Vitamin D": "25% DV", "Selenium": "45% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npNk5, dishId: nk5,
            calories: 420, proteinGrams: 24, carbsGrams: 32, fatGrams: 22, fiberGrams: 5,
            ingredients: ["Eggs", "Tomatoes", "Bell peppers", "Feta", "Sourdough", "Cumin", "Paprika", "Olive oil"],
            allergens: [.eggs, .dairy, .gluten],
            micronutrients: ["Vitamin A": "35% DV", "B12": "30% DV", "Lycopene": "High"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npNk6, dishId: nk6,
            calories: 460, proteinGrams: 28, carbsGrams: 18, fatGrams: 30, fiberGrams: 4,
            ingredients: ["Halloumi", "Rocket", "Roasted peppers", "Pomegranate", "Za'atar", "Olive oil", "Lemon"],
            allergens: [.dairy],
            micronutrients: ["Calcium": "40% DV", "Protein": "56% DV", "Vitamin C": "30% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npNk7, dishId: nk7,
            calories: 550, proteinGrams: 36, carbsGrams: 48, fatGrams: 22, fiberGrams: 3,
            ingredients: ["Chicken thigh", "Basmati rice", "Garlic sauce", "Pickled onion", "Tomato", "Lettuce", "Turmeric"],
            allergens: [.dairy],
            micronutrients: ["Protein": "72% DV", "B6": "30% DV", "Niacin": "35% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npNk8, dishId: nk8,
            calories: 380, proteinGrams: 14, carbsGrams: 42, fatGrams: 18, fiberGrams: 8,
            ingredients: ["Chickpeas", "Tahini", "Olive oil", "Lemon", "Pita bread", "Pickled vegetables", "Paprika"],
            allergens: [.gluten, .sesame],
            micronutrients: ["Fiber": "32% DV", "Iron": "15% DV", "Folate": "20% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
    ]

    // MARK: The Raw Bar Profiles

    static let rawBarProfiles: [NutritionalProfile] = [
        NutritionalProfile(
            id: npRb1, dishId: rb1,
            calories: 380, proteinGrams: 12, carbsGrams: 42, fatGrams: 20, fiberGrams: 8,
            ingredients: ["Zucchini", "Almond butter", "Tamarind", "Bean sprouts", "Peanuts", "Lime", "Cilantro", "Chili"],
            allergens: [.nuts],
            micronutrients: ["Vitamin C": "40% DV", "Manganese": "25% DV", "Vitamin E": "20% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npRb2, dishId: rb2,
            calories: 280, proteinGrams: 8, carbsGrams: 22, fatGrams: 18, fiberGrams: 6,
            ingredients: ["Zucchini", "Sun-dried tomatoes", "Cashews", "Basil", "Olive oil", "Garlic", "Nutritional yeast"],
            allergens: [.nuts],
            micronutrients: ["Vitamin A": "20% DV", "Vitamin K": "35% DV", "B12": "15% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npRb3, dishId: rb3,
            calories: 320, proteinGrams: 10, carbsGrams: 28, fatGrams: 20, fiberGrams: 7,
            ingredients: ["Jicama", "Walnuts", "Cashew cream", "Tomato", "Onion", "Avocado", "Cilantro", "Lime"],
            allergens: [.nuts],
            micronutrients: ["Omega-3": "0.8g", "Vitamin C": "30% DV", "Fiber": "28% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npRb4, dishId: rb4,
            calories: 360, proteinGrams: 14, carbsGrams: 38, fatGrams: 16, fiberGrams: 10,
            ingredients: ["Kale", "Spinach", "Hemp seeds", "Avocado", "Cucumber", "Spirulina", "Olive oil", "Lemon"],
            allergens: [],
            micronutrients: ["Iron": "30% DV", "Vitamin K": "200% DV", "Calcium": "15% DV", "Omega-3": "0.5g"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npRb5, dishId: rb5,
            calories: 310, proteinGrams: 6, carbsGrams: 28, fatGrams: 22, fiberGrams: 3,
            ingredients: ["Cashews", "Coconut cream", "Dates", "Walnuts", "Vanilla", "Lemon", "Mixed berries"],
            allergens: [.nuts],
            micronutrients: ["Healthy fats": "High", "Manganese": "20% DV", "Copper": "15% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npRb6, dishId: rb6,
            calories: 180, proteinGrams: 2, carbsGrams: 42, fatGrams: 1, fiberGrams: 2,
            ingredients: ["Kale", "Apple", "Ginger", "Beetroot", "Carrot", "Turmeric", "Orange", "Lemon", "Cayenne"],
            allergens: [],
            micronutrients: ["Vitamin C": "120% DV", "Vitamin A": "80% DV", "Iron": "10% DV", "Potassium": "15% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
    ]

    // MARK: Sage & Salt Profiles

    static let sageSaltProfiles: [NutritionalProfile] = [
        NutritionalProfile(
            id: npSs1, dishId: ss1,
            calories: 450, proteinGrams: 36, carbsGrams: 28, fatGrams: 22, fiberGrams: 3,
            ingredients: ["Black cod", "White miso", "Bok choy", "Jasmine rice", "Mirin", "Sake", "Sesame oil"],
            allergens: [.soy, .sesame, .shellfish],
            micronutrients: ["Omega-3": "2.1g", "Vitamin D": "30% DV", "Selenium": "55% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npSs2, dishId: ss2,
            calories: 520, proteinGrams: 34, carbsGrams: 12, fatGrams: 38, fiberGrams: 1,
            ingredients: ["Wagyu beef", "Ponzu", "Daikon", "Microgreens", "Truffle oil", "Shiso", "Soy sauce"],
            allergens: [.soy],
            micronutrients: ["Iron": "35% DV", "B12": "80% DV", "Zinc": "40% DV", "Omega-9": "High"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npSs3, dishId: ss3,
            calories: 580, proteinGrams: 16, carbsGrams: 68, fatGrams: 26, fiberGrams: 3,
            ingredients: ["Arborio rice", "Porcini mushrooms", "Shiitake", "Black truffle", "Parmesan", "Butter", "White wine"],
            allergens: [.dairy, .gluten],
            micronutrients: ["Selenium": "30% DV", "Vitamin D": "15% DV", "Copper": "20% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npSs4, dishId: ss4,
            calories: 490, proteinGrams: 32, carbsGrams: 24, fatGrams: 30, fiberGrams: 4,
            ingredients: ["Duck breast", "Cherries", "Sweet potato", "Balsamic", "Butter", "Kale", "Thyme"],
            allergens: [.dairy],
            micronutrients: ["Iron": "25% DV", "B12": "20% DV", "Vitamin A": "110% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npSs5, dishId: ss5,
            calories: 320, proteinGrams: 28, carbsGrams: 12, fatGrams: 18, fiberGrams: 3,
            ingredients: ["Yellowfin tuna", "Avocado", "Shallots", "Yuzu", "Soy sauce", "Sesame oil", "Wonton crisps"],
            allergens: [.soy, .sesame, .shellfish, .gluten],
            micronutrients: ["Omega-3": "1.5g", "Selenium": "60% DV", "Vitamin D": "20% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npSs6, dishId: ss6,
            calories: 380, proteinGrams: 12, carbsGrams: 32, fatGrams: 24, fiberGrams: 8,
            ingredients: ["Cauliflower", "Romesco sauce", "Almonds", "Capers", "Olive oil", "Parsley", "Smoked paprika"],
            allergens: [.nuts],
            micronutrients: ["Vitamin C": "80% DV", "Vitamin K": "40% DV", "Fiber": "32% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
        NutritionalProfile(
            id: npSs7, dishId: ss7,
            calories: 620, proteinGrams: 30, carbsGrams: 58, fatGrams: 28, fiberGrams: 3,
            ingredients: ["Lobster", "Fresh linguine", "Cherry tomatoes", "Garlic", "Chili", "White wine", "Butter", "Parsley"],
            allergens: [.shellfish, .gluten, .dairy],
            micronutrients: ["Protein": "60% DV", "Zinc": "35% DV", "B12": "50% DV", "Copper": "30% DV"],
            analysisMethod: "alche independent analysis", analyzedAt: analyzedDate
        ),
    ]
}
