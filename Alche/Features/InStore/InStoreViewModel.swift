import Foundation

@Observable
@MainActor
final class InStoreViewModel {
    // MARK: - State

    var isCheckedIn = false
    var currentBooking: Booking?
    var activeSession: ActiveSession?
    var membership: Membership?
    var isLoading = false
    var errorMessage: String?

    // MARK: - Active Session

    struct ActiveSession {
        let booking: Booking
        let startedAt: Date
        let endsAt: Date

        var remainingSeconds: Int {
            max(0, Int(endsAt.timeIntervalSinceNow))
        }

        var remainingMinutes: Int {
            remainingSeconds / 60
        }

        var progress: Double {
            let total = endsAt.timeIntervalSince(startedAt)
            let elapsed = Date().timeIntervalSince(startedAt)
            return min(1.0, elapsed / total)
        }

        var isComplete: Bool {
            remainingSeconds <= 0
        }
    }

    // MARK: - Actions

    func loadInStoreState() async {
        isLoading = true

        // TODO: Wire to Supabase
        try? await Task.sleep(for: .seconds(0.3))

        membership = Membership.preview
        currentBooking = Booking.preview
        isLoading = false
    }

    func checkIn(qrCode: String) async {
        isLoading = true
        errorMessage = nil

        do {
            // TODO: Wire to Supabase Edge Function for check-in validation
            try await Task.sleep(for: .seconds(1.0))

            isCheckedIn = true
            if let booking = currentBooking {
                activeSession = ActiveSession(
                    booking: booking,
                    startedAt: Date(),
                    endsAt: Date().addingTimeInterval(TimeInterval(booking.durationMinutes * 60))
                )
            }
        } catch {
            errorMessage = "Check-in failed. Please ask staff for help."
        }

        isLoading = false
    }

    func orderFromSeat() {
        // TODO: Open smoothie menu in "order from seat" mode
    }

    // MARK: - Computed

    var membershipTierName: String {
        membership?.tier.displayName ?? "Explorer"
    }

    var creditsRemaining: Int {
        membership?.creditsRemaining ?? 0
    }

    var qrCodeString: String? {
        currentBooking?.qrCode
    }
}
