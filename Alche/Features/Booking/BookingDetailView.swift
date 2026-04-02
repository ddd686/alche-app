import SwiftUI

struct BookingDetailView: View {
    let booking: Booking
    @Bindable var viewModel: BookingViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showCancelAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                // Status header
                VStack(spacing: AlcheSpacing.sm) {
                    Image(systemName: statusIcon)
                        .font(.system(size: 48))
                        .foregroundStyle(statusColor)

                    Text(statusText)
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)

                    Text(booking.sessionType?.displayName ?? booking.serviceType.displayName)
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
                .padding(.top, AlcheSpacing.lg)

                // Details card
                VStack(spacing: AlcheSpacing.md) {
                    DetailRow(icon: "calendar", label: "Date", value: formattedDate(booking.slotStart))
                    Divider().foregroundStyle(Color.alcheWarmGray)
                    DetailRow(icon: "clock", label: "Time", value: formattedTime(booking.slotStart, booking.slotEnd))
                    Divider().foregroundStyle(Color.alcheWarmGray)
                    DetailRow(icon: "timer", label: "Duration", value: "\(booking.durationMinutes) minutes")

                    if booking.creditsUsed > 0 {
                        Divider().foregroundStyle(Color.alcheWarmGray)
                        DetailRow(icon: "creditcard", label: "Credits Used", value: "\(booking.creditsUsed)")
                    }
                }
                .padding(AlcheSpacing.md)
                .background(Color.alcheSurface)
                .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))

                // QR Code section
                if booking.status == .confirmed, let qrCode = booking.qrCode {
                    NavigationLink {
                        QRCheckInView(booking: booking)
                    } label: {
                        HStack(spacing: AlcheSpacing.md) {
                            Image(systemName: "qrcode")
                                .font(.title2)
                                .foregroundStyle(Color.alchePrimary)

                            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                                Text("Check-in QR Code")
                                    .font(.alcheBodyMedium)
                                    .foregroundStyle(Color.alchePrimaryText)
                                Text(qrCode)
                                    .font(.alcheMono)
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                        }
                        .padding(AlcheSpacing.md)
                        .background(Color.alchePrimary.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    }
                    .buttonStyle(.plain)
                }

                // Smoothie pre-order info
                if booking.smoothiePreorderId != nil {
                    HStack(spacing: AlcheSpacing.md) {
                        Image(systemName: "cup.and.saucer.fill")
                            .foregroundStyle(Color.alcheSuccess)
                        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                            Text("Smoothie pre-ordered")
                                .font(.alcheBodyMedium)
                                .foregroundStyle(Color.alchePrimaryText)
                            Text("It will be ready when your session ends.")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                        }
                        Spacer()
                    }
                    .padding(AlcheSpacing.md)
                    .background(Color.alcheSuccess.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                }

                // Cancel button
                if booking.isUpcoming {
                    Button(role: .destructive) {
                        showCancelAlert = true
                    } label: {
                        Text("Cancel Booking")
                            .font(.alcheSubheading)
                            .foregroundStyle(Color.alcheError)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.alcheError.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    }
                }
            }
            .padding(.horizontal, AlcheSpacing.lg)
        }
        .background(Color.alcheBackground)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Cancel Booking", isPresented: $showCancelAlert) {
            Button("Keep Booking", role: .cancel) {}
            Button("Cancel", role: .destructive) {
                Task {
                    await viewModel.cancelBooking(booking)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to cancel this session? Your credit will be returned.")
        }
    }

    // MARK: - Status Helpers

    private var statusIcon: String {
        switch booking.status {
        case .confirmed: "calendar.badge.checkmark"
        case .checkedIn: "person.crop.circle.badge.checkmark"
        case .completed: "checkmark.circle.fill"
        case .cancelled: "xmark.circle"
        case .noShow: "exclamationmark.circle"
        }
    }

    private var statusColor: Color {
        switch booking.status {
        case .confirmed: Color.alcheSuccess
        case .checkedIn: Color.alchePrimary
        case .completed: Color.alcheSuccess
        case .cancelled: Color.alcheSecondaryText
        case .noShow: Color.alcheError
        }
    }

    private var statusText: String {
        switch booking.status {
        case .confirmed: "Confirmed"
        case .checkedIn: "Checked In"
        case .completed: "Completed"
        case .cancelled: "Cancelled"
        case .noShow: "Missed"
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM yyyy"
        return formatter.string(from: date)
    }

    private func formattedTime(_ start: Date, _ end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: start)) – \(formatter.string(from: end))"
    }
}

// MARK: - Detail Row

private struct DetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: AlcheSpacing.md) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(Color.alcheSecondaryText)

            Text(label)
                .font(.alcheSubheading)
                .foregroundStyle(Color.alcheSecondaryText)

            Spacer()

            Text(value)
                .font(.alcheBodyMedium)
                .foregroundStyle(Color.alchePrimaryText)
        }
    }
}

#Preview {
    NavigationStack {
        BookingDetailView(booking: .preview, viewModel: BookingViewModel())
    }
}
