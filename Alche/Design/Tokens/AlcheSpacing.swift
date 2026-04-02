import SwiftUI

enum AlcheSpacing {
    /// 4pt -- tight spacing, icon gaps
    static let xs: CGFloat = 4

    /// 8pt -- compact spacing, tag padding
    static let sm: CGFloat = 8

    /// 16pt -- default spacing, card padding
    static let md: CGFloat = 16

    /// 24pt -- section spacing
    static let lg: CGFloat = 24

    /// 32pt -- generous spacing between groups
    static let xl: CGFloat = 32

    /// 48pt -- hero spacing, page margins
    static let xxl: CGFloat = 48
}

// MARK: - Shadow Definitions (Editorial Longevity)

enum AlcheShadow {
    case subtle
    case medium
    case strong

    // Aliases
    static let small = AlcheShadow.subtle
    static let `default` = AlcheShadow.medium
    static let large = AlcheShadow.strong

    /// Horizontal offset -- always bottom-right
    var x: CGFloat {
        switch self {
        case .subtle: 2
        case .medium: 4
        case .strong: 6
        }
    }

    /// Vertical offset -- always bottom-right
    var y: CGFloat {
        switch self {
        case .subtle: 2
        case .medium: 4
        case .strong: 6
        }
    }

    /// Hard drop shadow -- radius is always 0 (no blur)
    var radius: CGFloat { 0 }

    /// Opacity for each tier (Stitch-matched)
    private var alpha: CGFloat {
        switch self {
        case .subtle: 0.08
        case .medium: 0.12
        case .strong: 0.18
        }
    }

    /// Light mode: editorial black at tier opacity. Dark mode: pure black at 40%.
    var color: Color {
        let a = alpha
        return Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(hex: 0x000000, alpha: 0.40)
                : UIColor(hex: 0x0D121B, alpha: a)
        })
    }
}

// MARK: - Shadow View Extension

extension View {
    func alcheShadow(_ shadow: AlcheShadow = .subtle) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}

// MARK: - Animation Tokens

extension Animation {
    static let alcheDefault = Animation.easeInOut(duration: 0.3)
    static let alcheQuick = Animation.easeOut(duration: 0.15)
    static let alcheSpring = Animation.spring(response: 0.5, dampingFraction: 0.8)

    /// 6s ease-in-out repeat -- breathing / pulsing UI elements
    static let alcheBreathing = Animation.easeInOut(duration: 6.0).repeatForever(autoreverses: true)

    /// 3s linear repeat -- scan line / sweep effects
    static let alcheScanLine = Animation.linear(duration: 3.0).repeatForever(autoreverses: false)
}

// MARK: - Preview

#Preview("Shadows") {
    VStack(spacing: 32) {
        RoundedRectangle(cornerRadius: AlcheRadii.sm)
            .fill(Color.alcheWhite)
            .frame(width: 200, height: 80)
            .alcheShadow(.subtle)
            .overlay(Text("Subtle").font(.alcheCaption))

        RoundedRectangle(cornerRadius: AlcheRadii.sm)
            .fill(Color.alcheWhite)
            .frame(width: 200, height: 80)
            .alcheShadow(.medium)
            .overlay(Text("Medium").font(.alcheCaption))

        RoundedRectangle(cornerRadius: AlcheRadii.sm)
            .fill(Color.alcheWhite)
            .frame(width: 200, height: 80)
            .alcheShadow(.strong)
            .overlay(Text("Strong").font(.alcheCaption))
    }
    .padding(40)
    .background(Color.alcheBackground)
}
