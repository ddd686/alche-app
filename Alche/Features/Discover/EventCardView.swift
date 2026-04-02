import SwiftUI

struct EventCardView: View {
    let event: Event
    let isRSVPd: Bool

    var body: some View {
        AlcheCard {
            VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                HStack(alignment: .top) {
                    // Date badge
                    VStack(spacing: 2) {
                        Text(monthString)
                            .font(.alcheOverline)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.alchePrimary)
                        Text(dayString)
                            .font(.alcheDisplayL)
                            .foregroundStyle(Color.alcheEditorialBlack)
                    }
                    .frame(width: 54, height: 54)
                    .background(Color.alcheWarmGray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))

                    VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                        if let type = event.eventType {
                            AlcheTag(text: type.displayName, color: eventColor(type))
                        }

                        Text(event.title)
                            .font(.alcheSubheading)
                            .foregroundStyle(Color.alcheEditorialBlack)
                            .lineLimit(2)

                        Text(timeString)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }

                    Spacer()
                }

                if let description = event.description {
                    Text(description)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .lineLimit(2)
                }

                HStack {
                    // Location
                    if let location = event.location {
                        HStack(spacing: AlcheSpacing.xs) {
                            Image(systemName: "mappin")
                                .font(.alcheOverline)
                            Text(location)
                                .font(.alcheCaption)
                        }
                        .foregroundStyle(Color.alcheSecondaryText)
                    }

                    Spacer()

                    // Capacity
                    if let spots = event.spotsRemaining {
                        Text(spots == 0 ? "Full" : "\(spots) spots left")
                            .font(.alcheCaption)
                            .foregroundStyle(spots == 0 ? Color.alcheError : Color.alcheSage)
                    }
                }

                // RSVP indicator
                if isRSVPd {
                    HStack(spacing: AlcheSpacing.xs) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.alcheSage)
                        Text("You're going")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSage)
                    }
                }
            }
        }
    }

    // MARK: - Formatting

    private var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: event.eventDate)
    }

    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: event.eventDate)
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, HH:mm"
        return formatter.string(from: event.eventDate)
    }

    private func eventColor(_ type: EventType) -> Color {
        switch type {
        case .salon: .alchePrimary
        case .workshop: .alcheAmber
        case .community: .alcheSage
        }
    }
}

#Preview {
    EventCardView(event: .preview, isRSVPd: false)
        .padding()
        .background(Color.alcheBackground)
}
