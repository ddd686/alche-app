import SwiftUI

struct DishDetailView: View {
    let dish: RestaurantDish
    let restaurant: PartnerRestaurant
    let profile: NutritionalProfile?

    @State private var showMealTypePicker = false
    @State private var showLogConfirmation = false
    @State private var isLogging = false
    @State private var todaySummary: DailyMacroSummary?
    @State private var macroGoal: MacroGoal?

    private let nutritionService: NutritionTrackingServiceProtocol = MockNutritionTrackingService()

    // Placeholder userId — matches MacroDashboardViewModel
    private let userId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                // Header
                headerSection

                if let profile {
                    // Nutrition Facts with daily budget context
                    nutritionFactsSection(profile: profile)

                    // Ingredients
                    ingredientsSection(profile: profile)

                    // Allergens
                    allergensSection(profile: profile)

                    // Micronutrients
                    micronutrientsSection(profile: profile)
                }

                // Description
                if let description = dish.description {
                    Text(description)
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .lineSpacing(4)
                }

                // Disclaimer
                Text("Nutritional values are approximate and based on standard preparation methods. Actual values may vary.")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText.opacity(0.5))
                    .padding(.top, AlcheSpacing.sm)

                DataSourceIndicator(isMock: true)
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.top, AlcheSpacing.md)
            .padding(.bottom, 100)
        }
        .background(Color.alcheBackground)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            if profile != nil {
                bottomLogButton
            }
        }
        .sheet(isPresented: $showMealTypePicker) {
            MealTypePickerSheet(
                dishName: dish.name,
                isLogging: $isLogging
            ) { mealType in
                await logMeal(mealType: mealType)
            }
            .presentationDetents([.medium])
        }
        .overlay {
            if showLogConfirmation {
                logConfirmationOverlay
            }
        }
        .task {
            await loadDailyBudget()
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
            Text(dish.name)
                .font(.alcheDisplayL)
                .foregroundStyle(Color.alchePrimaryText)

            HStack(spacing: AlcheSpacing.sm) {
                Text(restaurant.name)
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)

                if dish.isSignatureDish {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 9))
                        Text("Signature")
                            .font(.alcheOverline)
                    }
                    .foregroundStyle(Color.alcheAmber)
                }
            }

            Text("EUR \(dish.formattedPrice)")
                .font(.alcheSubheading)
                .foregroundStyle(Color.alchePrimaryText)
        }
    }

    // MARK: - Nutrition Facts

    @ViewBuilder
    private func nutritionFactsSection(profile: NutritionalProfile) -> some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.md) {
            HStack {
                Text("NUTRITION FACTS")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .tracking(0.8)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 10))
                    Text("alche verified")
                        .font(.alcheOverline)
                }
                .foregroundStyle(Color.alcheSage)
            }

            // Calorie ring — shows dish calories against user's remaining daily budget
            HStack {
                Spacer()
                MacroProgressRing(
                    consumed: profile.calories,
                    goal: calorieGoal
                )
                .frame(width: 160, height: 160)
                Spacer()
            }

            // Daily budget context
            if let summary = todaySummary, let goal = macroGoal {
                DailyBudgetContextBar(
                    consumed: summary.totalCalories,
                    dishAdds: profile.calories,
                    goal: goal.dailyCalories,
                    unit: "kcal"
                )
            }

            // Macro bars — show dish macros against user's remaining daily budget
            VStack(spacing: AlcheSpacing.md) {
                MacroProgressBar(
                    label: "Protein",
                    current: profile.proteinGrams,
                    goal: proteinGoal,
                    color: .alcheSage
                )
                MacroProgressBar(
                    label: "Carbs",
                    current: profile.carbsGrams,
                    goal: carbsGoal,
                    color: .alcheAmber
                )
                MacroProgressBar(
                    label: "Fat",
                    current: profile.fatGrams,
                    goal: fatGoal,
                    color: .alchePrimary
                )
            }

            // Fiber
            HStack {
                Text("Fiber")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alchePrimaryText)
                Spacer()
                Text(profile.formattedFiber)
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
            }

            // Macro percentages
            let percentages = profile.macroPercentages
            HStack(spacing: AlcheSpacing.md) {
                MacroPercentageChip(
                    label: "P",
                    value: Int(percentages.protein),
                    color: .alcheSage
                )
                MacroPercentageChip(
                    label: "C",
                    value: Int(percentages.carbs),
                    color: .alcheAmber
                )
                MacroPercentageChip(
                    label: "F",
                    value: Int(percentages.fat),
                    color: .alchePrimary
                )
            }
            .frame(maxWidth: .infinity)

            // Analyzed date
            Text("Analyzed: \(profile.analyzedAt.formatted(date: .abbreviated, time: .omitted))")
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheSecondaryText)
        }
        .padding(AlcheSpacing.md)
        .background(Color.alcheSurface)
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
    }

    // MARK: - Ingredients

    @ViewBuilder
    private func ingredientsSection(profile: NutritionalProfile) -> some View {
        if !profile.ingredients.isEmpty {
            VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                Text("INGREDIENTS")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .tracking(0.8)

                Text(profile.ingredients.joined(separator: ", "))
                    .font(.alcheBody)
                    .foregroundStyle(Color.alchePrimaryText)
            }
            .padding(AlcheSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.alcheSurface)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
        }
    }

    // MARK: - Allergens

    @ViewBuilder
    private func allergensSection(profile: NutritionalProfile) -> some View {
        if !profile.allergens.isEmpty {
            VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                Text("ALLERGENS")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .tracking(0.8)

                FlowLayout(spacing: AlcheSpacing.sm) {
                    ForEach(profile.allergens, id: \.self) { allergen in
                        AlcheTag(
                            text: allergen.displayName,
                            color: .alcheAmber
                        )
                    }
                }
            }
            .padding(AlcheSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.alcheSurface)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
        }
    }

    // MARK: - Micronutrients

    @ViewBuilder
    private func micronutrientsSection(profile: NutritionalProfile) -> some View {
        if let micronutrients = profile.micronutrients, !micronutrients.isEmpty {
            VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                Text("MICRONUTRIENTS")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .tracking(0.8)

                ForEach(micronutrients.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text(key)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alchePrimaryText)
                        Spacer()
                        Text(value)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                }
            }
            .padding(AlcheSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.alcheSurface)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
        }
    }

    // MARK: - Bottom Log Button

    private var bottomLogButton: some View {
        VStack(spacing: 0) {
            Divider()

            Button {
                showMealTypePicker = true
            } label: {
                HStack(spacing: AlcheSpacing.sm) {
                    Image(systemName: "plus.circle.fill")
                        .font(.alcheBody)
                    Text("Add to Today's Log")
                        .font(.alcheBodyMedium)
                }
                .foregroundStyle(Color.alcheWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.alchePrimary)
                .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
            }
            .disabled(isLogging)
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.vertical, AlcheSpacing.md)
        }
        .background(.ultraThinMaterial)
    }

    // MARK: - Load Daily Budget

    private func loadDailyBudget() async {
        do {
            macroGoal = try await nutritionService.macroGoal(userId: userId)
            todaySummary = try await nutritionService.dailySummary(userId: userId, date: Date())
        } catch {
            // Fall back to default goal if loading fails
            macroGoal = .defaultGoal
        }
    }

    // MARK: - Goal Computations (remaining daily budget)

    /// The calorie ring shows this dish's calories against the user's remaining daily budget.
    /// If user has consumed 800 of 2000, remaining is 1200. Ring shows dish cals vs 1200.
    private var calorieGoal: Int {
        guard let goal = macroGoal else { return 2000 }
        let remaining = max(1, goal.dailyCalories - (todaySummary?.totalCalories ?? 0))
        return remaining
    }

    private var proteinGoal: Double {
        guard let goal = macroGoal else { return 130 }
        let remaining = max(1, goal.dailyProteinGrams - (todaySummary?.totalProtein ?? 0))
        return remaining
    }

    private var carbsGoal: Double {
        guard let goal = macroGoal else { return 220 }
        let remaining = max(1, goal.dailyCarbsGrams - (todaySummary?.totalCarbs ?? 0))
        return remaining
    }

    private var fatGoal: Double {
        guard let goal = macroGoal else { return 65 }
        let remaining = max(1, goal.dailyFatGrams - (todaySummary?.totalFat ?? 0))
        return remaining
    }

    // MARK: - Log Meal

    private func logMeal(mealType: MealType) async {
        guard let profile else { return }

        isLogging = true
        let entry = MacroLog(
            id: UUID(),
            userId: userId,
            date: Date(),
            entryType: .restaurantDish,
            dishId: dish.id,
            menuItemId: nil,
            name: dish.name,
            calories: profile.calories,
            proteinGrams: profile.proteinGrams,
            carbsGrams: profile.carbsGrams,
            fatGrams: profile.fatGrams,
            fiberGrams: profile.fiberGrams,
            mealType: mealType,
            restaurantName: restaurant.name,
            dishVersion: dish.version,
            loggedAt: Date()
        )

        _ = try? await nutritionService.logMeal(entry)
        isLogging = false
        showMealTypePicker = false

        // Refresh daily budget after logging
        await loadDailyBudget()

        withAnimation(.alcheDefault) {
            showLogConfirmation = true
        }

        try? await Task.sleep(for: .seconds(2))
        withAnimation(.alcheDefault) {
            showLogConfirmation = false
        }
    }

    // MARK: - Confirmation Overlay

    private var logConfirmationOverlay: some View {
        VStack(spacing: AlcheSpacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 36))
                .foregroundStyle(Color.alcheSage)

            Text("Logged")
                .font(.alcheSubheading)
                .foregroundStyle(Color.alchePrimaryText)

            Text("\(dish.name) added to today's log")
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheSecondaryText)
        }
        .padding(AlcheSpacing.lg)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.lg))
        .transition(.scale.combined(with: .opacity))
    }
}

// MARK: - Daily Budget Context Bar

/// Shows how the dish fits within the user's daily budget:
/// "Already consumed X kcal today. This dish adds Y kcal. (Z remaining)"
private struct DailyBudgetContextBar: View {
    let consumed: Int
    let dishAdds: Int
    let goal: Int
    let unit: String

    private var remaining: Int {
        max(0, goal - consumed - dishAdds)
    }

    private var wouldExceed: Bool {
        consumed + dishAdds > goal
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            // Stacked bar showing consumed + dish portion
            GeometryReader { geo in
                let totalWidth = geo.size.width
                let consumedWidth = goal > 0 ? totalWidth * min(CGFloat(consumed) / CGFloat(goal), 1.0) : 0
                let dishWidth = goal > 0 ? totalWidth * min(CGFloat(dishAdds) / CGFloat(goal), 1.0 - min(CGFloat(consumed) / CGFloat(goal), 1.0)) : 0

                ZStack(alignment: .leading) {
                    // Track
                    Capsule()
                        .fill(Color.alcheWarmGray)
                        .frame(height: 6)

                    // Already consumed (muted)
                    Capsule()
                        .fill(Color.alcheSecondaryText.opacity(0.3))
                        .frame(width: max(0, consumedWidth), height: 6)

                    // This dish contribution (highlighted)
                    Capsule()
                        .fill(wouldExceed ? Color.alcheError.opacity(0.7) : Color.alchePrimary.opacity(0.7))
                        .frame(width: max(0, dishWidth), height: 6)
                        .offset(x: consumedWidth)
                }
            }
            .frame(height: 6)

            HStack {
                Text("\(consumed) \(unit) consumed today")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText)

                Spacer()

                if wouldExceed {
                    Text("Exceeds budget by \(consumed + dishAdds - goal) \(unit)")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheError)
                } else {
                    Text("\(remaining) \(unit) remaining after")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSage)
                }
            }
        }
    }
}

// MARK: - Meal Type Picker Sheet

private struct MealTypePickerSheet: View {
    let dishName: String
    @Binding var isLogging: Bool
    let onSelect: (MealType) async -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: AlcheSpacing.lg) {
                VStack(spacing: AlcheSpacing.sm) {
                    Text("Log as...")
                        .font(.alcheHeading)
                        .foregroundStyle(Color.alchePrimaryText)

                    Text(dishName)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }

                VStack(spacing: AlcheSpacing.md) {
                    ForEach(MealType.allCases, id: \.self) { mealType in
                        Button {
                            Task {
                                await onSelect(mealType)
                            }
                        } label: {
                            HStack(spacing: AlcheSpacing.md) {
                                Image(systemName: mealType.icon)
                                    .font(.alcheSubheading)
                                    .foregroundStyle(Color.alchePrimary)
                                    .frame(width: 32)

                                Text(mealType.displayName)
                                    .font(.alcheBodyMedium)
                                    .foregroundStyle(Color.alchePrimaryText)

                                Spacer()

                                if isLogging {
                                    ProgressView()
                                        .tint(Color.alchePrimary)
                                }
                            }
                            .padding(AlcheSpacing.md)
                            .background(Color.alcheSurface)
                            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                        }
                        .buttonStyle(.plain)
                        .disabled(isLogging)
                    }
                }

                Spacer()
            }
            .padding(AlcheSpacing.lg)
            .background(Color.alcheBackground)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
    }
}

// MARK: - Macro Percentage Chip

private struct MacroPercentageChip: View {
    let label: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.alcheOverline)
                .foregroundStyle(color)
            Text("\(value)%")
                .font(.alcheCaption)
                .foregroundStyle(Color.alchePrimaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AlcheSpacing.sm)
        .background(color.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
    }
}

// MARK: - Flow Layout

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        arrange(proposal: proposal, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            maxX = max(maxX, currentX)
        }

        return (CGSize(width: maxX, height: currentY + lineHeight), positions)
    }
}

#Preview {
    NavigationStack {
        DishDetailView(
            dish: .preview,
            restaurant: .preview,
            profile: .preview
        )
    }
}
