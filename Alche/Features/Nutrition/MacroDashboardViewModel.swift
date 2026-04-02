import Foundation

@Observable
@MainActor
final class MacroDashboardViewModel {
    // MARK: - State

    var todaySummary: DailyMacroSummary?
    var todayLogs: [MacroLog] = []
    var macroGoal: MacroGoal?
    var isLoading = false
    var errorMessage: String?
    var selectedDate: Date = Date()

    // Manual entry state
    var manualName = ""
    var manualCalories = ""
    var manualProtein = ""
    var manualCarbs = ""
    var manualFat = ""
    var manualFiber = ""
    var manualMealType: MealType = .lunch
    var showManualEntry = false

    // MARK: - Service

    private let service: NutritionTrackingServiceProtocol = MockNutritionTrackingService()

    // Placeholder userId — will come from auth in production
    private let userId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    // MARK: - Load

    func loadToday() async {
        isLoading = true
        errorMessage = nil

        do {
            macroGoal = try await service.macroGoal(userId: userId)
            todaySummary = try await service.dailySummary(userId: userId, date: selectedDate)
            todayLogs = todaySummary?.entries.sorted { $0.loggedAt > $1.loggedAt } ?? []
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadDate(_ date: Date) async {
        selectedDate = date
        await loadToday()
    }

    // MARK: - Log Restaurant Dish

    func logRestaurantDish(
        dishName: String,
        calories: Int,
        protein: Double,
        carbs: Double,
        fat: Double,
        fiber: Double,
        dishId: UUID?,
        dishVersion: Int?,
        mealType: MealType,
        restaurantName: String?
    ) async {
        let entry = MacroLog(
            id: UUID(),
            userId: userId,
            date: selectedDate,
            entryType: .restaurantDish,
            dishId: dishId,
            menuItemId: nil,
            name: dishName,
            calories: calories,
            proteinGrams: protein,
            carbsGrams: carbs,
            fatGrams: fat,
            fiberGrams: fiber,
            mealType: mealType,
            restaurantName: restaurantName,
            dishVersion: dishVersion,
            loggedAt: Date()
        )

        do {
            _ = try await service.logMeal(entry)
            await loadToday()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Manual Entry

    func logManualEntry() async {
        guard !manualName.isEmpty,
              let calories = Int(manualCalories), calories > 0 else {
            errorMessage = "Please enter a meal name and calories."
            return
        }

        let entry = MacroLog(
            id: UUID(),
            userId: userId,
            date: selectedDate,
            entryType: .manual,
            dishId: nil,
            menuItemId: nil,
            name: manualName,
            calories: calories,
            proteinGrams: Double(manualProtein) ?? 0,
            carbsGrams: Double(manualCarbs) ?? 0,
            fatGrams: Double(manualFat) ?? 0,
            fiberGrams: Double(manualFiber) ?? 0,
            mealType: manualMealType,
            restaurantName: nil,
            dishVersion: nil,
            loggedAt: Date()
        )

        do {
            _ = try await service.logMeal(entry)
            resetManualEntry()
            showManualEntry = false
            await loadToday()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Delete

    func deleteEntry(_ log: MacroLog) async {
        do {
            try await service.deleteLog(id: log.id)
            await loadToday()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Update Goal

    func updateGoal(calories: Int, protein: Double, carbs: Double, fat: Double) async {
        let updatedGoal = MacroGoal(
            id: macroGoal?.id ?? UUID(),
            userId: userId,
            dailyCalories: calories,
            dailyProteinGrams: protein,
            dailyCarbsGrams: carbs,
            dailyFatGrams: fat,
            isActive: true,
            createdAt: macroGoal?.createdAt ?? Date()
        )

        do {
            macroGoal = try await service.updateMacroGoal(updatedGoal)
            await loadToday()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Helpers

    private func resetManualEntry() {
        manualName = ""
        manualCalories = ""
        manualProtein = ""
        manualCarbs = ""
        manualFat = ""
        manualFiber = ""
        manualMealType = .lunch
    }

    var isManualEntryValid: Bool {
        !manualName.isEmpty && (Int(manualCalories) ?? 0) > 0
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }
}
