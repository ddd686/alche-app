import SwiftUI

// MARK: - Button Style

enum AlcheButtonStyle {
    /// Space Mono 10pt uppercase text + 2px bottom border in primary blue
    case primary
    /// Body text + 1px border box, 2px corner radius
    case secondary
    /// Body text, muted color, no chrome
    case ghost
    /// Space Mono uppercase text, underline decoration, primary blue
    case underline
}

// MARK: - Button Component

struct AlcheButton: View {
    let title: String
    let style: AlcheButtonStyle
    let icon: String?
    let isLoading: Bool
    let isFullWidth: Bool
    let action: () -> Void

    init(
        _ title: String,
        style: AlcheButtonStyle = .primary,
        icon: String? = nil,
        isLoading: Bool = false,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.icon = icon
        self.isLoading = isLoading
        self.isFullWidth = isFullWidth
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            buttonContent
        }
        .disabled(isLoading)
        .animation(.alcheQuick, value: isLoading)
    }

    @ViewBuilder
    private var buttonContent: some View {
        switch style {
        case .primary:
            primaryContent
        case .secondary:
            secondaryContent
        case .ghost:
            ghostContent
        case .underline:
            underlineContent
        }
    }

    // MARK: - Primary: Mono uppercase + 2px bottom border

    private var primaryContent: some View {
        HStack(spacing: AlcheSpacing.sm) {
            if isLoading {
                ProgressView()
                    .tint(Color.alchePrimary)
                    .scaleEffect(0.8)
            } else if let icon {
                Image(systemName: icon)
                    .font(.system(size: 10))
            }

            Text(title.uppercased())
                .font(.alcheMono)
                .tracking(1.2)
        }
        .font(.system(size: 10, design: .monospaced))
        .foregroundStyle(Color.alchePrimary)
        .padding(.vertical, AlcheSpacing.sm)
        .padding(.horizontal, isFullWidth ? 0 : AlcheSpacing.md)
        .frame(maxWidth: isFullWidth ? .infinity : nil)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.alchePrimary)
                .frame(height: 2)
        }
    }

    // MARK: - Secondary: Body text + 1px border box

    private var secondaryContent: some View {
        HStack(spacing: AlcheSpacing.sm) {
            if isLoading {
                ProgressView()
                    .tint(Color.alcheEditorialBlack)
                    .scaleEffect(0.8)
            } else if let icon {
                Image(systemName: icon)
                    .font(.alcheBody)
            }

            Text(title)
                .font(.alcheBody)
        }
        .foregroundStyle(Color.alcheEditorialBlack)
        .padding(.vertical, 10)
        .padding(.horizontal, AlcheSpacing.md)
        .frame(maxWidth: isFullWidth ? .infinity : nil)
        .background(Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
        .overlay(
            RoundedRectangle(cornerRadius: AlcheRadii.md)
                .stroke(Color.alcheEditorialBlack.opacity(0.20), lineWidth: 1)
        )
    }

    // MARK: - Ghost: Body text, muted, no chrome

    private var ghostContent: some View {
        HStack(spacing: AlcheSpacing.sm) {
            if isLoading {
                ProgressView()
                    .tint(Color.alcheEditorialMuted)
                    .scaleEffect(0.8)
            } else if let icon {
                Image(systemName: icon)
                    .font(.alcheBody)
            }

            Text(title)
                .font(.alcheBody)
        }
        .foregroundStyle(Color.alcheEditorialMuted)
        .padding(.vertical, AlcheSpacing.sm)
        .padding(.horizontal, isFullWidth ? 0 : AlcheSpacing.md)
        .frame(maxWidth: isFullWidth ? .infinity : nil)
    }

    // MARK: - Underline: Mono uppercase + underline decoration

    private var underlineContent: some View {
        HStack(spacing: AlcheSpacing.sm) {
            if isLoading {
                ProgressView()
                    .tint(Color.alchePrimary)
                    .scaleEffect(0.8)
            } else if let icon {
                Image(systemName: icon)
                    .font(.system(size: 10))
            }

            Text(title.uppercased())
                .font(.alcheMono)
                .tracking(1.2)
                .underline()
        }
        .font(.system(size: 10, design: .monospaced))
        .foregroundStyle(Color.alchePrimary)
        .padding(.vertical, AlcheSpacing.sm)
        .padding(.horizontal, isFullWidth ? 0 : AlcheSpacing.md)
        .frame(maxWidth: isFullWidth ? .infinity : nil)
    }
}

// MARK: - Preview

#Preview("Buttons") {
    VStack(spacing: AlcheSpacing.lg) {
        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text("PRIMARY")
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheEditorialMuted)
            AlcheButton("Book Session", style: .primary, icon: "calendar") {}
        }

        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text("SECONDARY")
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheEditorialMuted)
            AlcheButton("View Details", style: .secondary) {}
        }

        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text("GHOST")
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheEditorialMuted)
            AlcheButton("Skip for now", style: .ghost) {}
        }

        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text("UNDERLINE")
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheEditorialMuted)
            AlcheButton("Learn More", style: .underline) {}
        }

        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text("FULL WIDTH PRIMARY")
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheEditorialMuted)
            AlcheButton("Continue", style: .primary, isFullWidth: true) {}
        }

        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text("LOADING")
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheEditorialMuted)
            AlcheButton("Loading...", style: .primary, isLoading: true) {}
        }
    }
    .padding(AlcheSpacing.lg)
    .background(Color.alcheBackground)
}
