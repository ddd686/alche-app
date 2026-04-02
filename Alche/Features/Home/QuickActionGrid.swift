import SwiftUI

struct QuickActionGrid: View {
    var onBookLED: () -> Void = {}
    var onOrderSmoothie: () -> Void = {}
    var onGlowScan: () -> Void = {}
    var onCheckIn: () -> Void = {}
    var onEatSmart: () -> Void = {}

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AlcheSpacing.md) {
                QuickActionButton(
                    icon: "light.max",
                    title: "Book LED",
                    color: .alchePrimary,
                    action: onBookLED
                )
                QuickActionButton(
                    icon: "cup.and.saucer",
                    title: "Smoothie",
                    color: .alcheSage,
                    action: onOrderSmoothie
                )
                QuickActionButton(
                    icon: "sparkles",
                    title: "Glow Scan",
                    color: .alcheAmber,
                    action: onGlowScan
                )
                QuickActionButton(
                    icon: "fork.knife",
                    title: "Eat Smart",
                    color: .alcheSage,
                    action: onEatSmart
                )
                QuickActionButton(
                    icon: "qrcode",
                    title: "Check In",
                    color: .alcheInfo,
                    action: onCheckIn
                )
            }
            .padding(.horizontal, AlcheSpacing.lg)
        }
    }
}

// MARK: - Quick Action Button

private struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: AlcheSpacing.sm) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)

                Text(title.uppercased())
                    .font(.alcheOverline)
                    .tracking(0.8)
                    .foregroundStyle(Color.alcheEditorialBlack)
            }
            .frame(width: 100, height: 100)
            .background(Color.alcheWhite)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
            .overlay(
                RoundedRectangle(cornerRadius: AlcheRadii.sm)
                    .stroke(Color.alcheEditorialBlack.opacity(0.10), lineWidth: 1)
            )
            .alcheShadow(.subtle)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    QuickActionGrid()
        .padding(.vertical)
        .background(Color.alcheBackground)
}
