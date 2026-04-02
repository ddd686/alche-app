import SwiftUI

struct SessionBookingView: View {
    @State private var viewModel: SessionBookingViewModel
    let preselectedSessionType: SessionType?

    init(practitioner: Practitioner, preselectedSessionType: SessionType? = nil) {
        self._viewModel = State(initialValue: SessionBookingViewModel(practitioner: practitioner))
        self.preselectedSessionType = preselectedSessionType
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                // Practitioner mini header
                HStack(spacing: AlcheSpacing.md) {
                    AlcheAvatar(
                        initials: practitionerInitials,
                        size: 44
                    )

                    VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                        Text(viewModel.practitioner.name)
                            .font(.alcheBodyMedium)
                            .foregroundStyle(Color.alchePrimaryText)

                        if let sessionType = viewModel.selectedSessionType {
                            Text(sessionType.name)
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Session type selection
                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("SESSION TYPE")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(0.8)
                        .padding(.horizontal, AlcheSpacing.lg)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AlcheSpacing.sm) {
                            ForEach(viewModel.sessionTypes) { type in
                                Button {
                                    viewModel.selectSessionType(type)
                                } label: {
                                    VStack(spacing: AlcheSpacing.xs) {
                                        Text(type.name)
                                            .font(.alcheCaption)
                                            .foregroundStyle(
                                                viewModel.selectedSessionType?.id == type.id
                                                    ? Color.alcheWhite
                                                    : Color.alchePrimaryText
                                            )
                                        Text(type.formattedDuration)
                                            .font(.alcheCaption)
                                            .foregroundStyle(
                                                viewModel.selectedSessionType?.id == type.id
                                                    ? Color.alcheWhite.opacity(0.8)
                                                    : Color.alcheSecondaryText
                                            )
                                    }
                                    .padding(.horizontal, AlcheSpacing.md)
                                    .padding(.vertical, AlcheSpacing.sm)
                                    .background(
                                        viewModel.selectedSessionType?.id == type.id
                                            ? Color.alchePrimary
                                            : Color.alcheWarmGray.opacity(0.5)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, AlcheSpacing.lg)
                    }
                }

                // Week navigator
                HStack {
                    Button {
                        viewModel.navigateWeek(forward: false)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.alcheBody)
                            .foregroundStyle(
                                viewModel.canNavigateBack
                                    ? Color.alchePrimary
                                    : Color.alcheSecondaryText.opacity(0.3)
                            )
                    }
                    .disabled(!viewModel.canNavigateBack)

                    Spacer()

                    Text(viewModel.formattedWeekRange)
                        .font(.alcheBodyMedium)
                        .foregroundStyle(Color.alchePrimaryText)

                    Spacer()

                    Button {
                        viewModel.navigateWeek(forward: true)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.alcheBody)
                            .foregroundStyle(Color.alchePrimary)
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Day columns (Mon-Fri)
                if viewModel.isLoading {
                    ProgressView()
                        .tint(Color.alchePrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AlcheSpacing.xl)
                } else {
                    HStack(alignment: .top, spacing: AlcheSpacing.xs) {
                        ForEach(viewModel.weekDays) { day in
                            DayColumn(
                                day: day,
                                selectedSlot: viewModel.selectedSlot,
                                onSelectSlot: { slot in
                                    viewModel.selectSlot(slot)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }

                // Selected slot summary
                if let slot = viewModel.selectedSlot {
                    AlcheCard(shadow: .medium) {
                        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                            Text("SELECTED TIME")
                                .font(.alcheOverline)
                                .foregroundStyle(Color.alcheSecondaryText)
                                .tracking(0.8)

                            HStack {
                                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                                    Text(formattedSlotDate(slot))
                                        .font(.alcheBodyMedium)
                                        .foregroundStyle(Color.alcheEditorialBlack)

                                    Text(slot.formattedTimeRange)
                                        .font(.alcheCaption)
                                        .foregroundStyle(Color.alcheSecondaryText)
                                }

                                Spacer()

                                if viewModel.canUseComplimentary {
                                    VStack(alignment: .trailing, spacing: AlcheSpacing.xs) {
                                        Text("Included in Membership")
                                            .font(.alcheCaption)
                                            .foregroundStyle(Color.alcheSage)
                                    }
                                } else if let sessionType = viewModel.selectedSessionType {
                                    Text(sessionType.formattedPrice)
                                        .font(.alcheSubheading)
                                        .foregroundStyle(Color.alchePrimary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }

                // Complimentary badge
                if viewModel.canUseComplimentary {
                    HStack(spacing: AlcheSpacing.sm) {
                        Image(systemName: "star.circle.fill")
                            .foregroundStyle(Color.alchePrimary)
                        Text("Included in your membership")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alchePrimary)
                    }
                    .padding(AlcheSpacing.md)
                    .frame(maxWidth: .infinity)
                    .background(Color.alchePrimary.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    .padding(.horizontal, AlcheSpacing.lg)
                }

                // Error message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheError)
                        .padding(.horizontal, AlcheSpacing.lg)
                }

                // Confirm booking button
                if viewModel.canConfirmBooking {
                    Button {
                        Task {
                            await viewModel.confirmBooking()
                        }
                    } label: {
                        HStack {
                            if viewModel.isBooking {
                                ProgressView()
                                    .tint(Color.alcheWhite)
                                    .scaleEffect(0.8)
                            }
                            Text("Confirm Booking")
                                .font(.alcheBodyMedium)
                        }
                        .foregroundStyle(Color.alcheWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.alchePrimary)
                        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    }
                    .disabled(viewModel.isBooking)
                    .padding(.horizontal, AlcheSpacing.lg)
                }

                // Disclaimer
                Text("Sessions are for wellness guidance and lifestyle optimization. They do not constitute medical advice, diagnosis, or treatment.")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AlcheSpacing.xl)

                DataSourceIndicator(isMock: true)
            }
            .padding(.top, AlcheSpacing.md)
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Book Session")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showConfirmation) {
            if let booking = viewModel.lastBooking {
                BookingConfirmationSheet(
                    booking: booking,
                    practitionerName: viewModel.practitioner.name,
                    sessionTypeName: viewModel.selectedSessionType?.name ?? "Session"
                )
            }
        }
        .task {
            if let preselected = preselectedSessionType {
                viewModel.selectSessionType(preselected)
            }
            await viewModel.loadInitialData()
        }
    }

    private var practitionerInitials: String {
        let parts = viewModel.practitioner.name
            .replacingOccurrences(of: "Dr. ", with: "")
            .split(separator: " ")
        let first = parts.first?.prefix(1) ?? ""
        let last = parts.count > 1 ? parts.last?.prefix(1) ?? "" : ""
        return "\(first)\(last)"
    }

    private func formattedSlotDate(_ slot: PractitionerAvailability) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: slot.date)
    }
}

// MARK: - Day Column

private struct DayColumn: View {
    let day: SessionBookingViewModel.WeekDay
    let selectedSlot: PractitionerAvailability?
    let onSelectSlot: (PractitionerAvailability) -> Void

    var body: some View {
        VStack(spacing: AlcheSpacing.sm) {
            // Day label
            VStack(spacing: 2) {
                Text(day.dayLabel)
                    .font(.alcheCaption)
                    .foregroundStyle(day.isToday ? Color.alchePrimary : Color.alcheSecondaryText)

                Text(day.dateLabel)
                    .font(.alcheBodyMedium)
                    .foregroundStyle(day.isToday ? Color.alchePrimary : Color.alchePrimaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AlcheSpacing.xs)
            .background(day.isToday ? Color.alchePrimary.opacity(0.06) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))

            // Slots
            if day.slots.isEmpty {
                Text("--")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText.opacity(0.3))
                    .padding(.vertical, AlcheSpacing.sm)
            } else {
                ForEach(day.slots) { slot in
                    SlotCell(
                        slot: slot,
                        isSelected: selectedSlot?.id == slot.id,
                        isPastDay: day.isPast,
                        onTap: { onSelectSlot(slot) }
                    )
                }
            }
        }
    }
}

// MARK: - Slot Cell

private struct SlotCell: View {
    let slot: PractitionerAvailability
    let isSelected: Bool
    let isPastDay: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(slot.formattedStartTime)
                .font(.alcheCaption)
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AlcheSpacing.sm)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
                .overlay(
                    RoundedRectangle(cornerRadius: AlcheRadii.sm)
                        .strokeBorder(borderColor, lineWidth: isSelected ? 2 : 1)
                )
        }
        .buttonStyle(.plain)
        .disabled(!slot.isAvailable || isPastDay)
    }

    private var foregroundColor: Color {
        if isSelected {
            return Color.alcheWhite
        } else if !slot.isAvailable || isPastDay {
            return Color.alcheSecondaryText.opacity(0.4)
        } else {
            return Color.alchePrimaryText
        }
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.alchePrimary
        } else if !slot.isAvailable || isPastDay {
            return Color.alcheWarmGray.opacity(0.4)
        } else {
            return Color.clear
        }
    }

    private var borderColor: Color {
        if isSelected {
            return Color.alchePrimary
        } else if !slot.isAvailable || isPastDay {
            return Color.alcheSecondaryText.opacity(0.2)
        } else {
            return Color.alchePrimary.opacity(0.4)
        }
    }
}

// MARK: - Booking Confirmation Sheet

private struct BookingConfirmationSheet: View {
    @Environment(\.dismiss) private var dismiss
    let booking: DoctorSession
    let practitionerName: String
    let sessionTypeName: String

    var body: some View {
        VStack(spacing: AlcheSpacing.xl) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.alcheSage)

            VStack(spacing: AlcheSpacing.sm) {
                Text("Session Booked")
                    .font(.alcheDisplayL)
                    .foregroundStyle(Color.alcheEditorialBlack)

                Text(practitionerName)
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alcheEditorialBlack)

                Text(sessionTypeName)
                    .font(.alcheBody)
                    .foregroundStyle(Color.alcheSecondaryText)

                Text(booking.formattedDate)
                    .font(.alcheBody)
                    .foregroundStyle(Color.alcheSecondaryText)

                Text(booking.formattedTime)
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alchePrimary)

                if booking.isComplimentary {
                    HStack(spacing: AlcheSpacing.xs) {
                        Image(systemName: "star.circle.fill")
                            .font(.alcheCaption)
                        Text("Included in Membership")
                            .font(.alcheCaption)
                    }
                    .foregroundStyle(Color.alcheSage)
                    .padding(.top, AlcheSpacing.xs)
                }
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
}

#Preview {
    NavigationStack {
        SessionBookingView(practitioner: .preview)
    }
}
