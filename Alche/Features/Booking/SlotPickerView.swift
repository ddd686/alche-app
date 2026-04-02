import SwiftUI

struct SlotPickerView: View {
    @Bindable var viewModel: BookingViewModel

    private let columns = Array(repeating: GridItem(.flexible(), spacing: AlcheSpacing.sm), count: 4)

    var body: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.md) {
            HStack {
                Text("AVAILABLE TIMES")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText)

                Spacer()

                let available = viewModel.availableSlotsForSelection.count
                Text("\(available) slot\(available == 1 ? "" : "s") remaining")
                    .font(.alcheCaption)
                    .foregroundStyle(available <= 3 ? Color.alchePrimary : Color.alcheSecondaryText)
            }

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
                LazyVGrid(columns: columns, spacing: AlcheSpacing.sm) {
                    ForEach(viewModel.availableSlots) { slot in
                        SlotCell(
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
        .padding(AlcheSpacing.md)
        .background(Color.alcheSurface)
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
    }
}

// MARK: - Slot Cell

private struct SlotCell: View {
    let slot: BookingViewModel.TimeSlot
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text(slot.formattedTime)
                    .font(.alcheCaption)
                    .foregroundStyle(textColor)

                if slot.isAvailable && slot.remainingCapacity <= 2 {
                    Text("\(slot.remainingCapacity) left")
                        .font(.alcheOverlineTiny)
                        .foregroundStyle(Color.alchePrimary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AlcheSpacing.sm)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
            .overlay(
                RoundedRectangle(cornerRadius: AlcheRadii.sm)
                    .strokeBorder(isSelected ? Color.alchePrimary : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .disabled(!slot.isAvailable)
    }

    private var textColor: Color {
        if !slot.isAvailable { return Color.alcheSecondaryText.opacity(0.3) }
        if isSelected { return Color.alchePrimary }
        return Color.alchePrimaryText
    }

    private var backgroundColor: Color {
        if !slot.isAvailable { return Color.alcheWarmGray.opacity(0.3) }
        if isSelected { return Color.alchePrimary.opacity(0.06) }
        return Color.alcheSurface
    }
}

#Preview {
    let vm = BookingViewModel()
    SlotPickerView(viewModel: vm)
        .padding()
}
