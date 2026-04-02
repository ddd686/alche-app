import SwiftUI
import CoreImage.CIFilterBuiltins

struct InStoreView: View {
    @State private var viewModel = InStoreViewModel()
    @State private var sessionTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AlcheSpacing.lg) {
                    // Membership card
                    if let membership = viewModel.membership {
                        MembershipCardView(
                            membership: membership,
                            userName: "Lena M." // TODO: Wire to user profile
                        )
                    }

                    // Active session
                    if let session = viewModel.activeSession {
                        ActiveSessionCard(session: session)
                            .onReceive(sessionTimer) { _ in
                                // Force view update for countdown
                            }
                    }

                    // QR Check-in
                    if !viewModel.isCheckedIn {
                        if let qrCode = viewModel.qrCodeString {
                            QRCheckInCard(qrCode: qrCode)
                        } else {
                            NoBookingCard()
                        }
                    }

                    // Quick actions
                    VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                        Text("QUICK ACTIONS")
                            .font(.overline)
                            .foregroundStyle(Color.alcheSecondaryText)

                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: AlcheSpacing.md) {
                            QuickAction(
                                icon: "cup.and.saucer",
                                title: "Order Smoothie",
                                subtitle: "From your seat"
                            ) {
                                viewModel.orderFromSeat()
                            }

                            NavigationLink {
                                BookingListView()
                            } label: {
                                QuickActionContent(
                                    icon: "light.max",
                                    title: "Book Session",
                                    subtitle: "LED light ritual"
                                )
                            }
                            .buttonStyle(.plain)

                            QuickAction(
                                icon: "person.crop.circle",
                                title: "My Credits",
                                subtitle: "\(viewModel.creditsRemaining) remaining"
                            ) {
                                // TODO: Navigate to membership
                            }

                            QuickAction(
                                icon: "calendar",
                                title: "Events",
                                subtitle: "What's on"
                            ) {
                                // TODO: Navigate to events
                            }
                        }
                    }

                    // Membership status
                    HStack(spacing: AlcheSpacing.md) {
                        Image(systemName: "creditcard")
                            .foregroundStyle(Color.alchePrimary)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(viewModel.membershipTierName) Member")
                                .font(.alcheBodyMedium)
                                .foregroundStyle(Color.alchePrimaryText)
                            Text("\(viewModel.creditsRemaining) LED credits this month")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                        }

                        Spacer()
                    }
                    .padding(AlcheSpacing.md)
                    .background(Color.alcheSurface)
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                }
                .padding(.horizontal, AlcheSpacing.lg)
                .padding(.top, AlcheSpacing.md)
            }
            .background(Color.alcheBackground)
            .navigationTitle("In-Store")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadInStoreState()
            }
        }
    }
}

// MARK: - Active Session Card

private struct ActiveSessionCard: View {
    let session: InStoreViewModel.ActiveSession

    var body: some View {
        VStack(spacing: AlcheSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text(session.booking.sessionType?.displayName ?? "Session")
                        .font(.alcheBodyMedium)
                        .foregroundStyle(Color.alchePrimaryText)
                    Text(session.isComplete ? "Session complete" : "In progress")
                        .font(.alcheCaption)
                        .foregroundStyle(session.isComplete ? Color.sage : Color.alchePrimary)
                }

                Spacer()

                // Countdown
                VStack(alignment: .trailing) {
                    Text(formattedRemaining)
                        .font(.displayL.monospacedDigit())
                        .foregroundStyle(session.isComplete ? Color.sage : Color.alchePrimaryText)
                    Text("remaining")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.alcheWarmGray)
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(session.isComplete ? Color.sage : Color.alchePrimary)
                        .frame(width: geo.size.width * session.progress, height: 6)
                        .animation(.linear(duration: 1), value: session.progress)
                }
            }
            .frame(height: 6)
        }
        .padding(AlcheSpacing.md)
        .background(Color.alchePrimary.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
        .overlay(
            RoundedRectangle(cornerRadius: AlcheRadii.md)
                .strokeBorder(Color.alchePrimary.opacity(0.15), lineWidth: 1)
        )
    }

    private var formattedRemaining: String {
        let minutes = session.remainingMinutes
        let seconds = session.remainingSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - QR Check-In Card

private struct QRCheckInCard: View {
    let qrCode: String

    var body: some View {
        VStack(spacing: AlcheSpacing.md) {
            Text("CHECK IN")
                .font(.overline)
                .foregroundStyle(Color.alcheSecondaryText)

            if let qrImage = generateQRCode(from: qrCode) {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .padding(AlcheSpacing.md)
                    .background(Color.alcheWhite)
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
            }

            Text("Show this at the entrance")
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheSecondaryText)

            Text(qrCode)
                .font(.alcheMono)
                .foregroundStyle(Color.alcheSecondaryText.opacity(0.6))
        }
        .padding(AlcheSpacing.lg)
        .frame(maxWidth: .infinity)
        .background(Color.alcheWarmGray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"

        guard let outputImage = filter.outputImage else { return nil }
        let scale = 8.0
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

// MARK: - No Booking Card

private struct NoBookingCard: View {
    var body: some View {
        VStack(spacing: AlcheSpacing.md) {
            Image(systemName: "calendar.badge.plus")
                .font(.title)
                .foregroundStyle(Color.alcheSecondaryText.opacity(0.4))

            Text("No upcoming booking")
                .font(.alcheSubheading)
                .foregroundStyle(Color.alcheSecondaryText)

            Text("Book a session to get your check-in code.")
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheSecondaryText.opacity(0.7))
        }
        .padding(AlcheSpacing.lg)
        .frame(maxWidth: .infinity)
        .background(Color.alcheWarmGray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
    }
}

// MARK: - Quick Action

private struct QuickAction: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            QuickActionContent(icon: icon, title: title, subtitle: subtitle)
        }
        .buttonStyle(.plain)
    }
}

private struct QuickActionContent: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: AlcheSpacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.alchePrimary)

            VStack(spacing: 2) {
                Text(title)
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alchePrimaryText)

                Text(subtitle)
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AlcheSpacing.md)
        .background(Color.alcheSurface)
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
    }
}

#Preview {
    InStoreView()
}
