import Foundation

@Observable
@MainActor
final class BookingViewModel {
    // MARK: - State

    var availableSlots: [TimeSlot] = []
    var upcomingBookings: [Booking] = []
    var selectedDate: Date = .now
    var selectedSessionType: LEDSessionType = .glow
    var selectedSlot: TimeSlot?
    var isLoading = false
    var errorMessage: String?
    var showConfirmation = false
    var lastBooking: Booking?

    // Smoothie pre-order
    var selectedSmoothie: MenuItem?
    var selectedBoosts: [BoostType] = []
    var wantsPreOrder = false

    // MARK: - Slot Model

    struct TimeSlot: Identifiable, Hashable {
        let id = UUID()
        let start: Date
        let end: Date
        let remainingCapacity: Int

        var isAvailable: Bool { remainingCapacity > 0 }

        var formattedTime: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: start)
        }

        var formattedRange: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return "\(formatter.string(from: start)) – \(formatter.string(from: end))"
        }
    }

    // MARK: - Actions

    func loadAvailableSlots() async {
        isLoading = true
        errorMessage = nil

        // TODO: Wire to BookingServiceProtocol
        // Generating mock 15-minute slots from 10:00–20:00
        var slots: [TimeSlot] = []
        let calendar = Calendar.current
        let baseDate = calendar.startOfDay(for: selectedDate)

        for hour in 10..<20 {
            for quarter in [0, 15, 30, 45] {
                guard let start = calendar.date(
                    bySettingHour: hour, minute: quarter, second: 0, of: baseDate
                ) else { continue }
                guard let end = calendar.date(byAdding: .minute, value: 15, to: start) else { continue }

                let remaining = Int.random(in: 0...2)
                slots.append(TimeSlot(start: start, end: end, remainingCapacity: remaining))
            }
        }

        try? await Task.sleep(for: .seconds(0.5))
        availableSlots = slots
        isLoading = false
    }

    func loadUpcomingBookings() async {
        isLoading = true

        // TODO: Wire to BookingServiceProtocol
        try? await Task.sleep(for: .seconds(0.3))
        upcomingBookings = [Booking.preview]
        isLoading = false
    }

    func confirmBooking() async {
        guard let slot = selectedSlot else {
            errorMessage = "Please select a time slot."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            // TODO: Wire to BookingServiceProtocol
            try await Task.sleep(for: .seconds(1.0))

            let booking = Booking(
                id: UUID(),
                userId: UUID(),
                serviceType: .led,
                sessionType: selectedSessionType,
                slotStart: slot.start,
                slotEnd: slot.end,
                status: .confirmed,
                qrCode: "ALCHE-\(UUID().uuidString.prefix(8).uppercased())",
                creditsUsed: 1,
                smoothiePreorderId: selectedSmoothie != nil ? UUID() : nil,
                createdAt: Date()
            )

            lastBooking = booking
            upcomingBookings.insert(booking, at: 0)
            showConfirmation = true
            selectedSlot = nil
        } catch {
            errorMessage = "Could not complete your booking. Please try again."
        }

        isLoading = false
    }

    func cancelBooking(_ booking: Booking) async {
        isLoading = true

        // TODO: Wire to BookingServiceProtocol
        try? await Task.sleep(for: .seconds(0.5))

        if let index = upcomingBookings.firstIndex(where: { $0.id == booking.id }) {
            upcomingBookings.remove(at: index)
        }

        isLoading = false
    }

    // MARK: - Computed

    var availableSlotsForSelection: [TimeSlot] {
        availableSlots.filter(\.isAvailable)
    }

    var preOrderTotal: Int {
        guard let smoothie = selectedSmoothie else { return 0 }
        let boostsCost = selectedBoosts.reduce(0) { $0 + $1.priceCents }
        return smoothie.priceCents + boostsCost
    }
}
