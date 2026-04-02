# Eat Smart Outside — Task Breakdown by Terminal

**Feature ID:** REQ-025
**Reference:** `specs/REQ-025-eat-smart-outside/prd.md`
**Architecture:** Follow existing patterns in `Alche/Core/Models/`, `Alche/Core/Services/`, `Alche/Core/MockServices/`, `Alche/Features/`

---

## Dependency Graph

```
Terminal 1 (Data Layer) ──────────────┐
                                      ├──→ Terminal 3 (Restaurant UI)
Terminal 2 (Macro Tracking Core) ─────┤
                                      └──→ Terminal 4 (Integration)
```

Terminals 1 and 2 can run in parallel (no shared dependencies).
Terminals 3 and 4 depend on both 1 and 2 completing first.
Terminal 3 and 4 can then run in parallel.

---

## Terminal 1: Data Layer — Models, Enums, Service Protocols

**Goal:** Create all new data types and service contracts. No UI, no ViewModels.

### Task 1.1 — Restaurant Enums

**File:** `Alche/Core/Models/PartnerRestaurant.swift` (top of file, before struct)

Create these enums following the pattern in `Product.swift` (lines 1-45):

```swift
enum CuisineType: String, Codable, Sendable, CaseIterable {
    case mediterranean, asian, german, fusion, vegan, raw, bowls
    // var displayName: String { ... }
}

enum PriceRange: String, Codable, Sendable {
    case budget, moderate, premium
    // var displayName: String → "€", "€€", "€€€"
    // var symbol: String → same
}

enum PartnershipStatus: String, Codable, Sendable {
    case active, pending, paused
}
```

### Task 1.2 — PartnerRestaurant Model

**File:** `Alche/Core/Models/PartnerRestaurant.swift`

Follow `Event.swift` pattern exactly (Codable, Identifiable, Sendable, Hashable + CodingKeys):

```swift
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

    enum CodingKeys: String, CodingKey { /* snake_case mapping */ }

    // Computed: var isActive: Bool { partnershipStatus == .active }
}

// extension PartnerRestaurant { static let preview = ... }
// extension PartnerRestaurant { static let allPreviews: [PartnerRestaurant] = [...] }
```

Add preview extensions with 4 Berlin restaurants (see PRD Section 9).

### Task 1.3 — RestaurantDish + NutritionalProfile Models

**File:** `Alche/Core/Models/RestaurantDish.swift`

```swift
enum DishCategory: String, Codable, Sendable, CaseIterable {
    case starter, main, side, dessert, drink
    // var displayName
}

enum Allergen: String, Codable, Sendable, CaseIterable {
    case gluten, dairy, nuts, soy, eggs, shellfish, sesame
    // var displayName, var icon: String (SF Symbol)
}

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

    enum CodingKeys: String, CodingKey { /* snake_case */ }

    // var formattedPrice: String (match Product.formattedPrice pattern)
}

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

    enum CodingKeys: String, CodingKey { /* snake_case */ }

    // Computed helpers:
    // var formattedCalories: String
    // var formattedProtein: String (e.g., "38g")
    // var macroPercentages: (protein: Double, carbs: Double, fat: Double)
}
```

Add preview extensions. Each preview dish must have a linked NutritionalProfile preview.

### Task 1.4 — MacroLog + MacroGoal Models

**File:** `Alche/Core/Models/MacroLog.swift`

```swift
enum MacroLogEntryType: String, Codable, Sendable {
    case restaurantDish, manual, smoothie
    // var displayName, var icon: String
}

enum MealType: String, Codable, Sendable, CaseIterable {
    case breakfast, lunch, dinner, snack
    // var displayName, var icon: String
}

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

    enum CodingKeys: String, CodingKey { /* snake_case */ }
}

struct MacroGoal: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    var dailyCalories: Int
    var dailyProteinGrams: Double
    var dailyCarbsGrams: Double
    var dailyFatGrams: Double
    var isActive: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey { /* snake_case */ }

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
```

### Task 1.5 — DailyMacroSummary (computed struct, not persisted)

**File:** `Alche/Core/Models/MacroLog.swift` (below MacroGoal)

```swift
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
    var calorieProgress: Double { /* totalCalories / goal.dailyCalories */ }
    var proteinProgress: Double { ... }
    var carbsProgress: Double { ... }
    var fatProgress: Double { ... }

    // Remaining
    var caloriesRemaining: Int { ... }
    var proteinRemaining: Double { ... }
}
```

### Task 1.6 — Service Protocols

**File:** `Alche/Core/Services/RestaurantServiceProtocol.swift`

```swift
protocol RestaurantServiceProtocol: Sendable {
    func allRestaurants() async throws -> [PartnerRestaurant]
    func restaurants(cuisine: CuisineType) async throws -> [PartnerRestaurant]
    func restaurant(id: UUID) async throws -> PartnerRestaurant
    func dishes(restaurantId: UUID) async throws -> [RestaurantDish]
    func dish(id: UUID) async throws -> RestaurantDish
    func nutritionalProfile(dishId: UUID) async throws -> NutritionalProfile
}
```

**File:** `Alche/Core/Services/NutritionTrackingServiceProtocol.swift`

```swift
protocol NutritionTrackingServiceProtocol: Sendable {
    func logMeal(_ entry: MacroLog) async throws -> MacroLog
    func todayLogs(userId: UUID) async throws -> [MacroLog]
    func logs(userId: UUID, from: Date, to: Date) async throws -> [MacroLog]
    func deleteLog(id: UUID) async throws
    func dailySummary(userId: UUID, date: Date) async throws -> DailyMacroSummary
    func macroGoal(userId: UUID) async throws -> MacroGoal?
    func updateMacroGoal(_ goal: MacroGoal) async throws -> MacroGoal
}
```

### Task 1.7 — Mock Restaurant Service

**File:** `Alche/Core/MockServices/MockRestaurantService.swift`

Follow `MockGlowScanService.swift` pattern:
- Conform to `RestaurantServiceProtocol`
- Hard-coded mock data (4 restaurants, 6-8 dishes each, all with NutritionalProfiles)
- Use `MockDataGenerator.shared` for any seeded randomness
- Simulate 0.3-0.8s network delay with `try await Task.sleep(for:)`
- Store nothing in UserDefaults (restaurant data is read-only)

**Restaurant data (Berlin-specific, realistic):**

1. **Green Bowl Berlin** — Bowls, Mitte, €€
   - Salmon Poke Bowl: 520 cal, 38P/48C/18F
   - Mediterranean Grain Bowl: 480 cal, 22P/62C/14F
   - Chicken Teriyaki Bowl: 560 cal, 35P/55C/20F
   - Vegan Buddha Bowl: 420 cal, 16P/58C/14F
   - Açaí Power Bowl: 380 cal, 8P/65C/12F
   - Protein Recovery Bowl: 590 cal, 45P/42C/22F
   - Green Detox Bowl: 340 cal, 14P/48C/10F

2. **Nouri Kitchen** — Mediterranean, Kreuzberg, €€
   - Grilled Chicken Plate: 580 cal, 42P/35C/26F
   - Lamb Kofta Wrap: 640 cal, 32P/52C/34F
   - Falafel Mezze Plate: 520 cal, 18P/58C/24F
   - Grilled Sea Bass: 480 cal, 38P/22C/26F
   - Shakshuka: 420 cal, 24P/32C/22F
   - Halloumi Salad: 460 cal, 28P/18C/30F
   - Chicken Shawarma Bowl: 550 cal, 36P/48C/22F
   - Hummus & Pita Plate: 380 cal, 14P/42C/18F

3. **The Raw Bar** — Raw/Vegan, Prenzlauer Berg, €
   - Raw Pad Thai: 380 cal, 12P/42C/20F
   - Zucchini Pasta: 280 cal, 8P/22C/18F
   - Raw Tacos: 320 cal, 10P/28C/20F
   - Green Goddess Bowl: 360 cal, 14P/38C/16F
   - Raw Cheesecake (slice): 310 cal, 6P/28C/22F
   - Cold-Pressed Juice Flight: 180 cal, 2P/42C/1F

4. **Sage & Salt** — Fusion, Friedrichshain, €€€
   - Miso Glazed Cod: 450 cal, 36P/28C/22F
   - Wagyu Tataki: 520 cal, 34P/12C/38F
   - Truffle Mushroom Risotto: 580 cal, 16P/68C/26F
   - Seared Duck Breast: 490 cal, 32P/24C/30F
   - Tuna Tartare: 320 cal, 28P/12C/18F
   - Roasted Cauliflower Steak: 380 cal, 12P/32C/24F
   - Lobster Linguine: 620 cal, 30P/58C/28F

### Task 1.8 — Mock Nutrition Tracking Service

**File:** `Alche/Core/MockServices/MockNutritionTrackingService.swift`

Follow `MockGlowScanService.swift` pattern:
- Conform to `NutritionTrackingServiceProtocol`
- Persist macro logs in `UserDefaults` keyed by `"alche.mock.macroLogs.\(userId)"`
- Persist macro goals in `UserDefaults` keyed by `"alche.mock.macroGoals.\(userId)"`
- Auto-create default MacroGoal on first access
- `dailySummary` computes from stored logs for the given date
- Simulate 0.2-0.5s delay for writes, instant for reads

### Acceptance Criteria — Terminal 1

- [x] All models compile with `Codable, Identifiable, Sendable, Hashable`
- [x] All CodingKeys use snake_case mapping
- [x] All preview extensions exist
- [x] Both service protocols are defined
- [x] Both mock services implement their protocols
- [x] Mock restaurant data includes 4 restaurants with 6-8 dishes each
- [x] Every dish has a complete NutritionalProfile
- [x] Macro logs persist across app sessions via UserDefaults
- [x] `xcodebuild` succeeds with 0 errors

---

## Terminal 2: Macro Tracking Core — ViewModel + Dashboard UI

**Goal:** Build the macro tracking engine and the daily macro dashboard view. This is the foundation that both restaurant logging and manual logging share.

**Depends on:** Terminal 1 (models + service protocols)

### Task 2.1 — MacroDashboardViewModel

**File:** `Alche/Features/Nutrition/MacroDashboardViewModel.swift`

Follow `HomeViewModel` / `ShopViewModel` pattern:

```swift
@Observable
@MainActor
final class MacroDashboardViewModel {
    // State
    var todaySummary: DailyMacroSummary?
    var todayLogs: [MacroLog] = []
    var macroGoal: MacroGoal?
    var isLoading = false
    var errorMessage: String?
    var selectedDate: Date = Date()

    // For manual entry
    var manualName = ""
    var manualCalories = ""
    var manualProtein = ""
    var manualCarbs = ""
    var manualFat = ""
    var manualMealType: MealType = .lunch
    var showManualEntry = false

    // Service (will be injected, for now instantiate mock)
    private let service: NutritionTrackingServiceProtocol = MockNutritionTrackingService()

    func loadToday() async { ... }
    func logRestaurantDish(_ dish: RestaurantDish, profile: NutritionalProfile, mealType: MealType, restaurantName: String) async { ... }
    func logManualEntry() async { ... }
    func deleteEntry(_ log: MacroLog) async { ... }
    func updateGoal(calories: Int, protein: Double, carbs: Double, fat: Double) async { ... }
}
```

### Task 2.2 — MacroDashboardView (Daily Summary)

**File:** `Alche/Features/Nutrition/MacroDashboardView.swift`

Layout (follows ProgressView pattern):

```
NavigationStack
├── ScrollView
│   ├── Date selector (horizontal day pills, today highlighted)
│   ├── Calorie ring (large, center)
│   │   └── "1,240 / 2,000 kcal"
│   ├── Macro progress bars (3 horizontal bars)
│   │   ├── Protein: ████████░░ 82g / 130g
│   │   ├── Carbs:   ██████░░░░ 145g / 220g
│   │   └── Fat:     ████░░░░░░ 38g / 65g
│   ├── "TODAY'S MEALS" overline
│   ├── ForEach(todayLogs) → MealLogRow
│   │   └── icon + name + restaurant + calories + time
│   ├── "+ Add Meal" button
│   └── DataSourceIndicator("Sample Data")
└── .sheet(showManualEntry) → MacroLogEntryView
```

Design tokens:
- Background: `Color.alcheBackground`
- Calorie ring: Terra fill on Sand track
- Protein bar: Sage
- Carbs bar: Amber
- Fat bar: Terra
- All fonts: Alche tokens
- Cards: `AlcheCard`

### Task 2.3 — MacroLogEntryView (Manual Entry Form)

**File:** `Alche/Features/Nutrition/MacroLogEntryView.swift`

Simple form for logging meals not from partner restaurants:

```
Sheet
├── "Log a Meal" heading
├── TextField: Meal name
├── MealType picker (breakfast/lunch/dinner/snack)
├── Number fields: Calories, Protein (g), Carbs (g), Fat (g)
├── "Log Meal" button (Terra, full width)
└── "Cancel" toolbar button
```

Follow the GDPRConsentView sheet pattern for layout.

### Task 2.4 — MacroProgressRing (Reusable Component)

**File:** `Alche/Design/Components/MacroProgressRing.swift`

A circular progress indicator showing calorie completion:

```swift
struct MacroProgressRing: View {
    let consumed: Int
    let goal: Int
    var ringColor: Color = .alcheTerra
    var trackColor: Color = .alcheSand

    // Renders:
    // - Circular arc (0-100%+)
    // - Center text: "consumed / goal" in alcheDisplayL
    // - "kcal" label below in alcheCaption
    // - Overshoot (>100%) shown in alcheError color
}
```

### Task 2.5 — MacroProgressBar (Reusable Component)

**File:** `Alche/Design/Components/MacroProgressBar.swift`

Horizontal progress bar for individual macros:

```swift
struct MacroProgressBar: View {
    let label: String      // "Protein"
    let current: Double    // grams consumed
    let goal: Double       // grams target
    var color: Color       // Sage for protein, Amber for carbs, Terra for fat
    var unit: String = "g"

    // Renders:
    // - Label + "current/goal unit" on same line
    // - Horizontal bar below (rounded capsule)
    // - Color changes to alcheError if > 100%
}
```

### Task 2.6 — MealLogRow (List Row Component)

**File:** `Alche/Features/Nutrition/MacroDashboardView.swift` (private struct)

```swift
private struct MealLogRow: View {
    let log: MacroLog

    // Renders:
    // HStack
    // ├── MealType icon (in circle, colored by meal type)
    // ├── VStack
    // │   ├── log.name (alcheBodyMedium)
    // │   └── log.restaurantName ?? log.mealType.displayName (alcheCaption, stone)
    // ├── Spacer
    // └── VStack(trailing)
    //     ├── "\(log.calories) kcal" (alcheBodyMedium)
    //     └── time formatted (alcheCaption, stone)
}
```

### Acceptance Criteria — Terminal 2

- [x] MacroDashboardViewModel loads, creates, and deletes macro logs
- [x] DailyMacroSummary computes correct totals
- [x] Calorie ring renders 0-100%+ states correctly
- [x] Three macro bars show protein/carbs/fat progress
- [x] Manual entry form validates and logs meals
- [x] Today's meals list shows logged entries with swipe-to-delete
- [x] DataSourceIndicator appears on dashboard
- [x] All views use Alche design tokens (no system fonts or static colors)
- [x] `xcodebuild` succeeds with 0 errors

---

## Terminal 3: Restaurant Discovery UI

**Goal:** Build the restaurant browsing experience — list, detail, menu, and dish views.

**Depends on:** Terminal 1 (models + mock services)

### Task 3.1 — RestaurantListViewModel

**File:** `Alche/Features/Restaurants/RestaurantListViewModel.swift`

```swift
@Observable
@MainActor
final class RestaurantListViewModel {
    var restaurants: [PartnerRestaurant] = []
    var selectedCuisine: CuisineType?
    var searchText = ""
    var isLoading = false
    var errorMessage: String?

    private let service: RestaurantServiceProtocol = MockRestaurantService()

    var filteredRestaurants: [PartnerRestaurant] {
        // Filter by cuisine, search by name/district, only active
    }

    func loadRestaurants() async { ... }
}
```

### Task 3.2 — RestaurantListView

**File:** `Alche/Features/Restaurants/RestaurantListView.swift`

Follow ShopView pattern:

```
ScrollView
├── Cuisine filter pills (horizontal scroll)
│   └── All | Mediterranean | Asian | Bowls | Vegan | ...
├── if loading → ProgressView
├── if empty → AlcheEmptyStateView("No partner restaurants in this area yet")
├── LazyVStack
│   └── ForEach(filteredRestaurants) → NavigationLink → RestaurantCard
└── DataSourceIndicator("Sample Data")
```

### Task 3.3 — RestaurantCard (List Item)

**File:** `Alche/Features/Restaurants/RestaurantListView.swift` (private struct)

```
HStack
├── Restaurant image placeholder (RoundedRect with cuisine-based gradient)
│   └── SF Symbol overlay (fork.knife, leaf, etc. by cuisine)
├── VStack(leading)
│   ├── name (alcheBodyMedium)
│   ├── cuisineType + district (alcheCaption, stone)
│   └── HStack: priceRange symbol + "Verified ✓" tag if isVerified
├── Spacer
└── chevron.right (alcheCaption, stone)
```

### Task 3.4 — RestaurantDetailViewModel

**File:** `Alche/Features/Restaurants/RestaurantDetailViewModel.swift`

```swift
@Observable
@MainActor
final class RestaurantDetailViewModel {
    let restaurant: PartnerRestaurant
    var dishes: [RestaurantDish] = []
    var nutritionalProfiles: [UUID: NutritionalProfile] = [:]
    var selectedCategory: DishCategory?
    var isLoading = false

    private let service: RestaurantServiceProtocol = MockRestaurantService()

    var filteredDishes: [RestaurantDish] { ... }
    var categories: [DishCategory] { /* unique from dishes */ }

    func loadMenu() async { ... }
    func nutritionalProfile(for dish: RestaurantDish) -> NutritionalProfile? { ... }
}
```

### Task 3.5 — RestaurantDetailView

**File:** `Alche/Features/Restaurants/RestaurantDetailView.swift`

```
ScrollView
├── Hero image placeholder (gradient by cuisine, 200pt)
├── VStack(leading)
│   ├── Restaurant name (displayL)
│   ├── cuisine + district + priceRange (alcheCaption)
│   ├── description (alcheBody, stone)
│   ├── "MENU" overline
│   ├── DishCategory filter pills (if >1 category)
│   ├── ForEach(filteredDishes) → NavigationLink → DishRow
│   │   └── name + description + calories badge + price + signature star
│   └── "Last analyzed: [date]" (alcheCaption, stone)
└── DataSourceIndicator
```

Background: `Color.alcheBackground`

### Task 3.6 — DishDetailView

**File:** `Alche/Features/Restaurants/DishDetailView.swift`

The macro breakdown screen. This is the centerpiece.

```
ScrollView
├── Dish name (displayL)
├── Restaurant name (alcheCaption, stone)
├── Price (alcheSubheading)
├── ── NUTRITION FACTS section ──
│   ├── Calorie ring (MacroProgressRing, large)
│   ├── Macro bars (3× MacroProgressBar)
│   │   └── Shows against user's remaining daily budget
│   ├── "alche verified" badge with analyzed date
│   └── Fiber display
├── ── INGREDIENTS section ──
│   └── Comma-separated ingredient list (alcheBody)
├── ── ALLERGENS section ──
│   └── AlcheTags for each allergen (Amber color)
├── ── MICRONUTRIENTS section ── (if available)
│   └── Key-value rows
├── Disclaimer text (system size 10, stone)
└── safeAreaInset(bottom):
    └── "Add to Today's Log" button (Terra, full width)
        └── Tapping → MealType picker sheet → logs meal → navigates to MacroDashboard
```

### Task 3.7 — "Log This Meal" Flow

When user taps "Add to Today's Log" on DishDetailView:

1. Show sheet with MealType picker (Breakfast/Lunch/Dinner/Snack)
2. On selection → call `MacroDashboardViewModel.logRestaurantDish(...)`
3. Dismiss sheet
4. Show confirmation toast or navigate to MacroDashboardView
5. The MacroLog entry includes: dish name, restaurant name, all macros, dishVersion, dishId

This requires a shared or passed reference to `MacroDashboardViewModel`. Options:
- Pass as parameter through NavigationLink chain
- Use `@Environment` injection
- **Recommended:** Instantiate a lightweight logging helper that calls the NutritionTrackingService directly

### Acceptance Criteria — Terminal 3

- [x] Restaurant list displays 4 mock restaurants with cuisine filter
- [x] Search filters by name and district
- [x] Restaurant detail shows full menu grouped by category
- [x] Each dish row shows calorie count badge
- [x] Dish detail shows full macro breakdown with progress rings/bars
- [x] Dish detail shows macros against user's remaining daily budget (not hardcoded goals)
- [x] Allergens display as colored tags
- [x] "Add to Today's Log" creates a MacroLog entry with consistent userId
- [x] Meal type selection works (breakfast/lunch/dinner/snack)
- [x] Daily budget refreshes after logging a meal
- [x] DataSourceIndicator on all screens
- [x] All views use Alche design tokens (Color.alchePrimaryText, not Color.alcheDeep)
- [x] Error states handled on both list and detail views
- [x] `xcodebuild` succeeds with 0 errors

---

## Terminal 4: Integration — Navigation, Home Card, Discover Tab

**Goal:** Wire the restaurant and nutrition features into the existing app navigation.

**Depends on:** Terminal 1 + Terminal 2 + Terminal 3

### Task 4.1 — Add "Eat Out" Section to DiscoverView

**File:** `Alche/Features/Discover/DiscoverView.swift`

Modify the `DiscoverViewModel.DiscoverSection` enum to add `.eatOut`:

```swift
enum DiscoverSection: String, CaseIterable {
    case content = "Content"
    case events = "Events"
    case eatOut = "Eat Out"    // NEW
    case saved = "Saved"
}
```

Add a new section body in the `switch`:

```swift
case .eatOut:
    eatOutSection
```

The `eatOutSection` is a `NavigationLink` to `RestaurantListView()` or can embed the restaurant list directly. **Recommended:** Embed directly for consistency with other sections (Content and Events render inline, not as separate screens).

But since RestaurantListView already has its own filters and is substantial, use a NavigationLink card:

```swift
private var eatOutSection: some View {
    VStack(spacing: AlcheSpacing.md) {
        // Intro card
        AlcheCard(shadow: .medium) {
            VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                HStack {
                    Text("Partner Restaurants")
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alcheDeep)
                    Spacer()
                    AlcheTag(text: "Verified", color: .alcheSage, isSelected: true)
                }
                Text("Independently analyzed nutrition data for every dish. No guesswork.")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheStone)
            }
        }

        // Restaurant preview cards → tap navigates to RestaurantListView
        NavigationLink {
            RestaurantListView()
        } label: {
            // "Browse all X restaurants →"
        }
    }
    .padding(.horizontal, AlcheSpacing.lg)
}
```

**Also modify:** `Alche/Features/Discover/DiscoverViewModel.swift` to add the new section case.

### Task 4.2 — Add Macro Summary Card to HomeView

**File:** `Alche/Features/Home/HomeView.swift`

Add a new card between "Quick Actions" and "Daily Protocol" sections:

```swift
// Macro summary (after quick actions, before daily protocol)
if let summary = viewModel.macroSummary {
    NavigationLink {
        MacroDashboardView()
    } label: {
        AlcheCard {
            VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                Text("TODAY'S NUTRITION")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheStone)
                    .tracking(0.8)

                HStack {
                    VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                        Text("\(summary.totalCalories) kcal")
                            .font(.alcheSubheading)
                            .foregroundStyle(Color.alcheDeep)
                        Text("\(summary.entryCount) meal\(summary.entryCount == 1 ? "" : "s") logged")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheStone)
                    }

                    Spacer()

                    // Mini macro indicators
                    HStack(spacing: AlcheSpacing.sm) {
                        MiniMacroDot(label: "P", value: summary.totalProtein, color: .alcheSage)
                        MiniMacroDot(label: "C", value: summary.totalCarbs, color: .alcheAmber)
                        MiniMacroDot(label: "F", value: summary.totalFat, color: .alcheTerra)
                    }
                }
            }
        }
    }
    .buttonStyle(.plain)
    .padding(.horizontal, AlcheSpacing.lg)
}
```

**Also modify:** `Alche/Features/Home/HomeViewModel.swift` to add:
- `var macroSummary: DailyMacroSummary?`
- Load today's summary in `loadDashboard()`

### Task 4.3 — Add "Eat Smart" to Quick Actions

**File:** `Alche/Features/Home/QuickActionGrid.swift`

Add a new quick action tile that navigates to the restaurant list or macro dashboard.

Examine the existing QuickActionGrid to understand the pattern, then add:

```swift
QuickActionTile(
    icon: "fork.knife",
    title: "Eat Smart",
    subtitle: "Partner menus",
    action: onEatSmart    // New callback
)
```

Wire the callback through HomeView to navigate to RestaurantListView.

### Task 4.4 — Navigation from Macro Dashboard to Restaurant List

Ensure the MacroDashboardView has a toolbar button or prominent link to browse restaurants:

```swift
.toolbar {
    ToolbarItem(placement: .topBarTrailing) {
        NavigationLink {
            RestaurantListView()
        } label: {
            Image(systemName: "fork.knife")
                .foregroundStyle(Color.alcheTerra)
        }
    }
}
```

### Acceptance Criteria — Terminal 4

- [x] Discover tab shows "Eat Out" as a new segment
- [x] Tapping into Eat Out shows restaurant browsing
- [x] Home tab shows macro summary card when meals are logged
- [x] Home card taps through to MacroDashboardView
- [x] Quick action "Eat Smart" navigates to RestaurantListView
- [x] Macro dashboard links to restaurants via toolbar
- [x] All navigation flows feel cohesive — no dead ends
- [x] Back buttons work correctly (NavigationStack)
- [x] `xcodebuild` succeeds with 0 errors after all integration

---

## File Summary

### New Files (by terminal)

**Terminal 1 — Data Layer (8 files)**
```
Alche/Core/Models/PartnerRestaurant.swift          (enums + model + previews)
Alche/Core/Models/RestaurantDish.swift              (enums + dish + nutritional profile + previews)
Alche/Core/Models/MacroLog.swift                    (enums + log + goal + summary)
Alche/Core/Services/RestaurantServiceProtocol.swift
Alche/Core/Services/NutritionTrackingServiceProtocol.swift
Alche/Core/MockServices/MockRestaurantService.swift
Alche/Core/MockServices/MockNutritionTrackingService.swift
```

**Terminal 2 — Macro Tracking (4 files)**
```
Alche/Features/Nutrition/MacroDashboardViewModel.swift
Alche/Features/Nutrition/MacroDashboardView.swift       (includes MealLogRow)
Alche/Features/Nutrition/MacroLogEntryView.swift
Alche/Design/Components/MacroProgressRing.swift
Alche/Design/Components/MacroProgressBar.swift
```

**Terminal 3 — Restaurant UI (5 files)**
```
Alche/Features/Restaurants/RestaurantListViewModel.swift
Alche/Features/Restaurants/RestaurantListView.swift     (includes RestaurantCard)
Alche/Features/Restaurants/RestaurantDetailViewModel.swift
Alche/Features/Restaurants/RestaurantDetailView.swift   (includes DishRow)
Alche/Features/Restaurants/DishDetailView.swift
```

**Terminal 4 — Integration (0 new files, 4-5 modified files)**
```
MODIFY Alche/Features/Discover/DiscoverView.swift
MODIFY Alche/Features/Discover/DiscoverViewModel.swift
MODIFY Alche/Features/Home/HomeView.swift
MODIFY Alche/Features/Home/HomeViewModel.swift
MODIFY Alche/Features/Home/QuickActionGrid.swift
```

### Total: ~17 new files + 5 modified files

---

## Execution Order

```
Week 1:  Terminal 1 + Terminal 2 (parallel)
Week 2:  Terminal 3 + Terminal 4 (parallel, after 1+2 complete)
         Final integration test + xcodebuild verification
```

---

*Reference: specs/REQ-025-eat-smart-outside/prd.md for full product context.*
