import SwiftUI

// MARK: - Empty State View

struct AlcheEmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: AlcheSpacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(Color.alcheEditorialAccent)

            VStack(spacing: AlcheSpacing.sm) {
                Text(title)
                    .font(.alcheHeading)
                    .foregroundStyle(Color.alchePrimaryText)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.alcheBody)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            if let actionTitle, let action {
                AlcheButton(actionTitle, style: .primary, action: action)
                    .frame(maxWidth: 240)
            }
        }
        .padding(AlcheSpacing.xxl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.alcheBackground)
    }
}

// MARK: - Preview

#Preview("Empty States") {
    VStack {
        AlcheEmptyStateView(
            icon: "calendar",
            title: "Your journey starts here",
            message: "Book your first LED session and begin your personalised wellness path.",
            actionTitle: "Browse Sessions"
        ) {}
    }
}
