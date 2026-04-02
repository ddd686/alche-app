import SwiftUI

struct BookingListView: View {
    @State private var viewModel = BookingViewModel()
    @State private var showNewBooking = false

    // Date selector: 7 days starting today
    private var weekDates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AlcheSpacing.xl) {

                    // MARK: - Editorial Header

                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("BOOK A SESSION")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)

                        Text("Red Light Therapy")
                            .font(.alcheDisplayXL)
                            .foregroundStyle(Color.alchePrimaryText)

                        Text("Reserve your LED session and step into the light. Glow or Recovery — choose your path.")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .lineLimit(2)
                    }
                    .padding(.top, AlcheSpacing.xl)

                    // MARK: - Upcoming Bookings

                    if !viewModel.upcomingBookings.isEmpty {
                        VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                            Text("UPCOMING")
                                .font(.alcheOverline)
                                .foregroundStyle(Color.alcheSecondaryText)

                            ForEach(viewModel.upcomingBookings) { booking in
                                NavigationLink {
                                    BookingDetailView(booking: booking, viewModel: viewModel)
                                } label: {
                                    UpcomingBookingCard(booking: booking)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    } else {
                        VStack(spacing: AlcheSpacing.md) {
                            Image(systemName: "calendar")
                                .font(.largeTitle)
                                .foregroundStyle(Color.alcheSecondaryText.opacity(0.4))

                            Text("No upcoming bookings")
                                .font(.alcheSubheading)
                                .foregroundStyle(Color.alcheSecondaryText)

                            Text("Book a session below to get started.")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AlcheSpacing.lg)
                    }

                    // MARK: - Wellness Sessions CTA (Doctor Sessions)

                    NavigationLink {
                        PractitionerListView()
                    } label: {
                        HStack(spacing: AlcheSpacing.md) {
                            Image(systemName: "stethoscope")
                                .font(.title2)
                                .foregroundStyle(Color.alchePrimary)
                                .frame(width: 44, height: 44)
                                .background(Color.alchePrimary.opacity(0.06))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                                Text("Wellness Sessions")
                                    .font(.alcheBodyMedium)
                                    .foregroundStyle(Color.alcheEditorialBlack)
                                Text("Book a 1-on-1 with a longevity practitioner")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                        }
                        .padding(AlcheSpacing.md)
                        .background(Color.alcheSurface)
                        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                        .overlay(
                            RoundedRectangle(cornerRadius: AlcheRadii.md)
                                .stroke(Color.alcheEditorialBlack.opacity(0.10), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    // MARK: - Session Type Selection

                    VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                        Text("SESSION TYPE")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)

                        HStack(spacing: AlcheSpacing.sm) {
                            ForEach(LEDSessionType.allCases, id: \.self) { type in
                                SessionTypeCard(
                                    type: type,
                                    isSelected: viewModel.selectedSessionType == type
                                ) {
                                    viewModel.selectedSessionType = type
                                }
                            }
                        }
                    }

                    // MARK: - Date Selector (Horizontal Scroll)

                    VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                        Text("SELECT DATE")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AlcheSpacing.md) {
                                ForEach(weekDates, id: \.self) { date in
                                    DayButton(
                                        date: date,
                                        isSelected: Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
                                    ) {
                                        viewModel.selectedDate = date
                                        Task {
                                            await viewModel.loadAvailableSlots()
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // MARK: - Time Slots (Vertical List)

                    VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                        Text("AVAILABLE TIMES")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)

                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .tint(Color.alchePrimary)
                                Spacer()
                            }
                            .padding(.vertical, AlcheSpacing.xl)
                        } else if viewModel.availableSlots.isEmpty {
                            VStack(spacing: AlcheSpacing.sm) {
                                Image(systemName: "calendar.badge.exclamationmark")
                                    .font(.title)
                                    .foregroundStyle(Color.alcheSecondaryText)

                                Text("No slots available for this date.")
                                    .font(.alcheBody)
                                    .foregroundStyle(Color.alcheSecondaryText)

                                Text("Try another day or check back later.")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSecondaryText.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AlcheSpacing.xl)
                        } else {
                            VStack(spacing: AlcheSpacing.sm) {
                                ForEach(viewModel.availableSlots) { slot in
                                    TimeSlotRow(
                                        slot: slot,
                                        isSelected: viewModel.selectedSlot?.id == slot.id
                                    ) {
                                        if slot.isAvailable {
                                            viewModel.selectedSlot = slot
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // MARK: - Upsell + CTA

                    if viewModel.selectedSlot != nil {
                        VStack(spacing: AlcheSpacing.md) {
                            // Smoothie toggle
                            Toggle(isOn: $viewModel.wantsPreOrder) {
                                HStack(spacing: AlcheSpacing.sm) {
                                    Image(systemName: "cup.and.saucer")
                                        .foregroundStyle(Color.alchePrimary)
                                    Text("Pre-order a smoothie?")
                                        .font(.alcheSubheading)
                                        .foregroundStyle(Color.alchePrimaryText)
                                }
                            }
                            .tint(Color.alcheSage)
                            .padding(AlcheSpacing.md)
                            .background(Color.alcheSurface)
                            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                            .overlay(
                                RoundedRectangle(cornerRadius: AlcheRadii.md)
                                    .stroke(Color.alcheEditorialBlack.opacity(0.10), lineWidth: 1)
                            )

                            if viewModel.wantsPreOrder {
                                NavigationLink {
                                    SmoothieMenuView(viewModel: viewModel)
                                } label: {
                                    HStack {
                                        if let smoothie = viewModel.selectedSmoothie {
                                            Text(smoothie.name)
                                                .font(.alcheSubheading)
                                                .foregroundStyle(Color.alchePrimaryText)
                                            Spacer()
                                            Text(smoothie.formattedPrice)
                                                .font(.alcheCaption)
                                                .foregroundStyle(Color.alchePrimary)
                                        } else {
                                            Text("Choose your smoothie")
                                                .font(.alcheSubheading)
                                                .foregroundStyle(Color.alcheSecondaryText)
                                            Spacer()
                                        }
                                        Image(systemName: "chevron.right")
                                            .font(.alcheCaption)
                                            .foregroundStyle(Color.alcheSecondaryText)
                                    }
                                    .padding(AlcheSpacing.md)
                                    .background(Color.alcheSurface)
                                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AlcheRadii.md)
                                            .stroke(Color.alcheEditorialBlack.opacity(0.10), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                            }

                            // Confirm button — full width, primary
                            Button {
                                Task {
                                    await viewModel.confirmBooking()
                                }
                            } label: {
                                HStack(spacing: AlcheSpacing.sm) {
                                    Text("Confirm")
                                        .font(.alcheBodyMedium)
                                    Text("\u{00B7}")
                                    Text("1 credit")
                                        .font(.alcheCaption)
                                    if viewModel.preOrderTotal > 0 {
                                        Text("+ \(formattedPrice(viewModel.preOrderTotal))")
                                            .font(.alcheCaption)
                                    }
                                }
                                .foregroundStyle(Color.alcheWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.alchePrimary)
                                .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                            }
                            .disabled(viewModel.isLoading)

                            // Cancellation note
                            Text("Free cancellation up to 2 hours before your session.")
                                .font(.alcheCaption)
                                .italic()
                                .foregroundStyle(Color.alcheSecondaryText)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheError)
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)
                .padding(.bottom, AlcheSpacing.xl)
            }
            .background(Color.alcheBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $viewModel.showConfirmation) {
                if let booking = viewModel.lastBooking {
                    BookingConfirmationSheet(booking: booking)
                }
            }
            .task {
                await viewModel.loadUpcomingBookings()
                await viewModel.loadAvailableSlots()
            }
        }
    }

    private func formattedPrice(_ cents: Int) -> String {
        let euros = Double(cents) / 100.0
        return String(format: "EUR %.2f", euros)
    }
}

// MARK: - Day Button (Horizontal Date Selector)

private struct DayButton: View {
    let date: Date
    let isSelected: Bool
    let action: () -> Void

    private var dayAbbreviation: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }

    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: AlcheSpacing.xs) {
                Text(dayAbbreviation)
                    .font(.alcheOverline)
                    .foregroundStyle(isSelected ? Color.alchePrimaryText : Color.alcheSecondaryText)

                Text(dayNumber)
                    .font(.alcheBody)
                    .fontWeight(isSelected ? .medium : .light)
                    .foregroundStyle(isSelected ? Color.alchePrimaryText : Color.alcheSecondaryText)
            }
            .frame(width: 44)
            .padding(.bottom, AlcheSpacing.sm)
            .overlay(alignment: .bottom) {
                if isSelected {
                    Rectangle()
                        .fill(Color.alchePrimary)
                        .frame(height: 2)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Time Slot Row (Vertical List)

private struct TimeSlotRow: View {
    let slot: BookingViewModel.TimeSlot
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    if slot.isAvailable {
                        Text(slot.formattedTime)
                            .font(.alcheOverline)
                            .foregroundStyle(isSelected ? Color.alchePrimary : Color.alchePrimaryText)
                    } else {
                        Text(slot.formattedTime)
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .strikethrough()
                    }

                    Text("30 mins")
                        .font(.alcheCaption)
                        .italic()
                        .foregroundStyle(isSelected ? Color.alchePrimary.opacity(0.7) : Color.alcheSecondaryText)
                }

                Spacer()

                if !slot.isAvailable {
                    Text("Booked")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                } else if slot.remainingCapacity <= 2 {
                    Text("\(slot.remainingCapacity) left")
                        .font(.alcheOverlineTiny)
                        .foregroundStyle(Color.alchePrimary)
                }
            }
            .padding(AlcheSpacing.md)
            .background(Color.alcheSurface)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
            .overlay(
                RoundedRectangle(cornerRadius: AlcheRadii.sm)
                    .stroke(Color.alcheEditorialBlack.opacity(slot.isAvailable ? 0.10 : 0.05), lineWidth: 1)
            )
            .overlay(alignment: .leading) {
                if isSelected {
                    Rectangle()
                        .fill(Color.alchePrimary)
                        .frame(width: 4)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                }
            }
            .alcheShadow(slot.isAvailable && !isSelected ? .subtle : .subtle)
            .shadow(color: isSelected ? .clear : AlcheShadow.subtle.color, radius: 0, x: AlcheShadow.subtle.x, y: AlcheShadow.subtle.y)
            .opacity(slot.isAvailable ? 1.0 : 0.4)
        }
        .buttonStyle(.plain)
        .disabled(!slot.isAvailable)
    }
}

// MARK: - Upcoming Booking Card

private struct UpcomingBookingCard: View {
    let booking: Booking

    var body: some View {
        HStack(spacing: AlcheSpacing.md) {
            Circle()
                .fill(booking.isUpcoming ? Color.alcheSuccess : Color.alcheSecondaryText.opacity(0.3))
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                Text(booking.sessionType?.displayName ?? booking.serviceType.displayName)
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alchePrimaryText)

                Text(formattedDateTime(booking.slotStart))
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: AlcheSpacing.xs) {
                Text("\(booking.durationMinutes) min")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)

                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(Color.alcheSecondaryText)
            }
        }
        .padding(AlcheSpacing.md)
        .background(Color.alcheSurface)
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
        .overlay(
            RoundedRectangle(cornerRadius: AlcheRadii.md)
                .stroke(Color.alcheEditorialBlack.opacity(0.10), lineWidth: 1)
        )
        .alcheShadow(.subtle)
    }

    private func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E d MMM, HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Session Type Card

private struct SessionTypeCard: View {
    let type: LEDSessionType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: AlcheSpacing.sm) {
                Image(systemName: type == .glow ? "sparkles" : "heart.circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? Color.alchePrimary : Color.alcheSecondaryText)

                Text(type.displayName)
                    .font(.alcheBodyMedium)
                    .foregroundStyle(isSelected ? Color.alchePrimaryText : Color.alcheSecondaryText)

                Text(type.description)
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(AlcheSpacing.md)
            .background(isSelected ? Color.alchePrimary.opacity(0.06) : Color.alcheSurface)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
            .overlay(
                RoundedRectangle(cornerRadius: AlcheRadii.md)
                    .strokeBorder(isSelected ? Color.alchePrimary : Color.alcheEditorialBlack.opacity(0.10), lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Booking Confirmation Sheet

private struct BookingConfirmationSheet: View {
    @Environment(\.dismiss) private var dismiss
    let booking: Booking

    var body: some View {
        VStack(spacing: AlcheSpacing.xl) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.alcheSuccess)

            VStack(spacing: AlcheSpacing.sm) {
                Text("You're booked")
                    .font(.alcheDisplayL)
                    .foregroundStyle(Color.alchePrimaryText)

                Text("\(booking.sessionType?.displayName ?? "Session") on \(formattedDate(booking.slotStart))")
                    .font(.alcheBody)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .multilineTextAlignment(.center)
            }

            if let qrCode = booking.qrCode {
                Text("Check-in code: \(qrCode)")
                    .font(.alcheMono)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .padding(AlcheSpacing.sm)
                    .background(Color.alcheWarmGray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alcheWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.alchePrimary)
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
            }
        }
        .padding(AlcheSpacing.lg)
        .background(Color.alcheSurface)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM 'at' HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    BookingListView()
}
