import SwiftUI

// MARK: - List Row Component

struct AlcheListRow<Leading: View, Trailing: View>: View {
    let title: String
    var subtitle: String? = nil
    @ViewBuilder let leading: () -> Leading
    @ViewBuilder let trailing: () -> Trailing

    init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder leading: @escaping () -> Leading = { EmptyView() },
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leading = leading
        self.trailing = trailing
    }

    var body: some View {
        HStack(spacing: AlcheSpacing.md) {
            leading()

            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                Text(title)
                    .font(.alcheSubheading)
                    .foregroundStyle(Color.alcheCardText)

                if let subtitle {
                    Text(subtitle)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }

            Spacer()

            trailing()
        }
        .padding(.vertical, AlcheSpacing.sm)
        .padding(.horizontal, AlcheSpacing.md)
        .background(Color.clear)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.alcheEditorialBlack.opacity(0.05))
                .frame(height: 1)
        }
    }
}

// MARK: - Preview

#Preview("List Rows") {
    VStack(spacing: 0) {
        AlcheListRow(
            title: "LED Glow Session",
            subtitle: "15 min — 2 credits"
        ) {
            Image(systemName: "light.max")
                .foregroundStyle(Color.alchePrimary)
                .frame(width: 32, height: 32)
        } trailing: {
            Text("14:30")
                .font(.alcheMono)
                .foregroundStyle(Color.alcheEditorialMuted)
        }

        AlcheListRow(
            title: "Notification Preferences",
            subtitle: "Manage push notifications"
        ) {
            Image(systemName: "bell")
                .foregroundStyle(Color.alchePrimary)
                .frame(width: 32, height: 32)
        } trailing: {
            Image(systemName: "chevron.right")
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheEditorialMuted)
        }

        AlcheListRow(
            title: "Privacy Settings"
        ) {
            Image(systemName: "lock.shield")
                .foregroundStyle(Color.alchePrimary)
                .frame(width: 32, height: 32)
        } trailing: {
            Image(systemName: "chevron.right")
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheEditorialMuted)
        }
    }
    .padding(AlcheSpacing.md)
    .background(Color.alcheBackground)
}
