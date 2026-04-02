import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: ProfileViewModel

    var body: some View {
        List {
            // Preferences
            Section {
                // Language
                HStack {
                    Label("Language", systemImage: "globe")
                        .foregroundStyle(Color.alchePrimaryText)
                    Spacer()
                    Picker("", selection: $viewModel.selectedLocale) {
                        Text("English").tag("en")
                        Text("Deutsch").tag("de")
                    }
                    .tint(Color.alchePrimary)
                }

                // Notifications
                NavigationLink {
                    NotificationPreferencesView(viewModel: viewModel)
                } label: {
                    HStack {
                        Label("Notifications", systemImage: "bell")
                            .foregroundStyle(Color.alchePrimaryText)
                        Spacer()
                        if viewModel.notificationsEnabled {
                            Text("On")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                        }
                    }
                }
            } header: {
                Text("Preferences")
            }

            // Privacy & Data (GDPR)
            Section {
                Button {
                    viewModel.showDataExport = true
                } label: {
                    Label("Export my data", systemImage: "square.and.arrow.up")
                        .foregroundStyle(Color.alchePrimaryText)
                }

                NavigationLink {
                    GDPRInfoView()
                } label: {
                    Label("Privacy & data usage", systemImage: "lock.shield")
                        .foregroundStyle(Color.alchePrimaryText)
                }
            } header: {
                Text("Privacy & Data")
            } footer: {
                Text("Under GDPR, you have the right to export or delete your data at any time.")
            }

            // Account
            Section {
                Button {
                    viewModel.showLogoutConfirmation = true
                } label: {
                    Label("Log out", systemImage: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(Color.alchePrimaryText)
                }

                Button(role: .destructive) {
                    viewModel.showDeleteConfirmation = true
                } label: {
                    Label("Delete account", systemImage: "trash")
                        .foregroundStyle(Color.alcheError)
                }
            } header: {
                Text("Account")
            } footer: {
                Text("Deleting your account permanently removes all your data including scan history, biomarker profiles, and booking records.")
            }

            // App info
            Section {
                HStack {
                    Text("Version")
                        .foregroundStyle(Color.alchePrimaryText)
                    Spacer()
                    Text("1.0.0 (MVP)")
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.alcheBackground)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Log out?", isPresented: $viewModel.showLogoutConfirmation) {
            Button("Log out", role: .destructive) {
                Task { await viewModel.logout() }
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Delete account?", isPresented: $viewModel.showDeleteConfirmation) {
            Button("Delete permanently", role: .destructive) {
                Task { await viewModel.deleteAccount() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone. All your data will be permanently deleted.")
        }
        .alert("Export data", isPresented: $viewModel.showDataExport) {
            Button("Request export") {
                Task { await viewModel.requestDataExport() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("We'll prepare a file containing all your personal data. You'll receive a notification when it's ready.")
        }
    }
}

// MARK: - GDPR Info

private struct GDPRInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                Text("How we handle your data")
                    .font(.alcheDisplayL)
                    .foregroundStyle(Color.alchePrimaryText)

                InfoSection(
                    title: "What we collect",
                    items: [
                        "Profile information (name, email, preferences)",
                        "Health goals from your onboarding quiz",
                        "Booking and order history",
                        "Self-reported daily check-ins",
                        "Glow Scan photos and results (stored encrypted)",
                    ]
                )

                InfoSection(
                    title: "How we use it",
                    items: [
                        "To personalise your protocols and recommendations",
                        "To manage your bookings and memberships",
                        "To improve our products and services",
                        "Never for advertising or sold to third parties",
                    ]
                )

                InfoSection(
                    title: "Your rights",
                    items: [
                        "Access: View all data we hold about you",
                        "Portability: Export your data in a standard format",
                        "Erasure: Delete your account and all data permanently",
                        "Rectification: Correct any inaccurate personal data",
                        "Restriction: Limit how we process your data",
                    ]
                )

                Text("All data is stored on EU-based servers (Frankfurt) and processed in compliance with GDPR.")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
            }
            .padding(AlcheSpacing.lg)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct InfoSection: View {
    let title: String
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
            Text(title)
                .font(.alcheSubheading)
                .foregroundStyle(Color.alchePrimaryText)

            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: AlcheSpacing.sm) {
                    Circle()
                        .fill(Color.alchePrimary)
                        .frame(width: 5, height: 5)
                        .padding(.top, 7)
                    Text(item)
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(viewModel: ProfileViewModel())
    }
}
