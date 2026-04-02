import Foundation

// MARK: - Enums

enum MacroLogEntryType: String, Codable, Sendable {
    case restaurantDish = "restaurant_dish"
    case manual
    case smoothie

    var displayName: String {
        switch self {
        case .restaurantDish: "Restaurant"
        case .manual: "Manual"
        case .smoothie: "Smoothie"
        }
    }

    var icon: String {
        switch self {
        case .restaurantDish: "fork.knife"
        case .manual: "pencil"
        case .smoothie: "cup.and.saucer"
        }
    }
}

enum MealType: String, Codable, Sendable, CaseIterable {
    case breakfast
    case lunch
    case dinner
    case snack

    var displayName: String {
        switch self {
        case .breakfast: "Breakfast"
        case .lunch: "Lunch"
        case .dinner: "Dinner"
        case .snack: "Snack"
        }
    }

    var icon: String {
        switch self {
        case .breakfast: "sunrise"
        case .lunch: "sun.max"
        case .dinner: "moon.stars"
        case .snack: "leaf"
        }
    }
}

// MARK: - MacroLog

struct MacroLog: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    var date: Date
    var entryType: MacroLogEntryType
    var dishId: UUID?
    var menuItemId: UUID?
    var name: String
    var calories: Int
    var proteinGrams: Double
    var carbsGrams: Double
    var fatGrams: Double
    var fiberGrams: Double
    var mealType: MealType
    var restaurantName: String?
    var dishVersion: Int?
    let loggedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case date
        case entryType = "entry_type"
        case dishId = "dish_id"
        case menuItemId = "menu_item_id"
        case name
        case calories
        case proteinGrams = "protein_grams"
        case carbsGrams = "carbs_grams"
        case fatGrams = "fat_grams"
        case fiberGrams = "fiber_grams"
        case mealType = "meal_type"
        case restaurantName = "restaurant_name"
        case dishVersion = "dish_version"
        case loggedAt = "logged_at"
    }
}

extension MacroLog {
    static let preview = MacroLog(
        id: UUID(),
        userId: UUID(),
        date: Date(),
        entryType: .restaurantDish,
        dishId: UUID(),
        menuItemId: nil,
        name: "Salmon Poke Bowl",
        calories: 520,
        proteinGrams: 38,
        carbsGrams: 48,
        fatGrams: 18,
        fiberGrams: 6,
        mealType: .lunch,
        restaurantName: "Green Bowl Berlin",
        dishVersion: 1,
        loggedAt: Date()
    )

    static let allPreviews: [MacroLog] = [
        .preview,
        MacroLog(
            id: UUID(),
            userId: UUID(),
            date: Date(),
            entryType: .manual,
            dishId: nil,
            menuItemId: nil,
            name: "Overnight Oats",
            calories: 380,
            proteinGrams: 14,
            carbsGrams: 52,
            fatGrams: 12,
            fiberGrams: 8,
            mealType: .breakfast,
            restaurantName: nil,
            dishVersion: nil,
            loggedAt: Date().addingTimeInterval(-14400)
        ),
        MacroLog(
            id: UUID(),
            userId: UUID(),
            date: Date(),
            entryType: .smoothie,
            dishId: nil,
            menuItemId: UUID(),
            name: "Golden Glow Smoothie",
            calories: 180,
            proteinGrams: 4,
            carbsGrams: 32,
            fatGrams: 6,
            fiberGrams: 2,
            mealType: .snack,
            restaurantName: nil,
            dishVersion: nil,
            loggedAt: Date().addingTimeInterval(-7200)
        ),
    ]
}

// MARK: - MacroGoal

struct MacroGoal: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    var dailyCalories: Int
    var dailyProteinGrams: Double
    var dailyCarbsGrams: Double
    var dailyFatGrams: Double
    var isActive: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case dailyCalories = "daily_calories"
        case dailyProteinGrams = "daily_protein_grams"
        case dailyCarbsGrams = "daily_carbs_grams"
        case dailyFatGrams = "daily_fat_grams"
        case isActive = "is_active"
        case createdAt = "created_at"
    }

    static let defaultGoal = MacroGoal(
        id: UUID(),
        userId: UUID(),
        dailyCalories: 2000,
        dailyProteinGrams: 130,
        dailyCarbsGrams: 220,
        dailyFatGrams: 65,
        isActive: true,
        createdAt: Date()
    )
}

extension MacroGoal {
    static let preview = defaultGoal
}

// MARK: - DailyMacroSummary (computed, not persisted)

struct DailyMacroSummary: Sendable {
    let date: Date
    let entries: [MacroLog]
    let goal: MacroGoal?

    var totalCalories: Int { entries.reduce(0) { $0 + $1.calories } }
    var totalProtein: Double { entries.reduce(0) { $0 + $1.proteinGrams } }
    var totalCarbs: Double { entries.reduce(0) { $0 + $1.carbsGrams } }
    var totalFat: Double { entries.reduce(0) { $0 + $1.fatGrams } }
    var totalFiber: Double { entries.reduce(0) { $0 + $1.fiberGrams } }
    var entryCount: Int { entries.count }

    // Goal progress (0.0 - 1.0+)
    var calorieProgress: Double {
        guard let goal, goal.dailyCalories > 0 else { return 0 }
        return Double(totalCalories) / Double(goal.dailyCalories)
    }

    var proteinProgress: Double {
        guard let goal, goal.dailyProteinGrams > 0 else { return 0 }
        return totalProtein / goal.dailyProteinGrams
    }

    var carbsProgress: Double {
        guard let goal, goal.dailyCarbsGrams > 0 else { return 0 }
        return totalCarbs / goal.dailyCarbsGrams
    }

    var fatProgress: Double {
        guard let goal, goal.dailyFatGrams > 0 else { return 0 }
        return totalFat / goal.dailyFatGrams
    }

    // Remaining
    var caloriesRemaining: Int {
        guard let goal else { return 0 }
        return max(0, goal.dailyCalories - totalCalories)
    }

    var proteinRemaining: Double {
        guard let goal else { return 0 }
        return max(0, goal.dailyProteinGrams - totalProtein)
    }

    var carbsRemaining: Double {
        guard let goal else { return 0 }
        return max(0, goal.dailyCarbsGrams - totalCarbs)
    }

    var fatRemaining: Double {
        guard let goal else { return 0 }
        return max(0, goal.dailyFatGrams - totalFat)
    }

    static let empty = DailyMacroSummary(date: Date(), entries: [], goal: .defaultGoal)

    static let preview = DailyMacroSummary(
        date: Date(),
        entries: MacroLog.allPreviews,
        goal: .defaultGoal
    )
}
