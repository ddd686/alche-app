import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @State private var bioViewModel = BiomarkerViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // ─── 1. Profile Header ───────────────────────────
                VStack(spacing: AlcheSpacing.md) {
                    // Avatar circle — 96x96, initials, border
                    ZStack {
                        Circle()
                            .fill(Color.alcheSurface)
                            .frame(width: 96, height: 96)
                            .overlay(
                                Circle()
                                    .stroke(Color.alchePrimary, lineWidth: 1.5)
                            )

                        Text(
                            String(viewModel.user?.displayName?.prefix(2).uppercased() ?? "AL")
                        )
                        .font(.alcheOverline)
                        .fontWeight(.bold)
                        .tracking(2)
                        .foregroundStyle(Color.alchePrimary)
                    }

                    // Name — Display L italic
                    Text(viewModel.user?.displayName ?? "Welcome")
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)
                        .multilineTextAlignment(.center)

                    // Badge — membership tier
                    if let membership = viewModel.membership {
                        Text(
                            "FOUNDING MEMBER · \(membership.tier.displayName.uppercased())"
                        )
                        .font(.alcheOverline)
                        .tracking(1.2)
                        .foregroundStyle(Color.alcheSecondaryText)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, AlcheSpacing.xl)
                .padding(.bottom, AlcheSpacing.lg)

                // ─── 2. Wellness Snapshot ─────────────────────────
                if let latest = viewModel.checkinHistory.first,
                   latest.date.isToday
                {
                    HStack(spacing: 0) {
                        WellnessMetric(label: "ENERGY", value: "\(latest.energy)")
                        WellnessMetric(label: "SLEEP", value: "\(latest.sleepQuality)")
                        WellnessMetric(label: "MOOD", value: "\(latest.mood)")
                    }
                    .padding(AlcheSpacing.lg)
                    .background(Color.alcheWarmGray.opacity(0.3))
                    .alcheShadow(.subtle)
                    .padding(.horizontal, AlcheSpacing.lg)
                    .padding(.bottom, AlcheSpacing.lg)
                } else {
                    // Prompt check-in if none today
                    Button {
                        viewModel.showCheckinSheet = true
                    } label: {
                        HStack(spacing: 0) {
                            WellnessMetric(label: "ENERGY", value: "—")
                            WellnessMetric(label: "SLEEP", value: "—")
                            WellnessMetric(label: "MOOD", value: "—")
                        }
                        .padding(AlcheSpacing.lg)
                        .background(Color.alcheWarmGray.opacity(0.3))
                        .alcheShadow(.subtle)
                        .overlay(
                            VStack {
                                Spacer()
                                Text("TAP TO CHECK IN")
                                    .font(.alcheOverlineTiny)
                                    .tracking(1)
                                    .foregroundStyle(Color.alchePrimary)
                                    .padding(.bottom, AlcheSpacing.sm)
                            }
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, AlcheSpacing.lg)
                    .padding(.bottom, AlcheSpacing.lg)
                }

                // ─── 3. Personalization & Wellness ──────────────────
                VStack(spacing: AlcheSpacing.md) {
                    PersonalizationLevelView()

                    NavigationLink {
                        DeepProfileView()
                    } label: {
                        AlcheCard(variant: .flat) {
                            HStack(spacing: AlcheSpacing.md) {
                                Image(systemName: "list.bullet.clipboard")
                                    .font(.alcheBody)
                                    .foregroundStyle(Color.alchePrimary)
                                    .frame(width: 24)

                                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                                    Text("Deep Profile")
                                        .font(.alcheBodyMedium)
                                        .foregroundStyle(Color.alchePrimaryText)

                                    Text("Fine-tune your protocols")
                                        .font(.alcheCaption)
                                        .foregroundStyle(Color.alcheSecondaryText)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }
                        }
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        SupplementRecommendationView()
                    } label: {
                        AlcheCard(variant: .flat) {
                            HStack(spacing: AlcheSpacing.md) {
                                Image(systemName: "pills")
                                    .font(.alcheBody)
                                    .foregroundStyle(Color.alchePrimary)
                                    .frame(width: 24)

                                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                                    Text("Supplement Stack")
                                        .font(.alcheBodyMedium)
                                        .foregroundStyle(Color.alchePrimaryText)

                                    Text("Your personalized recommendations")
                                        .font(.alcheCaption)
                                        .foregroundStyle(Color.alcheSecondaryText)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, AlcheSpacing.lg)
                .padding(.bottom, AlcheSpacing.lg)

                // ─── 4. Settings Menu ─────────────────────────────
                VStack(spacing: 0) {
                    // Membership
                    if let membership = viewModel.membership {
                        NavigationLink {
                            MembershipManagementView(membership: membership)
                        } label: {
                            ProfileMenuItem(title: "Membership")
                        }
                        .buttonStyle(.plain)
                        ProfileMenuDivider()
                    }

                    // Notification Preferences
                    NavigationLink {
                        NotificationPreferencesView(viewModel: viewModel)
                    } label: {
                        ProfileMenuItem(title: "Notification Preferences")
                    }
                    .buttonStyle(.plain)
                    ProfileMenuDivider()

                    // Privacy & Data
                    NavigationLink {
                        SettingsView(viewModel: viewModel)
                    } label: {
                        ProfileMenuItem(title: "Privacy & Data")
                    }
                    .buttonStyle(.plain)
                    ProfileMenuDivider()

                    // Language
                    NavigationLink {
                        SettingsView(viewModel: viewModel)
                    } label: {
                        ProfileMenuItem(
                            title: "Language",
                            trailing: viewModel.selectedLocale == "en" ? "EN" : "DE"
                        )
                    }
                    .buttonStyle(.plain)
                    ProfileMenuDivider()

                    // Refer a Friend
                    NavigationLink {
                        ReferralView(viewModel: viewModel)
                    } label: {
                        ProfileMenuItem(title: "Refer a Friend")
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, AlcheSpacing.md)

                // ─── 5. Sign Out ──────────────────────────────────
                Button {
                    viewModel.showLogoutConfirmation = true
                } label: {
                    HStack(spacing: AlcheSpacing.sm) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.alcheBody)
                        Text("Sign Out")
                            .font(.alcheBodyMedium)
                    }
                    .foregroundStyle(Color.alcheError)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, AlcheSpacing.md)
                }
                .buttonStyle(.plain)
                .padding(.top, AlcheSpacing.lg)

                // ─── 6. Footer ────────────────────────────────────
                VStack(spacing: AlcheSpacing.md) {
                    Rectangle()
                        .fill(Color.alcheSecondaryText.opacity(0.3))
                        .frame(width: 32, height: 1)

                    Text("MEMBER SINCE MARCH 2026")
                        .font(.alcheOverlineTiny)
                        .tracking(1.5)
                        .foregroundStyle(Color.alcheSecondaryText.opacity(0.5))
                }
                .padding(.top, AlcheSpacing.xl)
                .padding(.bottom, AlcheSpacing.xxl)
            }
        }
        .background(Color.alcheBackground)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showCheckinSheet) {
            CheckinSheet(viewModel: viewModel)
        }
        .alert("Log out?", isPresented: $viewModel.showLogoutConfirmation) {
            Button("Log out", role: .destructive) {
                Task { await viewModel.logout() }
            }
            Button("Cancel", role: .cancel) {}
        }
        .task {
            await viewModel.loadProfile()
            await bioViewModel.loadDashboard()
        }
    }
}

// MARK: - Wellness Metric (3-col grid item)

private struct WellnessMetric: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: AlcheSpacing.xs) {
            Text(label)
                .font(.alcheOverlineTiny)
                .tracking(1)
                .foregroundStyle(Color.alcheSecondaryText)

            Text(value)
                .font(.alcheDisplayM)
                .foregroundStyle(Color.alcheEditorialBlack)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Profile Menu Item

private struct ProfileMenuItem: View {
    let title: String
    var trailing: String? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.alcheBodyMedium)
                .foregroundStyle(Color.alcheEditorialBlack)

            Spacer()

            if let trailing {
                Text(trailing)
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .padding(.trailing, AlcheSpacing.xs)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.alcheSecondaryText)
        }
        .padding(.vertical, AlcheSpacing.md)
        .padding(.horizontal, AlcheSpacing.md)
        .contentShape(Rectangle())
    }
}

// MARK: - Profile Menu Divider

private struct ProfileMenuDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.alcheEditorialBlack.opacity(0.05))
            .frame(height: 1)
            .padding(.horizontal, AlcheSpacing.md)
    }
}

// MARK: - Check-in Sheet

private struct CheckinSheet: View {
    @Bindable var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: AlcheSpacing.xl) {
                Text("How are you feeling?")
                    .font(.alcheDisplayL)
                    .foregroundStyle(Color.alchePrimaryText)

                VStack(spacing: AlcheSpacing.lg) {
                    SliderRow(label: "Energy", value: $viewModel.checkinEnergy, color: .alchePrimary)
                    SliderRow(label: "Sleep quality", value: $viewModel.checkinSleep, color: .alcheInfo)
                    SliderRow(label: "Mood", value: $viewModel.checkinMood, color: .alcheSage)
                }

                AlcheTextField(
                    label: "Notes (optional)",
                    text: $viewModel.checkinNotes,
                    placeholder: "Anything on your mind..."
                )

                Spacer()

                AlcheButton("Save check-in") {
                    Task {
                        await viewModel.submitCheckin()
                        dismiss()
                    }
                }
            }
            .padding(AlcheSpacing.lg)
            .background(Color.alcheBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
    }
}

private struct SliderRow: View {
    let label: String
    @Binding var value: Int
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
            HStack {
                Text(label)
                    .font(.alcheBody)
                    .foregroundStyle(Color.alchePrimaryText)
                Spacer()
                Text("\(value)/5")
                    .font(.alcheBodyMedium)
                    .foregroundStyle(color)
            }

            HStack(spacing: AlcheSpacing.sm) {
                ForEach(1...5, id: \.self) { level in
                    Button {
                        value = level
                    } label: {
                        Circle()
                            .fill(level <= value ? color : Color.alcheWarmGray)
                            .frame(width: 36, height: 36)
                            .overlay(
                                Text("\(level)")
                                    .font(.alcheCaption)
                                    .foregroundStyle(level <= value ? .alcheWhite : Color.alcheSecondaryText)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Date Extension

private extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
