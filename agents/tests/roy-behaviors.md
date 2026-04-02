# Roy (Swift Dev) — Behavior Tests

> Run these scenarios after every character sheet edit, memory change, or REM Sleep consolidation.
> Roy must handle each scenario correctly. If behavior drifts, update the character sheet or core memories.

---

## Scenario 1: The Optional Booking Slot

**Setup:** Roy is implementing `BookingViewModel.confirmBooking()`. The selected `TimeSlot` is an optional property because the user might navigate to the confirmation screen before selecting a slot (deep link edge case).

**Input prompt:** "Implement `confirmBooking()` that sends the selected time slot to the booking service."

**Expected behavior:**
- Roy wraps the slot access in `guard let selectedSlot = selectedSlot else { ... }` — never force-unwraps
- The guard clause sets an appropriate `errorMessage` ("Please select a time slot")
- Roy writes a unit test for the nil-slot path BEFORE implementing the method
- The test is named descriptively: `testConfirmBooking_FailsWhenNoSlotSelected`

**Red flag if Roy:**
- Force-unwraps `selectedSlot!`
- Skips the nil path test
- Uses optional chaining that silently does nothing on nil (`selectedSlot?.id` in a context where missing data should error)

---

## Scenario 2: The Codable Model With Supabase

**Setup:** Roy needs to create a `DoctorSession` model for REQ-026. Supabase returns JSON with snake_case keys: `session_date`, `practitioner_id`, `is_complimentary`.

**Input prompt:** "Create the DoctorSession model for the doctor session booking feature."

**Expected behavior:**
- Model conforms to `Codable, Identifiable, Sendable, Hashable`
- `CodingKeys` enum maps every property: `case sessionDate = "session_date"`, etc.
- Includes `static let preview` with realistic sample data
- Includes `static let allPreviews` with at least 3 varied samples
- Date properties are `Date` type, not `String`
- `isComplimentary` is `Bool`, derived from membership tier logic

**Red flag if Roy:**
- Omits `CodingKeys` (relying on automatic camelCase, which won't match Supabase snake_case)
- Uses `String` for dates
- Forgets `Sendable` or `Hashable` conformance
- Omits preview extensions

---

## Scenario 3: The Mock Service With Realistic Behavior

**Setup:** Roy is implementing `MockNutritionTrackingService` for REQ-025. The service needs to track daily macro intake (protein, carbs, fats, calories).

**Input prompt:** "Build the mock nutrition tracking service that lets users log meals and view daily macro totals."

**Expected behavior:**
- Implements `NutritionTrackingServiceProtocol`
- Every async method includes `try await Task.sleep(for: .milliseconds(Int.random(in: 300...800)))` to simulate network latency
- Data persists in UserDefaults so macro logs survive app restarts
- Returns realistic data volumes (not just 1-2 entries, but enough to scroll)
- Handles the edge case of logging a meal when no daily record exists yet (creates one)
- `logMeal()` method validates that macro values are non-negative

**Red flag if Roy:**
- Returns data instantly with no simulated delay
- Stores data only in memory (lost on app restart)
- Returns trivially small datasets (1 item)
- Allows negative calorie values without validation

---

## Scenario 4: The ViewModel Threading Contract

**Setup:** Roy is building `RestaurantListViewModel` for REQ-025. It fetches restaurant data from the mock service and updates the view state.

**Input prompt:** "Implement the RestaurantListViewModel that loads and filters partner restaurants."

**Expected behavior:**
- Class is annotated `@Observable @MainActor final class RestaurantListViewModel`
- `isLoading`, `restaurants`, `errorMessage` are all published properties
- `loadRestaurants()` is `async` and sets `isLoading = true` before the fetch, `isLoading = false` in a defer block
- Error handling uses `do/catch`, sets `errorMessage` on failure
- Service is injected via protocol, not instantiated directly with concrete type... wait, Alche pattern uses `private let service: XxxServiceProtocol = MockXxxService()`. Roy follows this pattern.
- Filtering logic (by cuisine type, dietary preference) lives in the ViewModel, not the View

**Red flag if Roy:**
- Omits `@MainActor`
- Omits `@Observable` (uses `ObservableObject` instead)
- Puts filtering logic in the View's body
- Doesn't handle the error case (no `errorMessage` assignment in catch)
- Uses `try?` silently swallowing errors

---

## Scenario 5: The GDPR-Sensitive Health Data

**Setup:** Roy is implementing `MacroLogService` which stores the user's daily nutrition intake — classified as health data under GDPR.

**Input prompt:** "Implement the service that stores and retrieves the user's daily macro logs."

**Expected behavior:**
- The model includes a `consentGranted: Bool` field or the service checks consent before storing
- The service method for saving data includes a consent check: if no consent, return an error, not silent failure
- Data deletion method exists (`deleteAllMacroLogs()`) for GDPR right-to-erasure compliance
- No health data is sent to analytics (TelemetryDeck gets event counts, not health values)
- Unit test verifies that saving without consent throws an error

**Red flag if Roy:**
- Stores health data without any consent mechanism
- No data deletion method
- Logs actual health values to analytics
- Consent check is a comment ("// TODO: check consent") rather than implemented logic
