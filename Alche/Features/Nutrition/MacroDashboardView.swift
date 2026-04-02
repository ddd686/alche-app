import SwiftUI

struct MacroDashboardView: View {
    @State private var viewModel = MacroDashboardViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                // Date selector
                DateSelectorStrip(
                    selectedDate: viewModel.selectedDate,
                    onSelect: { date in
                        Task { await viewModel.loadDate(date) }
                    }
                )

                if viewModel.isLoading {
                    VStack(spacing: AlcheSpacing.md) {
                        ProgressView()
                            .tint(Color.alchePrimary)
                        Text("Loading your nutrition data...")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, AlcheSpacing.xl)
                } else {
                    // Calorie ring
                    calorieRingSection

                    // Macro progress bars
                    macroBarSection

                    // Today's meals
                    mealsSection

                    // Add meal button
                    addMealButton

                    // Disclaimer
                    Text("Nutritional values are approximate and based on standard preparation methods.")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, AlcheSpacing.lg)

                    // Sample data indicator
                    HStack {
                        Spacer()
                        DataSourceIndicator(isMock: true)
                        Spacer()
                    }
                    .padding(.bottom, AlcheSpacing.lg)
                }
            }
            .padding(.top, AlcheSpacing.md)
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Nutrition")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    RestaurantListView()
                } label: {
                    Image(systemName: "fork.knife")
                        .foregroundStyle(Color.alchePrimary)
                }
            }
        }
        .sheet(isPresented: $viewModel.showManualEntry) {
            MacroLogEntryView(viewModel: viewModel)
        }
        .task {
            await viewModel.loadToday()
        }
    }

    // MARK: - Calorie Ring Section

    private var calorieRingSection: some View {
        AlcheCard(shadow: .medium) {
            VStack(spacing: AlcheSpacing.md) {
                Text("DAILY CALORIES")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .tracking(0.8)

                MacroProgressRing(
                    consumed: viewModel.todaySummary?.totalCalories ?? 0,
                    goal: viewModel.macroGoal?.dailyCalories ?? 2000
                )
                .frame(width: 180, height: 180)

                if let summary = viewModel.todaySummary {
                    let remaining = summary.caloriesRemaining
                    if remaining > 0 {
                        Text("\(remaining) kcal remaining")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSage)
                    } else {
                        Text("Goal reached")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alchePrimary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, AlcheSpacing.lg)
    }

    // MARK: - Macro Bar Section

    private var macroBarSection: some View {
        AlcheCard {
            VStack(spacing: AlcheSpacing.md) {
                Text("MACROS")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .tracking(0.8)
                    .frame(maxWidth: .infinity, alignment: .leading)

                MacroProgressBar(
                    label: "Protein",
                    current: viewModel.todaySummary?.totalProtein ?? 0,
                    goal: viewModel.macroGoal?.dailyProteinGrams ?? 130,
                    color: .alcheSage
                )

                MacroProgressBar(
                    label: "Carbs",
                    current: viewModel.todaySummary?.totalCarbs ?? 0,
                    goal: viewModel.macroGoal?.dailyCarbsGrams ?? 220,
                    color: .alcheAmber
                )

                MacroProgressBar(
                    label: "Fat",
                    current: viewModel.todaySummary?.totalFat ?? 0,
                    goal: viewModel.macroGoal?.dailyFatGrams ?? 65,
                    color: .alchePrimary
                )

                // Fiber (informational, no goal bar)
                if let fiber = viewModel.todaySummary?.totalFiber, fiber > 0 {
                    HStack {
                        Text("Fiber")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alchePrimaryText)
                        Spacer()
                        Text("\(Int(fiber))g")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                }
            }
        }
        .padding(.horizontal, AlcheSpacing.lg)
    }

    // MARK: - Meals Section

    private var mealsSection: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
            Text(viewModel.isToday ? "TODAY'S MEALS" : "MEALS")
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheSecondaryText)
                .tracking(0.8)
                .padding(.horizontal, AlcheSpacing.lg)

            if viewModel.todayLogs.isEmpty {
                AlcheCard {
                    VStack(spacing: AlcheSpacing.sm) {
                        Image(systemName: "fork.knife")
                            .font(.alcheHeading)
                            .foregroundStyle(Color.alcheWarmGray)

                        Text("No meals logged yet")
                            .font(.alcheBody)
                            .foregroundStyle(Color.alcheSecondaryText)

                        Text("Add a meal to start tracking your macros.")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, AlcheSpacing.lg)
            } else {
                ForEach(viewModel.todayLogs) { log in
                    MealLogRow(log: log, onDelete: {
                        Task { await viewModel.deleteEntry(log) }
                    })
                    .padding(.horizontal, AlcheSpacing.lg)
                }
            }
        }
    }

    // MARK: - Add Meal Button

    private var addMealButton: some View {
        AlcheButton("Add Meal", style: .secondary, icon: "plus") {
            viewModel.showManualEntry = true
        }
        .padding(.horizontal, AlcheSpacing.lg)
    }
}

// MARK: - Date Selector Strip

private struct DateSelectorStrip: View {
    let selectedDate: Date
    let onSelect: (Date) -> Void

    private let calendar = Calendar.current
    private let dayCount = 7

    private var dates: [Date] {
        let today = calendar.startOfDay(for: Date())
        return (0..<dayCount).compactMap { offset in
            calendar.date(byAdding: .day, value: -(dayCount - 1 - offset), to: today)
        }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AlcheSpacing.sm) {
                ForEach(dates, id: \.self) { date in
                    let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                    let isToday = calendar.isDateInToday(date)

                    Button {
                        onSelect(date)
                    } label: {
                        VStack(spacing: AlcheSpacing.xs) {
                            Text(dayAbbreviation(date))
                                .font(.alcheOverline)
                                .foregroundStyle(isSelected ? Color.alcheWhite : Color.alcheSecondaryText)

                            Text("\(calendar.component(.day, from: date))")
                                .font(.alcheBodyMedium)
                                .foregroundStyle(isSelected ? Color.alcheWhite : Color.alchePrimaryText)
                        }
                        .frame(width: 44, height: 56)
                        .background(
                            isSelected
                                ? Color.alchePrimary
                                : (isToday ? Color.alcheWarmGray.opacity(0.5) : Color.clear)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AlcheSpacing.lg)
        }
    }

    private func dayAbbreviation(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }
}

// MARK: - Meal Log Row (Task 2.6)

private struct MealLogRow: View {
    let log: MacroLog
    var onDelete: (() -> Void)?

    var body: some View {
        AlcheCard {
            HStack(spacing: AlcheSpacing.md) {
                // Meal type icon
                ZStack {
                    Circle()
                        .fill(mealTypeColor.opacity(0.15))
                        .frame(width: 40, height: 40)

                    Image(systemName: log.mealType.icon)
                        .font(.alcheBody)
                        .foregroundStyle(mealTypeColor)
                }

                // Name and source
                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text(log.name)
                        .font(.alcheBodyMedium)
                        .foregroundStyle(Color.alchePrimaryText)
                        .lineLimit(1)

                    Text(log.restaurantName ?? log.mealType.displayName)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .lineLimit(1)
                }

                Spacer()

                // Calories and time
                VStack(alignment: .trailing, spacing: AlcheSpacing.xs) {
                    Text("\(log.calories) kcal")
                        .font(.alcheBodyMedium)
                        .foregroundStyle(Color.alchePrimaryText)

                    Text(formattedTime)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
        .contextMenu {
            if let onDelete {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }

    private var mealTypeColor: Color {
        switch log.mealType {
        case .breakfast: .alcheAmber
        case .lunch: .alcheSage
        case .dinner: .alchePrimary
        case .snack: .alcheInfo
        }
    }

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: log.loggedAt)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        MacroDashboardView()
    }
}
