import SwiftUI

struct EventDetailView: View {
    let event: Event
    let isRSVPd: Bool
    var onRSVP: () async -> Void = {}
    var onCancelRSVP: () async -> Void = {}

    @State private var isProcessing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                // Hero placeholder
                RoundedRectangle(cornerRadius: AlcheRadii.lg)
                    .fill(eventGradient)
                    .frame(height: 200)
                    .overlay(
                        VStack {
                            Image(systemName: "sparkles")
                                .font(.system(size: 48))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    )

                VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                    // Type tag
                    if let type = event.eventType {
                        AlcheTag(text: type.displayName, color: eventColor(type))
                    }

                    // Title
                    Text(event.title)
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)

                    // Date & time
                    HStack(spacing: AlcheSpacing.sm) {
                        Image(systemName: "calendar")
                            .foregroundStyle(Color.alchePrimary)
                        Text(formattedDate)
                            .font(.alcheBody)
                            .foregroundStyle(Color.alchePrimaryText)
                    }

                    // Location
                    if let location = event.location {
                        HStack(spacing: AlcheSpacing.sm) {
                            Image(systemName: "mappin")
                                .foregroundStyle(Color.alchePrimary)
                            Text(location)
                                .font(.alcheBody)
                                .foregroundStyle(Color.alchePrimaryText)
                        }
                    }

                    // Capacity
                    if let capacity = event.capacity {
                        HStack(spacing: AlcheSpacing.sm) {
                            Image(systemName: "person.2")
                                .foregroundStyle(Color.alchePrimary)
                            Text("\(event.rsvpCount)/\(capacity) attending")
                                .font(.alcheBody)
                                .foregroundStyle(Color.alchePrimaryText)

                            if let spots = event.spotsRemaining, spots <= 5 && spots > 0 {
                                Text("Only \(spots) left")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheAmber)
                            }
                        }
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)

                Divider()
                    .background(Color.alcheWarmGray)
                    .padding(.horizontal, AlcheSpacing.lg)

                // Description
                if let description = event.description {
                    Text(description)
                        .font(.alcheBody)
                        .foregroundStyle(Color.alchePrimaryText)
                        .lineSpacing(4)
                        .padding(.horizontal, AlcheSpacing.lg)
                }

                Spacer(minLength: AlcheSpacing.xxl)
            }
            .padding(.top, AlcheSpacing.md)
        }
        .background(Color.alcheBackground)
        .safeAreaInset(edge: .bottom) {
            VStack {
                if isRSVPd {
                    VStack(spacing: AlcheSpacing.sm) {
                        HStack(spacing: AlcheSpacing.sm) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.alcheSage)
                            Text("You're going")
                                .font(.alcheBodyMedium)
                                .foregroundStyle(Color.alcheSage)
                        }

                        AlcheButton("Cancel RSVP", style: .ghost, isLoading: isProcessing) {
                            Task {
                                isProcessing = true
                                await onCancelRSVP()
                                isProcessing = false
                            }
                        }
                    }
                } else if event.isFull {
                    AlcheButton("Join waitlist", style: .secondary) {}
                } else {
                    AlcheButton("RSVP", icon: "checkmark", isLoading: isProcessing) {
                        Task {
                            isProcessing = true
                            await onRSVP()
                            isProcessing = false
                        }
                    }
                }
            }
            .padding(AlcheSpacing.lg)
            .background(.ultraThinMaterial)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy 'at' HH:mm"
        return formatter.string(from: event.eventDate)
    }

    private var eventGradient: LinearGradient {
        let base: Color = switch event.eventType {
        case .salon: .alchePrimary
        case .workshop: .alcheAmber
        case .community: .alcheSage
        case .none: .alcheEditorialMuted
        }
        return LinearGradient(
            colors: [base.opacity(0.4), base.opacity(0.15)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
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
    NavigationStack {
        EventDetailView(event: .preview, isRSVPd: false)
    }
}
