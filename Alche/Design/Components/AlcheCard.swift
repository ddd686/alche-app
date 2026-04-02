import SwiftUI

// MARK: - Card Variant

enum CardVariant {
    /// Hard drop shadow (4px 4px 0), 1px border editorial-black/10
    case `default`
    /// No shadow, 1px border editorial-black/10
    case flat
    /// 6px shadow, full 1px border editorial-black/20
    case elevated
    /// No border, no shadow — transparent chrome
    case ghost
}

// MARK: - Card Component

struct AlcheCard<Content: View>: View {
    let variant: CardVariant
    @ViewBuilder let content: () -> Content

    init(
        variant: CardVariant = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.variant = variant
        self.content = content
    }

    /// Legacy initializer for backward compatibility — requires explicit shadow argument
    init(
        shadow: AlcheShadow,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.variant = .default
        self.content = content
    }

    var body: some View {
        content()
            .padding(AlcheSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
            .overlay(cardBorder)
            .shadow(
                color: shadowColor,
                radius: 0,
                x: shadowOffset,
                y: shadowOffset
            )
    }

    // MARK: - Variant Styling

    private var cardBackground: Color {
        switch variant {
        case .default, .flat, .elevated:
            Color.alcheWhite
        case .ghost:
            Color.clear
        }
    }

    @ViewBuilder
    private var cardBorder: some View {
        switch variant {
        case .default, .flat:
            RoundedRectangle(cornerRadius: AlcheRadii.md)
                .stroke(Color.alcheEditorialBlack.opacity(0.10), lineWidth: 1)
        case .elevated:
            RoundedRectangle(cornerRadius: AlcheRadii.md)
                .stroke(Color.alcheEditorialBlack.opacity(0.20), lineWidth: 1)
        case .ghost:
            EmptyView()
        }
    }

    private var shadowColor: Color {
        switch variant {
        case .default:
            AlcheShadow.medium.color
        case .elevated:
            AlcheShadow.strong.color
        case .flat, .ghost:
            Color.clear
        }
    }

    private var shadowOffset: CGFloat {
        switch variant {
        case .default: 4
        case .elevated: 6
        case .flat, .ghost: 0
        }
    }
}

// MARK: - Preview

#Preview("Cards") {
    ScrollView {
        VStack(spacing: AlcheSpacing.lg) {
            AlcheCard(variant: .default) {
                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("Default Card")
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alcheEditorialBlack)
                    Text("Hard drop shadow, 1px border")
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheEditorialMuted)
                    Text("Editorial Longevity")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alchePrimary)
                }
            }

            AlcheCard(variant: .flat) {
                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("Flat Card")
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alcheEditorialBlack)
                    Text("No shadow, just border")
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheEditorialMuted)
                }
            }

            AlcheCard(variant: .elevated) {
                HStack {
                    VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                        Text("Biological Age")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheEditorialMuted)
                            .textCase(.uppercase)
                        Text("28")
                            .font(.alcheMonoLarge)
                            .foregroundStyle(Color.alchePrimary)
                    }
                    Spacer()
                    Image(systemName: "arrow.down.right")
                        .font(.title2)
                        .foregroundStyle(Color.alchePastelSage)
                }
            }

            AlcheCard(variant: .ghost) {
                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("Ghost Card")
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alcheEditorialBlack)
                    Text("No border, no shadow")
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheEditorialMuted)
                }
            }
        }
        .padding(AlcheSpacing.md)
    }
    .background(Color.alcheBackground)
}
