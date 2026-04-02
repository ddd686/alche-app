import Foundation

@Observable
@MainActor
final class ProfileViewModel {
    // MARK: - State

    var user: AlcheUser?
    var membership: Membership?
    var checkinHistory: [DailyCheckin] = []
    var isLoading = false
    var errorMessage: String?

    // Settings
    var notificationsEnabled = true
    var selectedLocale = "en"
    var showDeleteConfirmation = false
    var showDataExport = false
    var showLogoutConfirmation = false

    // Notification Preferences (REQ-012)
    var notifyBookings = true
    var notifyProtocols = true
    var notifyEvents = true
    var notifyContent = true
    var notifyPromotions = false

    // Referral (REQ-017)
    var showShareSheet = false
    var referralCopied = false

    // Daily Check-in
    var showCheckinSheet = false
    var checkinEnergy = 3
    var checkinSleep = 3
    var checkinMood = 3
    var checkinNotes = ""

    // MARK: - Actions

    func loadProfile() async {
        isLoading = true

        // TODO: Wire to AuthServiceProtocol + real data
        try? await Task.sleep(for: .seconds(0.4))

        user = AlcheUser.preview
        membership = Membership.preview
        checkinHistory = Self.sampleCheckins

        isLoading = false
    }

    func submitCheckin() async {
        // TODO: Wire to ProtocolServiceProtocol
        try? await Task.sleep(for: .seconds(0.5))

        let checkin = DailyCheckin(
            id: UUID(),
            userId: user?.id ?? UUID(),
            date: Date(),
            energy: checkinEnergy,
            sleepQuality: checkinSleep,
            mood: checkinMood,
            notes: checkinNotes.isEmpty ? nil : checkinNotes,
            createdAt: Date()
        )

        checkinHistory.insert(checkin, at: 0)
        showCheckinSheet = false
        resetCheckinForm()
    }

    func requestDataExport() async {
        // TODO: Wire to GDPR data export endpoint
        try? await Task.sleep(for: .seconds(1.0))
        showDataExport = false
    }

    func deleteAccount() async {
        // TODO: Wire to account deletion endpoint (GDPR Art. 17)
        try? await Task.sleep(for: .seconds(1.0))
        showDeleteConfirmation = false
    }

    func logout() async {
        // TODO: Wire to AuthServiceProtocol
        try? await Task.sleep(for: .seconds(0.3))
        showLogoutConfirmation = false
    }

    func saveNotificationPreferences() async {
        // TODO: Wire to NotificationServiceProtocol.updatePreferences
        try? await Task.sleep(for: .seconds(0.3))
    }

    var referralCode: String {
        user?.referralCode ?? "ALCHE-XXXX"
    }

    var referralLink: String {
        "https://alche.com/invite/\(referralCode)"
    }

    func copyReferralCode() {
        referralCopied = true
        Task {
            try? await Task.sleep(for: .seconds(2))
            referralCopied = false
        }
    }

    // MARK: - Helpers

    private func resetCheckinForm() {
        checkinEnergy = 3
        checkinSleep = 3
        checkinMood = 3
        checkinNotes = ""
    }

    var averageEnergy: Double {
        guard !checkinHistory.isEmpty else { return 0 }
        return Double(checkinHistory.reduce(0) { $0 + $1.energy }) / Double(checkinHistory.count)
    }

    var averageSleep: Double {
        guard !checkinHistory.isEmpty else { return 0 }
        return Double(checkinHistory.reduce(0) { $0 + $1.sleepQuality }) / Double(checkinHistory.count)
    }

    var averageMood: Double {
        guard !checkinHistory.isEmpty else { return 0 }
        return Double(checkinHistory.reduce(0) { $0 + $1.mood }) / Double(checkinHistory.count)
    }

    // MARK: - Sample Data

    private static let sampleCheckins: [DailyCheckin] = (0..<14).map { dayOffset in
        DailyCheckin(
            id: UUID(),
            userId: UUID(),
            date: Calendar.current.date(byAdding: .day, value: -dayOffset, to: Date()) ?? Date(),
            energy: Int.random(in: 2...5),
            sleepQuality: Int.random(in: 2...5),
            mood: Int.random(in: 3...5),
            notes: dayOffset == 0 ? "Feeling good after yesterday's LED session" : nil,
            createdAt: Date()
        )
    }
}
