import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = HomeViewModel()
    @State private var showGlowScan = false
    @State private var showCheckIn = false
    @State private var showEatSmart = false
    @State private var showMacroDashboard = false
    @State private var showRoadmap = false
    @State private var showRitualNotification = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AlcheSpacing.xl) {

                // MARK: 1 — Welcome Section

                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("PRIVATE MEMBERSHIP")
                        .font(.alcheOverline)
                        .tracking(0.8)
                        .foregroundStyle(Color.alcheSecondaryText)

                    Text(viewModel.greeting)
                        .font(.alcheDisplayXL)
                        .foregroundStyle(Color.alchePrimaryText)

                    if let membership = viewModel.membership {
                        HStack(spacing: AlcheSpacing.xs) {
                            AlcheTag(text: membership.tier.displayName, color: .alchePrimary, isSelected: true)

                            if membership.isFoundingMember {
                                AlcheTag(text: "Founder", color: .alcheAmber, isSelected: true)
                            }
                        }
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // MARK: 2 — Next Session Card

                if let booking = viewModel.nextBooking {
                    AlcheCard(variant: .flat) {
                        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                            Text("UPCOMING APPOINTMENT")
                                .font(.alcheOverline)
                                .foregroundStyle(Color.alcheSecondaryText)
                                .tracking(0.8)

                            HStack {
                                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                                    Text(booking.sessionType?.displayName ?? "LED")
                                        .font(.alcheSubheading)
                                        .foregroundStyle(Color.alcheEditorialBlack)

                                    Text(formattedBookingTime(booking))
                                        .font(.alcheCaption)
                                        .foregroundStyle(Color.alcheSecondaryText)
                                }

                                Spacer()

                                Image(systemName: "light.max")
                                    .font(.title2)
                                    .foregroundStyle(Color.alchePrimary)
                                    .padding(AlcheSpacing.sm)
                                    .background(Color.alchePrimary.opacity(0.06))
                                    .clipShape(Circle())
                            }

                            AlcheButton("View Details →", style: .underline) {}
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }

                // Slots remaining
                HStack(spacing: AlcheSpacing.sm) {
                    Image(systemName: "clock")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheAmber)
                    Text("\(viewModel.slotsRemainingToday) LED slots remaining today")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // MARK: 3 — Quick Actions (horizontal scroll)

                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("QUICK ACTIONS")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(0.8)
                        .padding(.horizontal, AlcheSpacing.lg)

                    QuickActionGrid(
                        onBookLED: { appState.selectedTab = .book },
                        onOrderSmoothie: { appState.selectedTab = .book },
                        onGlowScan: { showGlowScan = true },
                        onCheckIn: { showCheckIn = true },
                        onEatSmart: { showEatSmart = true }
                    )
                }

                // MARK: 4 — Today's Protocol

                if let proto = viewModel.todayProtocol {
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        HStack {
                            Text("TODAY'S PROTOCOL")
                                .font(.alcheOverline)
                                .foregroundStyle(Color.alcheSecondaryText)
                                .tracking(0.8)

                            Spacer()

                            NavigationLink {
                                ProtocolListView()
                            } label: {
                                Text("View all")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alchePrimary)
                            }
                        }
                        .padding(.horizontal, AlcheSpacing.lg)

                        DailyProtocolCard(
                            protocolItem: proto,
                            completedSteps: viewModel.completedSteps,
                            totalSteps: viewModel.totalSteps
                        )
                        .padding(.horizontal, AlcheSpacing.lg)
                    }
                }

                // MARK: 5 — Roadmap CTA

                NavigationLink {
                    RoadmapView()
                } label: {
                    AlcheCard(shadow: .medium) {
                        HStack {
                            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                                Text("PROJECT: LONGEVITY")
                                    .font(.alcheOverline)
                                    .foregroundStyle(Color.alcheSecondaryText)
                                    .tracking(0.8)

                                Text("Roadmap")
                                    .font(.alcheDisplayL)
                                    .italic()
                                    .foregroundStyle(Color.alcheEditorialBlack)

                                Text("Phase 2 active — Cellular Repair")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }

                            Spacer()

                            Image(systemName: "arrow.right")
                                .foregroundStyle(Color.alchePrimary)
                        }
                    }
                }
                .buttonStyle(.plain)
                .padding(.horizontal, AlcheSpacing.lg)

                // MARK: 6 — Macro Summary

                if let summary = viewModel.macroSummary {
                    NavigationLink {
                        MacroDashboardView()
                    } label: {
                        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                            Text("TODAY'S NUTRITION")
                                .font(.alcheOverline)
                                .foregroundStyle(Color.alcheSecondaryText)
                                .tracking(0.8)

                            HStack {
                                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                                    Text("\(summary.totalCalories) kcal")
                                        .font(.alcheSubheading)
                                        .foregroundStyle(Color.alcheEditorialBlack)
                                    Text("\(summary.entryCount) meal\(summary.entryCount == 1 ? "" : "s") logged")
                                        .font(.alcheCaption)
                                        .foregroundStyle(Color.alcheSecondaryText)
                                }

                                Spacer()

                                // Mini macro indicators
                                HStack(spacing: AlcheSpacing.sm) {
                                    MiniMacroDot(label: "P", value: summary.totalProtein, color: .alcheSage)
                                    MiniMacroDot(label: "C", value: summary.totalCarbs, color: .alcheAmber)
                                    MiniMacroDot(label: "F", value: summary.totalFat, color: .alchePrimary)
                                }
                            }
                        }
                        .padding(AlcheSpacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.alcheWarmGray.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                        .overlay(
                            RoundedRectangle(cornerRadius: AlcheRadii.md)
                                .stroke(Color.alcheEditorialBlack.opacity(0.10), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, AlcheSpacing.lg)
                }

                // MARK: — Next Doctor Session

                if let nextSession = viewModel.nextDoctorSession {
                    NavigationLink {
                        SessionDetailView(session: nextSession)
                    } label: {
                        AlcheCard(shadow: .medium) {
                            VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                                Text("NEXT WELLNESS SESSION")
                                    .font(.alcheOverline)
                                    .foregroundStyle(Color.alcheSecondaryText)
                                    .tracking(0.8)

                                HStack {
                                    VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                                        Text(viewModel.nextDoctorSessionPractitionerName)
                                            .font(.alcheSubheading)
                                            .foregroundStyle(Color.alcheEditorialBlack)

                                        Text(viewModel.nextDoctorSessionTypeName)
                                            .font(.alcheCaption)
                                            .foregroundStyle(Color.alcheSecondaryText)

                                        Text(formattedDoctorSessionTime(nextSession))
                                            .font(.alcheCaption)
                                            .foregroundStyle(Color.alcheSecondaryText)
                                    }

                                    Spacer()

                                    Image(systemName: "stethoscope")
                                        .font(.title2)
                                        .foregroundStyle(Color.alchePrimary)
                                        .padding(AlcheSpacing.sm)
                                        .background(Color.alchePrimary.opacity(0.06))
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, AlcheSpacing.lg)
                }

                // MARK: — Ritual Notification CTA

                Button {
                    showRitualNotification = true
                } label: {
                    AlcheCard {
                        HStack {
                            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                                Text("RITUAL READY")
                                    .font(.alcheOverline)
                                    .foregroundStyle(Color.alcheSecondaryText)
                                    .tracking(0.8)

                                Text("Cellular Hydration")
                                    .font(.alcheSubheading)
                                    .foregroundStyle(Color.alcheEditorialBlack)

                                Text("Tap to begin your ritual")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }

                            Spacer()

                            Image(systemName: "drop.fill")
                                .font(.title2)
                                .foregroundStyle(Color.alchePrimary)
                                .padding(AlcheSpacing.sm)
                                .background(Color.alchePrimary.opacity(0.06))
                                .clipShape(Circle())
                        }
                    }
                }
                .buttonStyle(.plain)
                .padding(.horizontal, AlcheSpacing.lg)

                // MARK: — Credit Balance

                if let membership = viewModel.membership, membership.creditsRemaining > 0 {
                    AlcheCard {
                        HStack {
                            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                                Text("LED CREDITS")
                                    .font(.alcheOverline)
                                    .foregroundStyle(Color.alcheSecondaryText)
                                    .tracking(0.8)

                                Text("\(membership.creditsRemaining) remaining this month")
                                    .font(.alcheBody)
                                    .foregroundStyle(Color.alchePrimaryText)
                            }

                            Spacer()

                            Text("\(membership.creditsRemaining)")
                                .font(.alcheDisplayL)
                                .foregroundStyle(Color.alchePrimary)
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }
            }
            .padding(.top, AlcheSpacing.xxl)
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showGlowScan) {
            GlowScanView()
        }
        .navigationDestination(isPresented: $showCheckIn) {
            InStoreView()
        }
        .navigationDestination(isPresented: $showEatSmart) {
            RestaurantListView()
        }
        .navigationDestination(isPresented: $showMacroDashboard) {
            MacroDashboardView()
        }
        .fullScreenCover(isPresented: $showRitualNotification) {
            RitualNotificationView(
                ritualTitle: "Cellular",
                ritualSubtitle: "Hydration",
                variantLabel: "Var. 7",
                sequenceLabel: "H20-Seq",
                onDismiss: { showRitualNotification = false },
                onBegin: { showRitualNotification = false }
            )
        }
        .task {
            await viewModel.loadDashboard()
        }
    }

    private func formattedBookingTime(_ booking: Booking) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, HH:mm"
        return formatter.string(from: booking.slotStart)
    }

    private func formattedDoctorSessionTime(_ session: DoctorSession) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMM, HH:mm"
        return formatter.string(from: session.startTime)
    }
}

// MARK: - Mini Macro Dot

private struct MiniMacroDot: View {
    let label: String
    let value: Double
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.alcheOverlineTiny)
                .foregroundStyle(color)

            Text("\(Int(value))g")
                .font(.alcheCaption)
                .foregroundStyle(Color.alchePrimaryText)
        }
        .frame(width: 36)
        .padding(.vertical, AlcheSpacing.xs)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(AppState())
}
