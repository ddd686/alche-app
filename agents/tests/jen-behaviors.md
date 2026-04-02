# Jen (UI Dev) — Behavior Tests

> Run these scenarios after every character sheet edit, memory change, or REM Sleep consolidation.
> Jen must handle each scenario correctly. If behavior drifts, update the character sheet or core memories.

---

## Scenario 1: The New Feature View With Missing States

**Setup:** Jen is building `RestaurantListView` for REQ-025. The ViewModel has `isLoading`, `restaurants`, and `errorMessage` properties.

**Input prompt:** "Build the restaurant list view showing partner restaurants with their cuisine type and nutrition badge."

**Expected behavior:**
- View handles all 3 states: loading (ProgressView or skeleton), content (restaurant list), error (error message + retry button)
- Empty state uses `AlcheEmptyStateView` with a relevant message ("No partner restaurants yet")
- Mock data screens show `DataSourceIndicator("Sample Data")`
- All colors use Alche tokens: `Color.alcheBackground` for page bg, `Color.alcheSurface` for cards
- All fonts use Alche tokens: `.font(.alcheBody)` for body text, `.font(.alcheCaption)` for secondary, `.font(.alcheSubheading)` for restaurant names
- Restaurant cards use `AlcheCard` component
- No business logic in the View — filtering triggers are passed to the ViewModel

**Red flag if Jen:**
- Only implements the content state (no loading, no error, no empty)
- Uses `Color.white` or `Color(.systemBackground)` instead of `Color.alcheBackground`
- Uses `.font(.body)` or `.font(.headline)` instead of Alche typography tokens
- Puts filtering logic in the View body instead of calling ViewModel methods
- Forgets `DataSourceIndicator` on a mock-data screen

---

## Scenario 2: The Dark Mode Verification

**Setup:** Jen is reskinning the `BookingListView` during Phase 3 (Editorial Longevity design system).

**Input prompt:** "Update the booking list to use the new Editorial Longevity design tokens."

**Expected behavior:**
- All background colors use semantic tokens that adapt: `Color.alcheBackground`, `Color.alcheSurface`
- No static color values anywhere: no `Color(hex: "#...")`, no `Color.cream`, no `Color.linen`
- Text colors use semantic tokens: `Color.alchePrimary` for headings, `Color.alcheMuted` for secondary
- The SwiftUI Preview includes both `.preferredColorScheme(.light)` and `.preferredColorScheme(.dark)` variants
- Sharp corners (2px max radius) replace any rounded corners from the old design
- Hard borders (1px solid) replace soft shadows

**Red flag if Jen:**
- Uses any static/literal color value
- Only provides a light mode preview
- Keeps rounded corners (>2px radius) from the old design system
- Keeps soft shadows from the old design system
- Uses `Color.primary` (SwiftUI system) instead of `Color.alchePrimary` (Alche token)

---

## Scenario 3: The Form With Keyboard Handling

**Setup:** Jen is building the `DoctorSessionBookingView` for REQ-026. The form includes text fields for notes, a date picker, and a practitioner selector.

**Input prompt:** "Build the doctor session booking form with practitioner selection, date/time, session type, and notes."

**Expected behavior:**
- Form is wrapped in a `ScrollView` to handle keyboard avoidance
- `.scrollDismissesKeyboard(.interactively)` is applied
- Text fields use Alche styling (`.font(.alcheBody)`, border styling from tokens)
- The notes field is a `TextEditor` with a character limit, not an unbounded input
- Submit button uses `AlcheButton`
- The wellness disclaimer is visible: "Sessions are for wellness guidance and lifestyle optimization. They do not constitute medical advice, diagnosis, or treatment."
- VoiceOver labels on all interactive elements

**Red flag if Jen:**
- No ScrollView wrapping (keyboard will cover bottom fields)
- No keyboard dismissal behavior
- Missing the wellness disclaimer
- Submit button is a plain `Button` instead of `AlcheButton`
- No VoiceOver labels on the date picker or practitioner selector

---

## Scenario 4: The Component Preview Catalog

**Setup:** Jen is updating `AlcheCard` for the Editorial Longevity reskin during Phase 3.

**Input prompt:** "Reskin AlcheCard for the Editorial Longevity design system: sharp corners, hard borders, no shadows."

**Expected behavior:**
- Card uses 2px corner radius max (was previously rounded)
- Border is 1px solid using `Color.alcheBorder` (not a shadow)
- All drop shadows removed — no `.shadow()` modifier
- Background uses `Color.alcheSurface` (adaptive)
- Preview shows all variants: default content, compact, expanded, with image, without image
- Preview shows both light and dark mode
- Preview shows Dynamic Type at `.large` and `.accessibility3`
- The component uses `AlcheSpacing` tokens for internal padding, not hardcoded values

**Red flag if Jen:**
- Keeps corner radius >2px
- Keeps shadow modifiers
- Only shows one preview variant
- No dark mode preview
- No Dynamic Type preview
- Hardcodes padding values instead of using `AlcheSpacing` tokens

---

## Scenario 5: The Nutrition Disclaimer Screen

**Setup:** Jen is building `DishDetailView` for REQ-025, showing a restaurant dish's estimated nutritional breakdown.

**Input prompt:** "Build the dish detail view showing macro breakdown, ingredients, and nutritional analysis for a partner restaurant dish."

**Expected behavior:**
- Macro values displayed using Alche typography: numbers in `.font(.alcheDisplayL)` or similar display weight, labels in `.font(.alcheCaption)`
- Monospace font (`.font(.alcheMono)`) used for precise numerical values (grams, calories)
- Nutrition disclaimer is visible and not dismissible: "Nutritional data is independently estimated by Alche and may differ from restaurant-provided values."
- `DataSourceIndicator("Sample Data")` present since this is mock-phase
- Empty state handled: if dish has no nutritional data yet, show `AlcheEmptyStateView`
- Dark mode: all colors adaptive, no static hex values
- The view does NOT present data as medical nutrition advice — language is informational ("estimated", "approximately")

**Red flag if Jen:**
- Omits the nutrition disclaimer
- Uses system fonts for macro numbers (should be Alche display or mono tokens)
- Uses clinical language ("your required intake", "nutritional deficiency")
- Forgets `DataSourceIndicator` on a mock-data screen
- Hardcodes any color values
