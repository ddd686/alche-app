import SwiftUI

struct NotificationPreferencesView: View {
    @Bindable var viewModel: ProfileViewModel
    @State private var hasRequestedPermission = false

    var body: some View {
        List {
            // Master toggle
            Section {
                Toggle(isOn: $viewModel.notificationsEnabled) {
                    Label("Enable notifications", systemImage: "bell.badge")
                        .foregroundStyle(Color.alchePrimaryText)
                }
                .tint(Color.alchePrimary)
                .onChange(of: viewModel.notificationsEnabled) { _, enabled in
                    if enabled && !hasRequestedPermission {
                        hasRequestedPermission = true
                        // TODO: Call NotificationServiceProtocol.requestPermission()
                    }
                }
            } footer: {
                Text("Turn off to stop all notifications from Alche.")
            }

            // Category toggles
            if viewModel.notificationsEnabled {
                Section {
                    NotificationToggle(
                        title: "Booking reminders",
                        subtitle: "30 min before your LED session",
                        icon: "calendar.badge.clock",
                        isOn: $viewModel.notifyBookings
                    )
                    NotificationToggle(
                        title: "Protocol nudges",
                        subtitle: "Gentle reminders for your daily protocol steps",
                        icon: "list.bullet.clipboard",
                        isOn: $viewModel.notifyProtocols
                    )
                    NotificationToggle(
                        title: "Event updates",
                        subtitle: "New events and RSVP reminders",
                        icon: "sparkles",
                        isOn: $viewModel.notifyEvents
                    )
                    NotificationToggle(
                        title: "New content",
                        subtitle: "Articles and Alche Reviewed posts",
                        icon: "doc.text",
                        isOn: $viewModel.notifyContent
                    )
                    NotificationToggle(
                        title: "Promotions",
                        subtitle: "Member offers and product launches",
                        icon: "tag",
                        isOn: $viewModel.notifyPromotions
                    )
                } header: {
                    Text("Categories")
                } footer: {
                    Text("Choose which types of notifications you'd like to receive.")
                }

                // Timing context
                Section {
                    HStack(alignment: .top, spacing: AlcheSpacing.sm) {
                        Image(systemName: "moon.stars")
                            .foregroundStyle(Color.alcheInfo)
                            .frame(width: 24)
                        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                            Text("Quiet hours")
                                .font(.alcheBody)
                                .foregroundStyle(Color.alchePrimaryText)
                            Text("We won't send notifications between 22:00 and 08:00, except urgent booking changes.")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                        }
                    }
                    .listRowBackground(Color.alcheInfo.opacity(0.05))
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.alcheBackground)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.notifyBookings) { _, _ in savePreferences() }
        .onChange(of: viewModel.notifyProtocols) { _, _ in savePreferences() }
        .onChange(of: viewModel.notifyEvents) { _, _ in savePreferences() }
        .onChange(of: viewModel.notifyContent) { _, _ in savePreferences() }
        .onChange(of: viewModel.notifyPromotions) { _, _ in savePreferences() }
    }

    private func savePreferences() {
        Task { await viewModel.saveNotificationPreferences() }
    }
}

// MARK: - Notification Toggle Row

private struct NotificationToggle: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack(spacing: AlcheSpacing.sm) {
                Image(systemName: icon)
                    .foregroundStyle(Color.alchePrimary)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.alcheBody)
                        .foregroundStyle(Color.alchePrimaryText)
                    Text(subtitle)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
        .tint(Color.alchePrimary)
    }
}

#Preview {
    NavigationStack {
        NotificationPreferencesView(viewModel: ProfileViewModel())
    }
}
