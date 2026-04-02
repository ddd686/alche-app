# PRD: Eat Smart Outside (Partner Restaurant Menu Analysis)

**Feature ID:** REQ-025
**Author:** Product Manager
**Status:** Draft
**Priority:** P1 — Pre-Phase 3
**Target:** Phase 2.5 (before polish pass)

---

## 1. Problem Statement

alche users track their wellness protocols, log daily check-ins (energy, sleep, mood), and follow curated nutrition guidance through smoothies and supplements. But the moment they eat outside the home, all nutritional awareness disappears. They're guessing macros, trusting restaurant-provided numbers (which are often wrong), or simply not tracking at all.

This gap undermines the entire longevity operating system thesis. If alche only works inside the alche space, it's not a lifestyle platform — it's a venue app.

## 2. Solution

Partner with local Berlin restaurants. Physically acquire their dishes. Run independent nutritional analysis. Surface verified macro data in-app. Let users log restaurant meals with the same confidence as alche smoothies.

**What makes this different from MyFitnessPal:** alche independently verifies every dish. No crowdsourced data. No restaurant marketing numbers. The analysis is done by the alche team and verified by practitioners. Trust is the product.

## 3. User Stories

| ID | As a... | I want to... | So that... |
|----|---------|-------------|-----------|
| US-1 | alche member | browse partner restaurants near me | I can find trusted dining options |
| US-2 | alche member | see verified macro breakdowns for each dish | I know exactly what I'm eating |
| US-3 | alche member | log a restaurant meal in one tap | it counts toward my daily tracking without manual entry |
| US-4 | alche member | see my daily macro progress after logging | I know how much budget I have left |
| US-5 | alche member | get dish recommendations based on my remaining macros | I can eat out without derailing my goals |
| US-6 | alche member | see allergen info for every dish | I can avoid ingredients I'm sensitive to |

## 4. Feature Scope

### 4.1 In Scope (MVP)

1. **Partner Restaurant List** — scrollable list with restaurant cards, category filters, distance indicator (text-based, not map)
2. **Restaurant Detail** — hero image, description, full menu with nutrition overlays
3. **Menu Item Detail** — full macro breakdown (cal/protein/carbs/fat/fiber), ingredient list, allergens, micronutrient highlights
4. **Macro Tracking Core** — daily macro log, daily summary with progress bars, history
5. **One-Tap Logging** — "Add to today's log" from any menu item detail
6. **Daily Macro Dashboard** — card on Home tab showing today's calories and macro split
7. **Mock Data Layer** — 4 partner restaurants, 6-8 menu items each, all with full nutritional profiles
8. **DataSourceIndicator** — "Sample Data" badge on all mock screens (per CLAUDE.md convention)

### 4.2 Out of Scope (Later Phases)

- Map view with MapKit (requires location permissions — separate feature)
- AI-powered dish recommendations based on remaining macro budget
- Real restaurant partner onboarding / CMS admin tooling
- Barcode scanning or photo-based meal logging
- Integration with wearable data for calorie burn offset
- Social features (sharing meals, restaurant reviews)

## 5. Data Model

### New Models

```
PartnerRestaurant
├── id: UUID
├── name: String
├── description: String?
├── cuisineType: CuisineType (enum)
├── address: String
├── district: String (Berlin district for filtering)
├── latitude: Double?
├── longitude: Double?
├── partnershipStatus: PartnershipStatus (enum: active/pending/paused)
├── logoURL: String?
├── imageURL: String?
├── priceRange: PriceRange (enum: €/€€/€€€)
├── isVerified: Bool (alche has completed analysis)
├── menuLastUpdated: Date
├── sortOrder: Int
├── createdAt: Date
└── CodingKeys (snake_case for Supabase)

RestaurantDish
├── id: UUID
├── restaurantId: UUID
├── name: String
├── description: String?
├── category: DishCategory (enum: starter/main/side/dessert/drink)
├── priceCents: Int
├── imageURL: String?
├── available: Bool
├── isSignatureDish: Bool
├── sortOrder: Int
├── version: Int (for menu changes — historical logs reference version)
├── lastAnalyzedAt: Date
├── createdAt: Date
└── CodingKeys (snake_case)

NutritionalProfile
├── id: UUID
├── dishId: UUID
├── calories: Int
├── proteinGrams: Double
├── carbsGrams: Double
├── fatGrams: Double
├── fiberGrams: Double
├── ingredients: [String]
├── allergens: [Allergen] (enum: gluten/dairy/nuts/soy/eggs/shellfish/sesame)
├── micronutrients: [String: String]? (e.g., "Vitamin D": "15% DV")
├── analysisMethod: String ("alche independent analysis")
├── analyzedAt: Date
└── CodingKeys (snake_case)

MacroLog
├── id: UUID
├── userId: UUID
├── date: Date
├── entryType: MacroLogEntryType (enum: restaurantDish/manual/smoothie)
├── dishId: UUID? (links to RestaurantDish when entryType == .restaurantDish)
├── menuItemId: UUID? (links to MenuItem when entryType == .smoothie)
├── name: String (denormalized for history display)
├── calories: Int
├── proteinGrams: Double
├── carbsGrams: Double
├── fatGrams: Double
├── fiberGrams: Double
├── mealType: MealType (enum: breakfast/lunch/dinner/snack)
├── restaurantName: String? (denormalized)
├── dishVersion: Int? (snapshot of dish version at time of logging)
├── loggedAt: Date
└── CodingKeys (snake_case)

MacroGoal
├── id: UUID
├── userId: UUID
├── dailyCalories: Int
├── dailyProteinGrams: Double
├── dailyCarbsGrams: Double
├── dailyFatGrams: Double
├── isActive: Bool
├── createdAt: Date
└── CodingKeys (snake_case)
```

### New Enums

```
CuisineType: String, Codable, Sendable, CaseIterable
  mediterranean, asian, german, fusion, vegan, raw, bowls

DishCategory: String, Codable, Sendable, CaseIterable
  starter, main, side, dessert, drink

PriceRange: String, Codable, Sendable
  budget ("€"), moderate ("€€"), premium ("€€€")

PartnershipStatus: String, Codable, Sendable
  active, pending, paused

Allergen: String, Codable, Sendable, CaseIterable
  gluten, dairy, nuts, soy, eggs, shellfish, sesame

MacroLogEntryType: String, Codable, Sendable
  restaurantDish, manual, smoothie

MealType: String, Codable, Sendable, CaseIterable
  breakfast, lunch, dinner, snack
```

## 6. Service Layer

### RestaurantServiceProtocol

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

### NutritionTrackingServiceProtocol

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

### DailyMacroSummary (Computed, not persisted)

```
DailyMacroSummary
├── date: Date
├── totalCalories: Int
├── totalProtein: Double
├── totalCarbs: Double
├── totalFat: Double
├── totalFiber: Double
├── entryCount: Int
├── goal: MacroGoal?
└── computed: caloriesRemaining, proteinRemaining, etc.
```

## 7. Screen Inventory

| Screen | Location | Description |
|--------|----------|-------------|
| `RestaurantListView` | Features/Restaurants/ | Partner restaurant list with cuisine filters, search |
| `RestaurantDetailView` | Features/Restaurants/ | Restaurant info + full menu with nutrition badges |
| `DishDetailView` | Features/Restaurants/ | Full macro/ingredient/allergen breakdown + "Log this meal" |
| `MacroDashboardView` | Features/Nutrition/ | Daily macro summary, progress rings, meal log history |
| `MacroLogEntryView` | Features/Nutrition/ | Manual macro entry form (for non-restaurant meals) |
| `HomeMacroCard` | Features/Home/ (inline) | Compact card in HomeView showing today's calorie/macro status |

## 8. Navigation Integration

**Option chosen:** Add "Eat Out" section to the Discover tab's segmented picker.

Current Discover sections: `Content | Events | Saved`
New: `Content | Events | Eat Out | Saved`

The Macro Dashboard is accessible from:
1. A card on the Home tab (tap to expand)
2. The Profile tab (under wellness tracking)
3. After logging a meal (auto-navigate to daily summary)

## 9. Mock Data Specification

### 4 Partner Restaurants

1. **Green Bowl Berlin** — Bowls, Mitte, €€, 7 dishes
2. **Nouri Kitchen** — Mediterranean, Kreuzberg, €€, 8 dishes
3. **The Raw Bar** — Raw/Vegan, Prenzlauer Berg, €, 6 dishes
4. **Sage & Salt** — Fusion, Friedrichshain, €€€, 7 dishes

### Mock Nutritional Profiles

Each dish gets realistic macros. Examples:

| Restaurant | Dish | Cal | Protein | Carbs | Fat |
|-----------|------|-----|---------|-------|-----|
| Green Bowl | Salmon Poke Bowl | 520 | 38g | 48g | 18g |
| Green Bowl | Mediterranean Grain Bowl | 480 | 22g | 62g | 14g |
| Nouri Kitchen | Grilled Chicken Plate | 580 | 42g | 35g | 26g |
| Nouri Kitchen | Lamb Kofta Wrap | 640 | 32g | 52g | 34g |
| The Raw Bar | Raw Pad Thai | 380 | 12g | 42g | 20g |
| Sage & Salt | Miso Glazed Cod | 450 | 36g | 28g | 22g |

### Default Macro Goal (seeded on first use)

- 2,000 kcal / 130g protein / 220g carbs / 65g fat
- Adjustable in settings

## 10. Alche Design Language Compliance

- All backgrounds: `Color.alcheBackground` / `Color.alcheSurface` (adaptive dark mode)
- All typography: Alche tokens only (`.alcheBody`, `.alcheCaption`, `.alcheSubheading`, etc.)
- Cards: `AlcheCard(shadow:)` component
- Tags: `AlcheTag` for cuisine type, allergens, dietary labels
- Color coding: Terra for primary actions, Sage for positive/healthy, Amber for warnings/allergens
- Empty states: `AlcheEmptyStateView` component (per DiscoverView pattern)
- Mock data: `DataSourceIndicator("Sample Data")` on all screens
- Progress bars: Terra fill on Sand track (matching existing booking slot capacity pattern)

## 11. Health Language Compliance

Per CLAUDE.md: "supports", "helps", "wellness" only. Never "treats", "cures", "heals".

- "Supports your daily protein target" (not "ensures you hit your protein requirement")
- "Helps you make informed choices when eating out" (not "tells you what to eat")
- Nutritional data is informational, not medical advice
- Add disclaimer: "Nutritional values are approximate and based on standard preparation methods."

## 12. Supabase Schema (for future wiring)

```sql
-- partner_restaurants
CREATE TABLE partner_restaurants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  cuisine_type TEXT NOT NULL,
  address TEXT NOT NULL,
  district TEXT NOT NULL,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  partnership_status TEXT NOT NULL DEFAULT 'active',
  logo_url TEXT,
  image_url TEXT,
  price_range TEXT NOT NULL,
  is_verified BOOLEAN NOT NULL DEFAULT false,
  menu_last_updated TIMESTAMPTZ,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- restaurant_dishes
CREATE TABLE restaurant_dishes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id UUID NOT NULL REFERENCES partner_restaurants(id),
  name TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  price_cents INTEGER NOT NULL,
  image_url TEXT,
  available BOOLEAN NOT NULL DEFAULT true,
  is_signature_dish BOOLEAN NOT NULL DEFAULT false,
  sort_order INTEGER NOT NULL DEFAULT 0,
  version INTEGER NOT NULL DEFAULT 1,
  last_analyzed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- nutritional_profiles
CREATE TABLE nutritional_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dish_id UUID NOT NULL REFERENCES restaurant_dishes(id),
  calories INTEGER NOT NULL,
  protein_grams DOUBLE PRECISION NOT NULL,
  carbs_grams DOUBLE PRECISION NOT NULL,
  fat_grams DOUBLE PRECISION NOT NULL,
  fiber_grams DOUBLE PRECISION NOT NULL,
  ingredients TEXT[] NOT NULL DEFAULT '{}',
  allergens TEXT[] NOT NULL DEFAULT '{}',
  micronutrients JSONB,
  analysis_method TEXT NOT NULL DEFAULT 'alche independent analysis',
  analyzed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- macro_logs (RLS: user can only see own logs)
CREATE TABLE macro_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  date DATE NOT NULL,
  entry_type TEXT NOT NULL,
  dish_id UUID REFERENCES restaurant_dishes(id),
  menu_item_id UUID,
  name TEXT NOT NULL,
  calories INTEGER NOT NULL,
  protein_grams DOUBLE PRECISION NOT NULL,
  carbs_grams DOUBLE PRECISION NOT NULL,
  fat_grams DOUBLE PRECISION NOT NULL,
  fiber_grams DOUBLE PRECISION NOT NULL,
  meal_type TEXT NOT NULL,
  restaurant_name TEXT,
  dish_version INTEGER,
  logged_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- macro_goals (RLS: user can only see own goals)
CREATE TABLE macro_goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  daily_calories INTEGER NOT NULL DEFAULT 2000,
  daily_protein_grams DOUBLE PRECISION NOT NULL DEFAULT 130,
  daily_carbs_grams DOUBLE PRECISION NOT NULL DEFAULT 220,
  daily_fat_grams DOUBLE PRECISION NOT NULL DEFAULT 65,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- RLS policies
ALTER TABLE macro_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE macro_goals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users see own macro logs" ON macro_logs
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users see own macro goals" ON macro_goals
  FOR ALL USING (auth.uid() = user_id);
```

## 13. Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Restaurant discovery engagement | >40% of active users browse restaurants weekly | Analytics event on RestaurantListView appear |
| Meal logging rate | >3 restaurant meals logged per active user per week | MacroLog entries with type == .restaurantDish |
| Macro dashboard retention | >60% of users who log 1 meal return within 7 days | Cohort analysis on MacroDashboardView |
| Feature validation | Qualitative: users mention restaurant tracking in feedback | User interviews, app store reviews |

## 14. Open Questions

1. **Tier gating:** Should restaurant browsing be free (acquisition) with logging gated to Core+ tier? **Recommendation:** Browsing free, logging requires Core+. This creates upgrade motivation.
2. **Smoothie integration:** Should existing smoothie orders auto-log to macro tracker? **Recommendation:** Yes, in a follow-up PR. Use `entryType: .smoothie` with existing `MenuItem.nutritionalInfo`.
3. **Goal onboarding:** When should we prompt users to set macro goals? **Recommendation:** After first restaurant meal log, show a one-time goal setup sheet.

---

*This document is the source of truth for the Eat Smart Outside feature. All implementation should reference this PRD.*
