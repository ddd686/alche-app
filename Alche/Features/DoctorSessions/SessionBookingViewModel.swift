import Foundation

/// ViewModel for the session booking flow.
/// Handles session type selection, week-based availability navigation,
/// slot selection, complimentary session eligibility, and booking confirmation.
@Observable
@MainActor
final class SessionBookingViewModel {

    // MARK: - State

    let practitioner: Practitioner
    var sessionTypes: [SessionType] = []
    var selectedSessionType: SessionType?
    var selectedWeekStart: Date
    var availableSlots: [PractitionerAvailability] = []
    var selectedSlot: PractitionerAvailability?
    var complimentaryAllowance: ComplimentarySessionAllowance?
    var isLoading = false
    var isBooking = false
    var errorMessage: String?
    var showConfirmation = false
    var lastBooking: DoctorSession?

    // MARK: - Service

    private let service: DoctorSessionServiceProtocol = MockDoctorSessionService()

    // MARK: - Demo user ID (will be replaced with real auth)
    private let userId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    // MARK: - Init

    init(practitioner: Practitioner) {
        self.practitioner = practitioner
        // Start on the current week's Monday
        self.selectedWeekStart = Self.currentWeekMonday()
    }

    // MARK: - Computed Properties

    /// Whether the user can use their complimentary session for this booking.
    var canUseComplimentary: Bool {
        complimentaryAllowance?.hasAvailable == true
    }

    /// The effective price: 0 if complimentary is available and being used, otherwise the session type price.
    var effectivePrice: Int {
        canUseComplimentary ? 0 : (selectedSessionType?.priceCents ?? 0)
    }

    /// Formatted effective price for display.
    var formattedEffectivePrice: String {
        if canUseComplimentary {
            return "Included in Membership"
        }
        guard let sessionType = selectedSessionType else { return "" }
        return sessionType.formattedPrice
    }

    /// The end date of the currently selected week (Friday).
    var selectedWeekEnd: Date {
        Calendar.current.date(byAdding: .day, value: 4, to: selectedWeekStart) ?? selectedWeekStart
    }

    /// Formatted week range for display (e.g., "Mon 17 Feb - Fri 21 Feb").
    var formattedWeekRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE d MMM"
        return "\(formatter.string(from: selectedWeekStart)) \u{2013} \(formatter.string(from: selectedWeekEnd))"
    }

    /// Whether we can navigate to the previous week (not before current week).
    var canNavigateBack: Bool {
        selectedWeekStart > Self.currentWeekMonday()
    }

    /// Days in the selected week (Mon-Fri) with their available slots.
    var weekDays: [WeekDay] {
        let calendar = Calendar.current
        return (0..<5).compactMap { dayOffset in
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: selectedWeekStart) else {
                return nil
            }
            let dayStart = calendar.startOfDay(for: day)
            let slotsForDay = availableSlots
                .filter { calendar.isDate($0.date, inSameDayAs: dayStart) }
                .sorted { $0.startTime < $1.startTime }

            return WeekDay(date: day, slots: slotsForDay)
        }
    }

    /// Whether a booking can be confirmed (slot and session type selected).
    var canConfirmBooking: Bool {
        selectedSlot != nil && selectedSessionType != nil && selectedSlot?.isAvailable == true
    }

    /// Slots filtered to match the selected session type's duration.
    var slotsForSelectedType: [PractitionerAvailability] {
        guard let sessionType = selectedSessionType else { return availableSlots }
        return availableSlots.filter { slot in
            slot.durationMinutes >= sessionType.durationMinutes
        }
    }

    // MARK: - Actions

    /// Loads session types for the practitioner.
    func loadSessionTypes() async {
        isLoading = true
        errorMessage = nil

        do {
            sessionTypes = try await service.sessionTypes(practitionerId: practitioner.id)
            if selectedSessionType == nil {
                selectedSessionType = sessionTypes.first
            }
        } catch {
            errorMessage = "Unable to load session types. Please try again."
        }

        isLoading = false
    }

    /// Loads availability for the selected week.
    func loadAvailability() async {
        isLoading = true
        errorMessage = nil
        selectedSlot = nil

        do {
            let weekEnd = Calendar.current.date(byAdding: .day, value: 5, to: selectedWeekStart)
                ?? selectedWeekStart
            availableSlots = try await service.availability(
                practitionerId: practitioner.id,
                from: selectedWeekStart,
                to: weekEnd
            )
        } catch {
            errorMessage = "Unable to load availability. Please try again."
        }

        isLoading = false
    }

    /// Loads complimentary session status for the current month.
    func loadComplimentaryStatus() async {
        do {
            complimentaryAllowance = try await service.complimentaryAllowance(
                userId: userId,
                month: Date()
            )
        } catch {
            // Silently fail -- user just won't see complimentary option
            complimentaryAllowance = nil
        }
    }

    /// Loads all initial data: session types, availability, and complimentary status.
    func loadInitialData() async {
        await loadSessionTypes()
        await loadAvailability()
        await loadComplimentaryStatus()
    }

    /// Confirms the booking with the selected slot and session type.
    func confirmBooking() async {
        guard let slot = selectedSlot else {
            errorMessage = "Please select a time slot."
            return
        }
        guard let sessionType = selectedSessionType else {
            errorMessage = "Please select a session type."
            return
        }

        isBooking = true
        errorMessage = nil

        do {
            let session = try await service.bookSession(
                userId: userId,
                practitionerId: practitioner.id,
                sessionTypeId: sessionType.id,
                slotId: slot.id,
                isComplimentary: canUseComplimentary
            )

            lastBooking = session
            showConfirmation = true

            // Refresh availability to reflect the now-booked slot
            await loadAvailability()

            // Refresh complimentary status
            if canUseComplimentary {
                await loadComplimentaryStatus()
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isBooking = false
    }

    /// Navigates to the next or previous week.
    func navigateWeek(forward: Bool) {
        let calendar = Calendar.current
        let offset = forward ? 7 : -7
        guard let newStart = calendar.date(byAdding: .day, value: offset, to: selectedWeekStart) else { return }

        // Don't navigate before current week
        let currentMonday = Self.currentWeekMonday()
        if newStart < currentMonday {
            return
        }

        selectedWeekStart = newStart
        selectedSlot = nil

        Task {
            await loadAvailability()
        }
    }

    /// Selects a time slot.
    func selectSlot(_ slot: PractitionerAvailability) {
        guard slot.isAvailable else { return }
        if selectedSlot?.id == slot.id {
            selectedSlot = nil
        } else {
            selectedSlot = slot
        }
    }

    /// Selects a session type and refreshes availability if needed.
    func selectSessionType(_ type: SessionType) {
        selectedSessionType = type
        selectedSlot = nil
    }

    // MARK: - Week Helpers

    /// Returns the Monday of the current week.
    static func currentWeekMonday() -> Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)
        // weekday: 1 = Sunday, 2 = Monday, ..., 7 = Saturday
        let daysFromMonday = (weekday + 5) % 7
        return calendar.date(byAdding: .day, value: -daysFromMonday, to: today)
            ?? today
    }
}

// MARK: - WeekDay Model

extension SessionBookingViewModel {
    /// Represents a single day in the week view with its available slots.
    struct WeekDay: Identifiable {
        let date: Date
        let slots: [PractitionerAvailability]

        var id: Date { date }

        var dayLabel: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            return formatter.string(from: date)
        }

        var dateLabel: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            return formatter.string(from: date)
        }

        var fullLabel: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE d"
            return formatter.string(from: date)
        }

        var isToday: Bool {
            Calendar.current.isDateInToday(date)
        }

        var isPast: Bool {
            date < Calendar.current.startOfDay(for: Date())
        }

        var hasAvailableSlots: Bool {
            slots.contains { $0.isAvailable }
        }
    }
}
