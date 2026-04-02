import SwiftUI

// MARK: - Error View

struct AlcheErrorView: View {
    let message: String
    var retryAction: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: AlcheSpacing.lg) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 40))
                .foregroundStyle(Color.alcheError.opacity(0.7))

            VStack(spacing: AlcheSpacing.sm) {
                Text("Something went wrong")
                    .font(.alcheHeading)
                    .foregroundStyle(Color.alchePrimaryText)

                Text(message)
                    .font(.alcheBody)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            if let retryAction {
                AlcheButton("Try Again", style: .secondary, icon: "arrow.clockwise", action: retryAction)
                    .frame(maxWidth: 200)
            }
        }
        .padding(AlcheSpacing.xxl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.alcheBackground)
    }
}

// MARK: - Preview

#Preview("Error") {
    AlcheErrorView(
        message: "We couldn't load your sessions. Check your connection and try again."
    ) {}
}
