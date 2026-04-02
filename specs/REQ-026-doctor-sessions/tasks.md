# Doctor Session Booking — Task Breakdown by Terminal

**Feature ID:** REQ-026
**Reference:** `specs/REQ-026-doctor-sessions/prd.md`
**Architecture:** Follow existing patterns in `Alche/Core/Models/`, `Alche/Core/Services/`, `Alche/Core/MockServices/`, `Alche/Features/`

---

## Dependency Graph

```
Terminal A (Data Layer) ─────────┐
                                 ├──> Terminal C (Doctor Session UI)
Terminal B (Booking Engine) ─────┤
                                 └──> Terminal D (Integration)
```

Terminals A and B can run in parallel.
Terminals C and D depend on A + B completing first.
Terminal C and D can then run in parallel.

---

## Terminal A: Data Layer — Models, Enums, Service Protocol

**Goal:** Create all new data types and the service contract. No UI.

### Task A.1 — Practitioner Enums

**File:** `Alche/Core/Models/Practitioner.swift` (top of file)

```swift
enum PractitionerSpecialty: String, Codable, Sendable, CaseIterable {
    case longevityWellness, nutritionalGuidance, sleepOptimization,
         stressManagement, movementRecovery, skinWellness
    // var displayName: String
    // var icon: String (SF Symbol)
}

enum SessionStatus: String, Codable, Sendable {
    case confirmed, completed, cancelledByMember, cancelledByPractitioner, noShow
    // var displayName: String
    // var color: Color (sage/terra/amber/error/stone)
}
```

### Task A.2 — Practitioner Model

**File:** `Alche/Core/Models/Practitioner.swift`

Follow `Event.swift` pattern (Codable, Identifiable, Sendable, Hashable + CodingKeys):

```swift
struct Practitioner: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    var name: String
    var title: String
    var bio: String
    var photoURL: String?
    var specialties: [PractitionerSpecialty]
    var languages: [String]
    var rating: Double?
    var reviewCount: Int
    var isActive: Bool
    var sortOrder: Int
    let createdAt: Date

    enum CodingKeys: String, CodingKey { /* snake_case */ }

    // Computed: var formattedRating: String
    // Computed: var primarySpecialty: PractitionerSpecialty
}

// Preview extensions with 4 practitioners (see PRD Section 9)
```

### Task A.3 — SessionType Model

**File:** `Alche/Core/Models/Practitioner.swift` (below Practitioner)

```swift
struct SessionType: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let practitionerId: UUID
    var name: String
    var durationMinutes: Int
    var priceCents: Int
    var description: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey { /* snake_case */ }

    // Computed: var formattedPrice: String
    // Computed: var formattedDuration: String ("30 min" / "60 min")
    // Computed: var isComplimentaryEligible: Bool { priceCents > 0 }
}
```

### Task A.4 — PractitionerAvailability Model

**File:** `Alche/Core/Models/PractitionerAvailability.swift`

```swift
struct PractitionerAvailability: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let practitionerId: UUID
    var date: Date
    var startTime: Date
    var endTime: Date
    var isBooked: Bool
    var sessionTypeId: UUID?
    let createdAt: Date

    enum CodingKeys: String, CodingKey { /* snake_case */ }

    // Computed: var formattedTimeRange: String ("09:00 - 10:00")
    // Computed: var isAvailable: Bool { !isBooked }
}
```

### Task A.5 — DoctorSession Model

**File:** `Alche/Core/Models/DoctorSession.swift`

```swift
struct DoctorSession: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    let practitionerId: UUID
    let sessionTypeId: UUID
    let availabilitySlotId: UUID
    var scheduledDate: Date
    var startTime: Date
    var endTime: Date
    var status: SessionStatus
    var isComplimentary: Bool
    var priceCents: Int
    var stripePaymentIntentId: String?
    var cancellationReason: String?
    var cancelledAt: Date?
    let createdAt: Date

    enum CodingKeys: String, CodingKey { /* snake_case */ }

    // Computed: var isUpcoming: Bool { scheduledDate > Date() && status == .confirmed }
    // Computed: var canCancel: Bool { isUpcoming && startTime > Date().addingTimeInterval(24*3600) }
    // Computed: var formattedDate: String
    // Computed: var formattedPrice: String
}
```

### Task A.6 — ComplimentarySessionAllowance Model

**File:** `Alche/Core/Models/DoctorSession.swift` (below DoctorSession)

```swift
struct ComplimentarySessionAllowance: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    var periodStart: Date
    var periodEnd: Date
    var totalAllowed: Int
    var used: Int
    let createdAt: Date

    enum CodingKeys: String, CodingKey { /* snake_case */ }

    // Computed: var remaining: Int { max(0, totalAllowed - used) }
    // Computed: var hasAvailable: Bool { remaining > 0 }
    // Computed: var formattedPeriod: String ("February 2026")
}
```

### Task A.7 — DoctorSessionServiceProtocol

**File:** `Alche/Core/Services/DoctorSessionServiceProtocol.swift`

```swift
protocol DoctorSessionServiceProtocol: Sendable {
    func allPractitioners() async throws -> [Practitioner]
    func practitioner(id: UUID) async throws -> Practitioner
    func sessionTypes(practitionerId: UUID) async throws -> [SessionType]
    func availability(practitionerId: UUID, from: Date, to: Date) async throws -> [PractitionerAvailability]
    func bookSession(userId: UUID, practitionerId: UUID, sessionTypeId: UUID, slotId: UUID, isComplimentary: Bool) async throws -> DoctorSession
    func cancelSession(sessionId: UUID, reason: String?) async throws
    func upcomingSessions(userId: UUID) async throws -> [DoctorSession]
    func pastSessions(userId: UUID) async throws -> [DoctorSession]
    func complimentaryAllowance(userId: UUID, month: Date) async throws -> ComplimentarySessionAllowance
}
```

### Task A.8 — MockDoctorSessionService

**File:** `Alche/Core/MockServices/MockDoctorSessionService.swift`

Follow `MockGlowScanService.swift` pattern:
- Hard-code 4 practitioners with specialties (see PRD Section 9)
- 4 session types per practitioner
- Generate 2 weeks of availability slots (Mon-Fri, 09:00/10:30/14:00/16:00)
- Persist bookings in UserDefaults keyed by `"alche.mock.doctorSessions.\(userId)"`
- Track complimentary allowance in UserDefaults
- Simulate 0.3-0.8s network delay
- Pre-seed: 1 upcoming + 2 past sessions for demo user

### Acceptance Criteria — Terminal A

- [x] All models compile with Codable, Identifiable, Sendable, Hashable
- [x] All CodingKeys use snake_case mapping
- [x] All preview extensions exist
- [x] Service protocol covers all PRD requirements
- [x] Mock service implements full protocol with persistent data
- [x] 4 practitioners with realistic Berlin-flavored bios
- [x] `xcodebuild` succeeds with 0 errors

---

## Terminal B: Booking Engine — ViewModel + Complimentary Logic

**Goal:** Build the business logic for booking, cancellation, and complimentary session tracking.

**Can run in parallel with Terminal A** if interfaces are agreed (service protocol).
**Depends on:** Terminal A models being defined (can stub initially).

### Task B.1 — PractitionerListViewModel

**File:** `Alche/Features/DoctorSessions/PractitionerListViewModel.swift`

```swift
@Observable
@MainActor
final class PractitionerListViewModel {
    var practitioners: [Practitioner] = []
    var selectedSpecialty: PractitionerSpecialty?
    var isLoading = false
    var errorMessage: String?

    private let service: DoctorSessionServiceProtocol = MockDoctorSessionService()

    var filteredPractitioners: [Practitioner] {
        // Filter by specialty, only active
    }

    func loadPractitioners() async { ... }
}
```

### Task B.2 — SessionBookingViewModel

**File:** `Alche/Features/DoctorSessions/SessionBookingViewModel.swift`

```swift
@Observable
@MainActor
final class SessionBookingViewModel {
    let practitioner: Practitioner
    var sessionTypes: [SessionType] = []
    var selectedSessionType: SessionType?
    var selectedWeekStart: Date = /* current Monday */
    var availableSlots: [PractitionerAvailability] = []
    var selectedSlot: PractitionerAvailability?
    var complimentaryAllowance: ComplimentarySessionAllowance?
    var isLoading = false
    var errorMessage: String?
    var showConfirmation = false
    var lastBooking: DoctorSession?

    private let service: DoctorSessionServiceProtocol = MockDoctorSessionService()

    // Computed
    var canUseComplimentary: Bool { complimentaryAllowance?.hasAvailable == true }
    var effectivePrice: Int { canUseComplimentary ? 0 : selectedSessionType?.priceCents ?? 0 }
    var slotsForSelectedType: [PractitionerAvailability] { /* filter by duration match */ }

    func loadSessionTypes() async { ... }
    func loadAvailability() async { ... }
    func loadComplimentaryStatus() async { ... }
    func confirmBooking() async { ... }
    func navigateWeek(forward: Bool) { ... }
}
```

### Task B.3 — MySessionsViewModel

**File:** `Alche/Features/DoctorSessions/MySessionsViewModel.swift`

```swift
@Observable
@MainActor
final class MySessionsViewModel {
    var upcomingSessions: [DoctorSession] = []
    var pastSessions: [DoctorSession] = []
    var isLoading = false
    var errorMessage: String?
    var showCancelAlert = false
    var sessionToCancel: DoctorSession?

    private let service: DoctorSessionServiceProtocol = MockDoctorSessionService()

    func loadSessions() async { ... }
    func cancelSession(_ session: DoctorSession, reason: String?) async { ... }
}
```

### Acceptance Criteria — Terminal B

- [x] Practitioner list loads and filters by specialty
- [x] Session types load per practitioner
- [x] Availability loads for selected week
- [x] Week navigation (forward/back) works
- [x] Complimentary allowance correctly identifies eligible users
- [x] Booking creates a DoctorSession and marks slot as booked
- [x] Cancellation updates session status and frees slot
- [x] 24-hour cancellation policy enforced (canCancel computed property)
- [x] My Sessions shows upcoming and past with correct status
- [x] `xcodebuild` succeeds with 0 errors

---

## Terminal C: Doctor Session UI

**Goal:** Build all screens for the practitioner booking experience.

**Depends on:** Terminal A (models) + Terminal B (ViewModels)

### Task C.1 — PractitionerListView

**File:** `Alche/Features/DoctorSessions/PractitionerListView.swift`

```
NavigationStack
+-- ScrollView
    +-- Specialty filter pills (horizontal scroll)
    |   All | Longevity | Nutrition | Sleep | Stress | Movement | Skin
    +-- if loading -> ProgressView
    +-- if empty -> AlcheEmptyStateView
    +-- LazyVStack -> ForEach -> PractitionerCard
    |   +-- Photo placeholder (circle, initials or SF Symbol)
    |   +-- Name (alcheBodyMedium) + Title (alcheCaption)
    |   +-- Specialty tags (AlcheTag, Sage)
    |   +-- Rating stars + review count
    |   +-- chevron.right
    +-- DataSourceIndicator("Sample Data")
```

### Task C.2 — PractitionerDetailView

**File:** `Alche/Features/DoctorSessions/PractitionerDetailView.swift`

```
ScrollView
+-- Photo placeholder (large circle, 120pt)
+-- Name (displayL) + Title (alcheBody, stone)
+-- Rating + review count
+-- "ABOUT" overline + bio text (alcheBody)
+-- "SPECIALTIES" overline + AlcheTag chips
+-- "LANGUAGES" overline + language list
+-- "SESSION TYPES" overline
+-- ForEach(sessionTypes) -> SessionTypeCard
|   +-- Name + duration + price
|   +-- Description
|   +-- "Book" button (Terra) or "Included" badge for complimentary
+-- Disclaimer text
+-- DataSourceIndicator
```

### Task C.3 — SessionBookingView (Calendar + Slots)

**File:** `Alche/Features/DoctorSessions/SessionBookingView.swift`

```
VStack
+-- Practitioner mini header (name + session type)
+-- Week navigator (<  Mon 17 Feb - Fri 21 Feb  >)
+-- Day columns (Mon-Fri)
|   +-- ForEach(day in week) -> DayColumn
|       +-- Day label ("Mon 17")
|       +-- ForEach(slots) -> SlotCell
|           +-- Time ("09:00")
|           +-- Available (Terra border) / Booked (Stone, disabled)
+-- Selected slot summary
+-- Complimentary badge (if eligible): "Included in your membership"
+-- Price display (if paid)
+-- "Confirm Booking" button (Terra, full width)
+-- Disclaimer: wellness guidance, not medical advice
```

### Task C.4 — BookingConfirmationView (Sheet)

**File:** `Alche/Features/DoctorSessions/SessionBookingView.swift` (private struct)

```
VStack
+-- Checkmark icon (Sage, 64pt)
+-- "Session Booked" (displayL)
+-- Practitioner name + session type
+-- Date + time
+-- "Add to Calendar" button (optional, out of scope for MVP)
+-- "Done" button (Terra)
```

### Task C.5 — MySessionsView

**File:** `Alche/Features/DoctorSessions/MySessionsView.swift`

```
ScrollView
+-- "UPCOMING" overline
+-- if empty -> "No upcoming sessions" empty state
+-- ForEach(upcoming) -> SessionCard
|   +-- Practitioner name + session type
|   +-- Date + time
|   +-- Status badge (AlcheTag, Sage)
|   +-- "Complimentary" tag if applicable
+-- "PAST" overline
+-- ForEach(past) -> SessionCard (muted colors)
+-- DataSourceIndicator
```

### Task C.6 — SessionDetailView

**File:** `Alche/Features/DoctorSessions/SessionDetailView.swift`

```
ScrollView
+-- Status icon (large, colored by status)
+-- Status text (displayL)
+-- Practitioner card (photo + name + specialty)
+-- Detail rows: Date, Time, Duration, Type
+-- If complimentary: "Included in Membership" badge
+-- If paid: price display
+-- If upcoming + canCancel: "Cancel Session" button (error style)
+-- Cancel alert with reason text field
```

### Acceptance Criteria — Terminal C

- [x] Practitioner list renders 4 practitioners with specialty filters
- [x] Practitioner detail shows full profile with session types
- [x] Calendar shows Mon-Fri slots with week navigation
- [x] Slot selection highlights in Terra, disabled slots in Stone
- [x] Complimentary badge shows when eligible
- [x] Confirmation sheet displays all session details
- [x] My Sessions shows upcoming/past with status badges
- [x] Session detail shows cancel button with 24h policy
- [x] DataSourceIndicator on all screens
- [x] All views use Alche design tokens exclusively
- [x] `xcodebuild` succeeds with 0 errors

---

## Terminal D: Integration — Navigation + Home Card

**Goal:** Wire doctor sessions into existing app navigation.

**Depends on:** Terminals A + B + C

### Task D.1 — Add Doctor Sessions to Booking Tab

**File:** `Alche/Features/Booking/BookingListView.swift`

Add a "Doctor Sessions" section below the LED booking section:

```swift
// Doctor Sessions CTA (after LED booking section, before error display)
NavigationLink {
    PractitionerListView()
} label: {
    HStack(spacing: AlcheSpacing.md) {
        Image(systemName: "stethoscope")
            .font(.title2)
            .foregroundStyle(Color.alcheTerra)
            .frame(width: 44, height: 44)
            .background(Color.alcheTerra.opacity(0.1))
            .clipShape(Circle())

        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text("Wellness Sessions")
                .font(.alcheBodyMedium)
                .foregroundStyle(Color.alcheDeep)
            Text("Book a 1-on-1 with a longevity practitioner")
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheStone)
        }

        Spacer()

        Image(systemName: "chevron.right")
            .font(.alcheCaption)
            .foregroundStyle(Color.alcheStone)
    }
    .padding(AlcheSpacing.md)
    .background(Color.alcheSand.opacity(0.3))
    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
}
.buttonStyle(.plain)
```

### Task D.2 — Add Doctor Session Card to HomeView

**File:** `Alche/Features/Home/HomeView.swift`

Add between "Quick Actions" and "Daily Protocol":

```swift
// Next doctor session (if upcoming)
if let nextSession = viewModel.nextDoctorSession {
    NavigationLink {
        SessionDetailView(session: nextSession)
    } label: {
        AlcheCard(shadow: .medium) {
            // similar to Next Booking card pattern
            // "NEXT SESSION" overline
            // Practitioner name + session type
            // Date + time
            // stethoscope icon in circle
        }
    }
    .buttonStyle(.plain)
    .padding(.horizontal, AlcheSpacing.lg)
}
```

Modify `HomeViewModel` to add `var nextDoctorSession: DoctorSession?` and load it.

### Task D.3 — Add Complimentary Status to Profile

**File:** `Alche/Features/Profile/MembershipManagementView.swift`

Add a row showing complimentary session status for Longevity+ members:

```swift
// "1 wellness session included this month" or "Session used this month"
```

### Task D.4 — My Sessions from Profile

Wire a NavigationLink from Profile to MySessionsView:

```swift
NavigationLink { MySessionsView() } label: {
    AlcheListRow(icon: "stethoscope", title: "My Sessions", detail: "\(upcoming) upcoming")
}
```

### Acceptance Criteria — Terminal D

- [x] Booking tab shows "Wellness Sessions" CTA below LED booking
- [x] Tapping navigates to PractitionerListView
- [x] Home shows next doctor session card when one exists
- [x] Profile shows complimentary session status for premium members
- [x] Profile links to My Sessions
- [x] All navigation flows work end-to-end
- [x] Back buttons work correctly
- [x] `xcodebuild` succeeds with 0 errors

---

## New Files Summary

| Terminal | Files |
|----------|-------|
| A: Data Layer | `Core/Models/Practitioner.swift`, `Core/Models/PractitionerAvailability.swift`, `Core/Models/DoctorSession.swift`, `Core/Services/DoctorSessionServiceProtocol.swift`, `Core/MockServices/MockDoctorSessionService.swift` |
| B: Booking Engine | `Features/DoctorSessions/PractitionerListViewModel.swift`, `Features/DoctorSessions/SessionBookingViewModel.swift`, `Features/DoctorSessions/MySessionsViewModel.swift` |
| C: UI | `Features/DoctorSessions/PractitionerListView.swift`, `Features/DoctorSessions/PractitionerDetailView.swift`, `Features/DoctorSessions/SessionBookingView.swift`, `Features/DoctorSessions/MySessionsView.swift`, `Features/DoctorSessions/SessionDetailView.swift` |
| D: Integration | 0 new / 4 modified (`BookingListView`, `HomeView`, `HomeViewModel`, `MembershipManagementView`) |

**Total: ~13 new files + 4 modified files**

---

*Reference: specs/REQ-026-doctor-sessions/prd.md for full product context.*
